-- --------------------------------------------
-- PIVOTY
-- --------------------------------------------

--1.	Zbuduj zapytanie, które poka¿e, ilu klientów z podzia³em na p³cie pochodzi
-- z poszczególnych krajów (zastosuj zwyk³e grupowanie).

-- Sprawdzamy ilu mamy klientów
SELECT count(C.CUSTOMER_ID) ILU
FROM CUSTOMERS C;
-- mamy 319

-- Sprawdzamy jaki klient do jakiego kraju jest przypisany
SELECT C.CUSTOMER_ID, C.CUST_ADDRESS.country_id
FROM CUSTOMERS C;
-- mamy 319

-- Grupujemy po krajach i sortujemy  wg rosn¹cej liczby klientów i po nazwie kraju
SELECT count(C.CUSTOMER_ID) ILU, C.CUST_ADDRESS.country_id KRAJ
FROM CUSTOMERS C
GROUP BY C.CUST_ADDRESS.country_id
ORDER BY ILU,KRAJ;
-- zapytanie zwrócio 9 krajów

-- Sprawdzamy ilu mamy klientów po to czy nic nie zgubiliœy w tym zbiorze (dodajemy rollup)
SELECT count(C.CUSTOMER_ID) ILU, C.CUST_ADDRESS.country_id KRAJ
FROM CUSTOMERS C
GROUP BY ROLLUP(C.CUST_ADDRESS.country_id)
ORDER BY ILU,KRAJ;

-- Jeœli chcemy nazwê kraju dodajemy tabelê COUNTRIES 

SELECT count(C.CUSTOMER_ID) ILU, C.CUST_ADDRESS.country_id KRAJ
FROM CUSTOMERS C  JOIN COUNTRIES CO ON C.CUST_ADDRESS.country_id=CO.COUNTRY_ID
GROUP BY ROLLUP(C.CUST_ADDRESS.country_id)
ORDER BY ILU,KRAJ;
-- okazuje siê ¿e jest ju¿ 317 klientów, to znaczy ¿e dwóch nie ma kraju w bazie??
-- Porównujemy wyniki (kopiujemy np do ecxecla albo piszemy zapytanie ) i okazuje siê ¿e nie ma TH


-- Testujemy wiêc FULL JOIN, który poka¿e dopelnienia po obu tabelach, 
-- musimy jednak do selecta dopisaæ nazwê kraju, ¿eby by jakiœ atrybut z drugiej tabeli
-- uwaga trzeba te¿ ten atrybut dopisaæ do ROLL UP -> UWAGA NA NAWIASY!!!
SELECT count(C.CUSTOMER_ID) ILU, C.CUST_ADDRESS.country_id KRAJ, CO.COUNTRY_NAME
FROM CUSTOMERS C  LEFT JOIN COUNTRIES CO ON C.CUST_ADDRESS.country_id=CO.COUNTRY_ID
GROUP BY ROLLUP((C.CUST_ADDRESS.country_id,CO.COUNTRY_NAME))
ORDER BY ILU,KRAJ;


-- uproœcimy przyklad i bêdziemy siê poslugowac skróconym kodem kraju i tylko tabelk¹ CUSTOMERS

-- Wracamy do zadania i poszukujemy teraz dodatkowo podziau na pleæ
-- zamieniamy kolejnosæ kolumn ¿eby byo bardziej czytelne
-- I OCZYWISCIE DOPISUEMY NOWA PLEC W GROUP BY
SELECT C.CUST_ADDRESS.country_id KRAJ, C.GENDER PLEC, count(C.CUSTOMER_ID) ILU
FROM CUSTOMERS C
GROUP BY C.CUST_ADDRESS.country_id, C.GENDER 
ORDER BY ILU,KRAJ;

-- dodajemy rollup i sprawdzamy ilosc klientow w grupach
-- POPRAWIAMY TEZ ORDER BY 

SELECT C.CUST_ADDRESS.country_id KRAJ, C.GENDER PLEC, count(C.CUSTOMER_ID) ILU
FROM CUSTOMERS C
GROUP BY ROLLUP((C.CUST_ADDRESS.country_id, C.GENDER ))
ORDER BY KRAJ, PLEC, ILU;


-- MAMY TO (USUWAMY TYLKO ROLLUP)

SELECT C.CUST_ADDRESS.country_id KRAJ, C.GENDER PLEC, count(C.CUSTOMER_ID) ILU
FROM CUSTOMERS C
GROUP BY C.CUST_ADDRESS.country_id, C.GENDER
ORDER BY KRAJ, PLEC, ILU;


-- 2.	Przekszta³æ powy¿szy wynik w taki sposób, aby wyliczenia liczby klientów 
-- w  poszczególnych krajach pojawi³y siê w dwóch kolumnach: jednej dla kobiet, 
-- drugiej dla mê¿czyzn (u¿yj klauzuli PIVOT).

---- to co mamy dostaæ:
--SELECT * FROM 
--(SELECT ... FROM ...)
--PIVOT (funkcja_agr(<wyra¿enie) [AS alias]
--	[,funkcja_agr(<wyra¿enie>)[AS alias]…]
--	FOR (<lista kolumn przestawnych>) IN (
--		lista_wartoœci_1 [AS alias],
--		lista_wartoœci_2 [AS alias], …
--		)
--       );
       
