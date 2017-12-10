1. Zbuduj zapytanie, które pokaże, ilu klientów z podziałem na płcie pochodzi z poszczególnych krajów (zastosuj zwykłe grupowanie).
/*V1
SELECT NLS_TERRITORY, GENDER, COUNT(*)
FROM CUSTOMERS
GROUP BY (NLS_TERRITORY,GENDER)
ORDER BY NLS_TERRITORY;
*/
2. Przekształć powyższy wynik w taki sposób, aby wyliczenia liczby klientów w poszczególnych krajach pojawiły się w dwóch kolumnach: jednej dla kobiet, drugiej dla mężczyzn (użyj klauzuli PIVOT).
/*V1
SELECT * FROM
(SELECT C.CUST_ADDRESS.COUNTRY_ID AS KRAJ, C.GENDER GEN, CCUSTOMER_ID C_ID
FROM CUSTOMERS C)
PIVOT (COUNT(C_ID)
  FOR GEN
  IN('F' FEMALE, 'M' MALE)
  )
ORDER BY KRAJ;
*/
3. Zbuduj zapytanie, które tym razem pokaże w kolejnych kolumnach, osobno dla kobiet i mężczyzn, średnie kwotę wydaną na zamówienia w podziale na pracowników obsługujących klientów
/*V1
SELECT * FROM 
(SELECT O.SALES_REP_ID S_ID, CC.GENDER GEN, O.ORDER_TOTAL
FROM CUSTOMERS CC JOIN ORDERS O
ON CC.CUSTOMER_ID=O.CUSTOMER_ID)
  PIVOT (AVG(ORDER_TOTAL)
    FOR GEN 
    IN ('F' FEMALE,'M' MALE)
    )
ORDER BY S_ID
;
*/
4. Przekształć powyższe zapytanie w taki sposób, aby średnie kwota były prezentowana z dokładnością do dwóch miejsc po przecinku.
/*V1
SELECT S_ID,ROUND(FEMALE,2),ROUND(MALE,2) FROM 
(SELECT O.SALES_REP_ID S_ID, CC.GENDER GEN, O.ORDER_TOTAL
FROM CUSTOMERS CC JOIN ORDERS O
ON CC.CUSTOMER_ID=O.CUSTOMER_ID)
  PIVOT (AVG(ORDER_TOTAL)
    FOR GEN 
    IN ('F' FEMALE,'M' MALE)
    )
ORDER BY S_ID
; 
*/
5. Z powyższego zapytania utwórz perspektywę o nazwie SREDNIE_PIVOT. Sprawdź, jakie dane udostępnia perspektywa.
/*V1
SELECT S_ID,ROUND(FEMALE,2),ROUND(MALE,2) FROM 
(SELECT O.SALES_REP_ID S_ID, CC.GENDER GEN, O.ORDER_TOTAL
FROM CUSTOMERS CC JOIN ORDERS O
ON CC.CUSTOMER_ID=O.CUSTOMER_ID)
  PIVOT (AVG(ORDER_TOTAL)
    FOR GEN 
    IN ('F' FEMALE,'M' MALE)
    )
ORDER BY S_ID
; 
*/
/*V2
CREATE VIEW SREDNIE_PIVOT_5 AS
SELECT S_ID,ROUND(FEMALE,2) AS FEMALE ,ROUND(MALE,2) AS MALE FROM 
(SELECT O.SALES_REP_ID S_ID, CC.GENDER GEN, O.ORDER_TOTAL
FROM CUSTOMERS CC JOIN ORDERS O
ON CC.CUSTOMER_ID=O.CUSTOMER_ID)
  PIVOT (AVG(ORDER_TOTAL)
    FOR GEN 
    IN ('F' FEMALE,'M' MALE)
    )
ORDER BY S_ID;
*/
6. Zbuduj zapytanie z klauzulą UNPIVOT, które przekształci dane perspektywy SREDNIE_PIVOT do układu wierszowego.
/*V1
*/
