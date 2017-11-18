1. Zbuduj zapytanie, które ponownie znajdzie liczbę klientów z podziałem na płcie. Tym razem w wyniku ma się pojawić wiersz z całkowitą liczbą klientów (użyj klauzuli ROLLUP).
/*V1
SELECT GENDER, COUNT(*)
FROM CUSTOMERS
GROUP BY ROLLUP(GENDER)
ORDER BY GENDER;
*/
2. Zmodyfikuj zapytanie z punktu 1. tak, aby w wierszu podsumowania pojawił się napis "wszyscy" (użyj funkcji GROUPING z konstrukcją CAS).
/*V1
SELECT GENDER, 
CASE WHEN GROUPING(GENDER)=1 THEN 'WSZYSCY'
END AS GR, 
COUNT(*)
FROM CUSTOMERS
GROUP BY ROLLUP(GENDER)
ORDER BY GENDER;
*/
3. Podaj liczby zamówień, realizowane w kolejnych latach przez klientów, w rozbiciu na lata. Wyświetl również podsumowanie zawierające całkowitą liczbę zamówień (użyj klauzuli ROLLUP).
/*V1
SELECT EXTRACT(YEAR FROM ORDER_DATE) AS YEAR ,COUNT(*)
FROM ORDERS
GROUP BY ROLLUP(EXTRACT(YEAR FROM ORDER_DATE));
*/
4. Rozszerz powyższe zapytanie o dodatkowy poziom sumowania – wyświetl również liczbę zamówień realizowanych w poszczególnych miesiącach.
/*V1
SELECT EXTRACT(YEAR FROM ORDER_DATE) AS YEAR,
EXTRACT(MONTH FROM ORDER_DATE) AS MONTH,
COUNT(*)
FROM ORDERS
GROUP BY ROLLUP(EXTRACT(YEAR FROM ORDER_DATE),
EXTRACT(MONTH FROM ORDER_DATE));
*/
5. Zmodyfikuj powyższy wynik, w taki sposób, aby oznaczyć podsumowania tekstem „Miesiące razem”.
/*V1
SELECT EXTRACT(YEAR FROM ORDER_DATE) AS YEAR,
EXTRACT(MONTH FROM ORDER_DATE) AS MONTH, 
CASE WHEN GROUPING(EXTRACT(MONTH FROM ORDER_DATE))=1 THEN 'Miesiace razem' END AS GR,
--GROUPING(EXTRACT(MONTH FROM ORDER_DATE)),
COUNT(*)
FROM ORDERS
GROUP BY ROLLUP(EXTRACT(YEAR FROM ORDER_DATE),
EXTRACT(MONTH FROM ORDER_DATE));
*/
/*V2
SELECT EXTRACT(YEAR FROM ORDER_DATE) AS YEAR,
EXTRACT(MONTH FROM ORDER_DATE) AS MONTH, 
CASE GROUPING_ID(EXTRACT(YEAR FROM ORDER_DATE),EXTRACT(MONTH FROM ORDER_DATE))
WHEN 1 THEN 'Miesiace razem'
WHEN 3 THEN 'Lata razem'
END AS GR,
COUNT(*)
FROM ORDERS
GROUP BY ROLLUP(EXTRACT(YEAR FROM ORDER_DATE),
EXTRACT(MONTH FROM ORDER_DATE));
*/
6. Zbuduj zapytanie, które wyliczy, ilu klientów znajduje się w każdym regionie, w każdym kraju, i w każdym mieście. Dołącz do wyniku również podsumowanie zawierające całkowitą liczbę klientów (użyj klauzuli ROLLUP).
/*V1
SELECT C.CUST_ADDRESS.CITY AS CITY, 
C.CUST_ADDRESS.STATE_PROVINCE AS PROVINCE, 
C.CUST_ADDRESS.COUNTRY_ID AS COUNTRY_ID, 
COUNT(*) AS COUNT
FROM CUSTOMERS C
GROUP BY ROLLUP(C.CUST_ADDRESS.COUNTRY_ID, 
C.CUST_ADDRESS.STATE_PROVINCE,
C.CUST_ADDRESS.CITY);
*/
7. Zbuduj zapytanie, które pokaże, ilu klientów z podziałem na płcie pochodzi z poszczególnych krajów (zastosuj zwykłe grupowanie).
/*V1
SELECT NLS_TERRITORY, GENDER, COUNT(*)
FROM CUSTOMERS
GROUP BY NLS_TERRITORY,GENDER
ORDER BY NLS_TERRITORY;
*/
8. Rozszerz polecenie z poprzedniego punktu w ten sposób, aby w wyniku otrzymać również podsumowanie liczby klientów w każdym kraju bez podziału na płcie, podsumowanie każdej płci bez względu na kraj oraz podsumowanie całkowite. Wynik będzie pełną kostką danych.
/*V1
SELECT NLS_TERRITORY, GENDER, GROUPING(NLS_TERRITORY, GENDER) AS G1, COUNT(*)
FROM CUSTOMERS
GROUP BY CUBE(NLS_TERRITORY,GENDER);
*/
/*V2
SELECT NLS_TERRITORY, GENDER, COUNT(*)
FROM CUSTOMERS
GROUP BY GROUPING SETS(NLS_TERRITORY,GENDER,());
*/