SELECT * FROM 
(SELECT C.CUST_ADDRESS.country_id KRAJ, c.GENDER GEN, c.CUSTOMER_ID C_ID
  FROM CUSTOMERS c)
  PIVOT (count(C_ID)
    FOR GEN 
    IN ('F' FEMALE,'M' MALE)
    )
;  

--UWAGA !!! W pivocie nie ma aliasów

-- spróbujmy teraz posortowaæ wynik

SELECT * FROM 
(SELECT C.CUST_ADDRESS.country_id KRAJ, c.GENDER GEN, c.CUSTOMER_ID C_ID
  FROM CUSTOMERS c)
  PIVOT (count(C_ID)
    FOR GEN 
    IN ('F' FEMALE,'M' MALE)
    )
ORDER BY KRAJ
;  


--3.	Zbuduj zapytanie, które tym razem poka¿e w kolejnych kolumnach, osobno 
--dla kobiet i mê¿czyzn, œrednie kwotê wydan¹ na zamówienia w podziale na 
--pracowników obs³uguj¹cych klientów

-- Najpierw zobaczymy ile na zamówienia wydaj¹ klienci
-- SPRAWDZAMY ATRYBUTY: 
-- KWOTA ZAMÓWIENIA TO ORDER_TOTAL
-- Pracownik obslugujacy to SALES_REP_ID

SELECT SALES_REP_ID, O.CUSTOMER_ID, O.ORDER_TOTAL
FROM ORDERS O
WHERE  SALES_REP_ID is not null;

-- Teraz sprawdzamy jaka jest plec klientów (l¹czymy z tabel¹ customers

SELECT SALES_REP_ID, CUSTOMER_ID, C.GENDER, O.ORDER_TOTAL
FROM ORDERS O NATURAL JOIN CUSTOMERS C
WHERE  SALES_REP_ID is not null;


-- Grupujemy wedug opiekuna i plci i liczymy sumê


SELECT SALES_REP_ID, C.GENDER, SUM(O.ORDER_TOTAL) SUMA
FROM ORDERS O NATURAL JOIN CUSTOMERS C
WHERE  SALES_REP_ID is not null
GROUP BY SALES_REP_ID, C.GENDER
ORDER BY SALES_REP_ID, C.GENDER;

-- A teraz przeksztalcamy

SELECT * FROM 
(SELECT SALES_REP_ID, C.GENDER, O.ORDER_TOTAL
FROM ORDERS O NATURAL JOIN CUSTOMERS C
WHERE  SALES_REP_ID is not null)
PIVOT (avg(ORDER_TOTAL)
      FOR GENDER IN ('F' FEMALE,'M' MALE)
  );


--4.	Przekszta³æ powy¿sze zapytanie w taki sposób, aby œrednie kwota by³y 
--prezentowana z dok³adnoœci¹ do dwóch miejsc po przecinku.

-- Je¿eli checemy teraz stosowaæ jakieœ funkcje np zaokr¹glenia to robimy to
-- na kolumnach z Pivota


SELECT SALES_REP_ID, ROUND(FEMALE,2) as FEMALE2, ROUND(MALE,2) MALE2 FROM 
(SELECT SALES_REP_ID, C.GENDER, O.ORDER_TOTAL
FROM ORDERS O NATURAL JOIN CUSTOMERS C
WHERE  SALES_REP_ID is not null)
PIVOT (avg(ORDER_TOTAL)
      FOR GENDER IN ('F' FEMALE,'M' MALE)
  );
  

--5.	Z powy¿szego zapytania utwórz perspektywê o nazwie SREDNIE_PIVOT. 
--SprawdŸ, jakie dane udostêpnia perspektywa.

--Tworzymy widok
CREATE VIEW SREDNIE_PIVOT AS 
SELECT SALES_REP_ID, ROUND(FEMALE,0) as FEMALE2, ROUND(MALE,0) MALE2 FROM 
(SELECT SALES_REP_ID, C.GENDER, O.ORDER_TOTAL
FROM ORDERS O NATURAL JOIN CUSTOMERS C
WHERE  SALES_REP_ID is not null)
PIVOT (SUM(ORDER_TOTAL)
      FOR GENDER IN ('F' FEMALE,'M' MALE)
  );

-- sprawdzamy strukturê
  desc SREDNIE_PIVOT;
  
  SELECT * FROM SREDNIE_PIVOT;
  
--  
--6.	Zbuduj zapytanie z klauzul¹ UNPIVOT, które przekszta³ci dane 
--perspektywy  SREDNIE_PIVOT do uk³adu wierszowego.

-- Korzystamy z klauzuli :
--
--(SELECT ... FROM ...)
--UNPIVOT [INCLUDE NULLS | EXCLUDE NULLS](
--(lista kolumn)
--FOR (<lista kolumn przestawnych>) IN (
--lista_kolumn_1 [AS alias],
--lista_kolumn_2 [AS alias], …
--)
--)

SELECT * FROM (
(SELECT SALES_REP_ID, FEMALE2, MALE2 FROM  SREDNIE_PIVOT SP )
UNPIVOT( (SREDNIA)
FOR GENDER3 IN (FEMALE2 as 'FEMALE3', MALE2 as 'MALE3')
));

