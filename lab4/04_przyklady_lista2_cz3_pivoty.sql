-- --------------------------------------------
-- PIVOTY
-- --------------------------------------------

--1.	Zbuduj zapytanie, kt�re poka�e, ilu klient�w z podzia�em na p�cie pochodzi
-- z poszczeg�lnych kraj�w (zastosuj zwyk�e grupowanie).

-- Sprawdzamy ilu mamy klient�w
SELECT count(C.CUSTOMER_ID) ILU
FROM CUSTOMERS C;
-- mamy 319

-- Sprawdzamy jaki klient do jakiego kraju jest przypisany
SELECT C.CUSTOMER_ID, C.CUST_ADDRESS.country_id
FROM CUSTOMERS C;
-- mamy 319

-- Grupujemy po krajach i sortujemy  wg rosn�cej liczby klient�w i po nazwie kraju
SELECT count(C.CUSTOMER_ID) ILU, C.CUST_ADDRESS.country_id KRAJ
FROM CUSTOMERS C
GROUP BY C.CUST_ADDRESS.country_id
ORDER BY ILU,KRAJ;
-- zapytanie zwr�cio 9 kraj�w

-- Sprawdzamy ilu mamy klient�w po to czy nic nie zgubili�y w tym zbiorze (dodajemy rollup)
SELECT count(C.CUSTOMER_ID) ILU, C.CUST_ADDRESS.country_id KRAJ
FROM CUSTOMERS C
GROUP BY ROLLUP(C.CUST_ADDRESS.country_id)
ORDER BY ILU,KRAJ;

-- Je�li chcemy nazw� kraju dodajemy tabel� COUNTRIES 

SELECT count(C.CUSTOMER_ID) ILU, C.CUST_ADDRESS.country_id KRAJ
FROM CUSTOMERS C  JOIN COUNTRIES CO ON C.CUST_ADDRESS.country_id=CO.COUNTRY_ID
GROUP BY ROLLUP(C.CUST_ADDRESS.country_id)
ORDER BY ILU,KRAJ;
-- okazuje si� �e jest ju� 317 klient�w, to znaczy �e dw�ch nie ma kraju w bazie??
-- Por�wnujemy wyniki (kopiujemy np do ecxecla albo piszemy zapytanie ) i okazuje si� �e nie ma TH


-- Testujemy wi�c FULL JOIN, kt�ry poka�e dopelnienia po obu tabelach, 
-- musimy jednak do selecta dopisa� nazw� kraju, �eby by jaki� atrybut z drugiej tabeli
-- uwaga trzeba te� ten atrybut dopisa� do ROLL UP -> UWAGA NA NAWIASY!!!
SELECT count(C.CUSTOMER_ID) ILU, C.CUST_ADDRESS.country_id KRAJ, CO.COUNTRY_NAME
FROM CUSTOMERS C  LEFT JOIN COUNTRIES CO ON C.CUST_ADDRESS.country_id=CO.COUNTRY_ID
GROUP BY ROLLUP((C.CUST_ADDRESS.country_id,CO.COUNTRY_NAME))
ORDER BY ILU,KRAJ;


-- upro�cimy przyklad i b�dziemy si� poslugowac skr�conym kodem kraju i tylko tabelk� CUSTOMERS

-- Wracamy do zadania i poszukujemy teraz dodatkowo podziau na ple�
-- zamieniamy kolejnos� kolumn �eby byo bardziej czytelne
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


-- 2.	Przekszta�� powy�szy wynik w taki spos�b, aby wyliczenia liczby klient�w 
-- w  poszczeg�lnych krajach pojawi�y si� w dw�ch kolumnach: jednej dla kobiet, 
-- drugiej dla m�czyzn (u�yj klauzuli PIVOT).

---- to co mamy dosta�:
--SELECT * FROM 
--(SELECT ... FROM ...)
--PIVOT (funkcja_agr(<wyra�enie) [AS alias]
--	[,funkcja_agr(<wyra�enie>)[AS alias]�]
--	FOR (<lista kolumn przestawnych>) IN (
--		lista_warto�ci_1 [AS alias],
--		lista_warto�ci_2 [AS alias], �
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

--UWAGA !!! W pivocie nie ma alias�w

-- spr�bujmy teraz posortowa� wynik

SELECT * FROM 
(SELECT C.CUST_ADDRESS.country_id KRAJ, c.GENDER GEN, c.CUSTOMER_ID C_ID
  FROM CUSTOMERS c)
  PIVOT (count(C_ID)
    FOR GEN 
    IN ('F' FEMALE,'M' MALE)
    )
ORDER BY KRAJ
;  


--3.	Zbuduj zapytanie, kt�re tym razem poka�e w kolejnych kolumnach, osobno 
--dla kobiet i m�czyzn, �rednie kwot� wydan� na zam�wienia w podziale na 
--pracownik�w obs�uguj�cych klient�w

-- Najpierw zobaczymy ile na zam�wienia wydaj� klienci
-- SPRAWDZAMY ATRYBUTY: 
-- KWOTA ZAM�WIENIA TO ORDER_TOTAL
-- Pracownik obslugujacy to SALES_REP_ID

SELECT SALES_REP_ID, O.CUSTOMER_ID, O.ORDER_TOTAL
FROM ORDERS O
WHERE  SALES_REP_ID is not null;

-- Teraz sprawdzamy jaka jest plec klient�w (l�czymy z tabel� customers

SELECT SALES_REP_ID, CUSTOMER_ID, C.GENDER, O.ORDER_TOTAL
FROM ORDERS O NATURAL JOIN CUSTOMERS C
WHERE  SALES_REP_ID is not null;


-- Grupujemy wedug opiekuna i plci i liczymy sum�


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


--4.	Przekszta�� powy�sze zapytanie w taki spos�b, aby �rednie kwota by�y 
--prezentowana z dok�adno�ci� do dw�ch miejsc po przecinku.

-- Je�eli checemy teraz stosowa� jakie� funkcje np zaokr�glenia to robimy to
-- na kolumnach z Pivota


SELECT SALES_REP_ID, ROUND(FEMALE,2) as FEMALE2, ROUND(MALE,2) MALE2 FROM 
(SELECT SALES_REP_ID, C.GENDER, O.ORDER_TOTAL
FROM ORDERS O NATURAL JOIN CUSTOMERS C
WHERE  SALES_REP_ID is not null)
PIVOT (avg(ORDER_TOTAL)
      FOR GENDER IN ('F' FEMALE,'M' MALE)
  );
  

--5.	Z powy�szego zapytania utw�rz perspektyw� o nazwie SREDNIE_PIVOT. 
--Sprawd�, jakie dane udost�pnia perspektywa.

--Tworzymy widok
CREATE VIEW SREDNIE_PIVOT AS 
SELECT SALES_REP_ID, ROUND(FEMALE,0) as FEMALE2, ROUND(MALE,0) MALE2 FROM 
(SELECT SALES_REP_ID, C.GENDER, O.ORDER_TOTAL
FROM ORDERS O NATURAL JOIN CUSTOMERS C
WHERE  SALES_REP_ID is not null)
PIVOT (SUM(ORDER_TOTAL)
      FOR GENDER IN ('F' FEMALE,'M' MALE)
  );

-- sprawdzamy struktur�
  desc SREDNIE_PIVOT;
  
  SELECT * FROM SREDNIE_PIVOT;
  
--  
--6.	Zbuduj zapytanie z klauzul� UNPIVOT, kt�re przekszta�ci dane 
--perspektywy  SREDNIE_PIVOT do uk�adu wierszowego.

-- Korzystamy z klauzuli :
--
--(SELECT ... FROM ...)
--UNPIVOT [INCLUDE NULLS | EXCLUDE NULLS](
--(lista kolumn)
--FOR (<lista kolumn przestawnych>) IN (
--lista_kolumn_1 [AS alias],
--lista_kolumn_2 [AS alias], �
--)
--)

SELECT * FROM (
(SELECT SALES_REP_ID, FEMALE2, MALE2 FROM  SREDNIE_PIVOT SP )
UNPIVOT( (SREDNIA)
FOR GENDER3 IN (FEMALE2 as 'FEMALE3', MALE2 as 'MALE3')
));

