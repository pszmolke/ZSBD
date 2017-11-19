1. Zbuduj zapytanie, które znajdzie liczbę wszystkich klientów (tabela CUSTOMERS ).
/*V1
SELECT COUNT(*)
FROM CUSTOMERS;
*/
2. Zmodyfikuj powyższe zapytanie w taki sposób, aby otrzymać liczbę klientów z podziałem na płeć (atrybut gender). Wynik posortuj wg płci.
/*V1
SELECT GENDER, COUNT(*)
FROM CUSTOMERS
GROUP BY GENDER
ORDER BY GENDER;
*/
3. Policz, ile zamówień realizowali klienci w roku 2007 (tabela ORDERS).
/*V1
SELECT COUNT(*)
FROM ORDERS
WHERE EXTRACT(YEAR FROM ORDER_DATE) = 2007;
*/
4. Rozszerz poprzednie zapytanie w taki sposób, aby otrzymać liczbę zamówień w roku 2007 z podziałem na tryb zamówienia: direct lub online.
/*V1
SELECT ORDER_MODE, COUNT(*)
FROM ORDERS
WHERE EXTRACT(YEAR FROM ORDER_DATE) = 2007
GROUP BY ORDER_MODE;
*/
5. Ogranicz analizy zamówień do zamówień online. Poznaj rozkład statusów w tym trybie (rozkład statusów – liczba wystąpień danego statusu zamówienia).
/*V1
SELECT ORDER_MODE, ORDER_STATUS, COUNT(*)
FROM ORDERS
WHERE EXTRACT(YEAR FROM ORDER_DATE) = 2007 
AND ORDER_MODE='online'
GROUP BY ORDER_MODE, ORDER_STATUS;
*/
/*V2
SELECT ORDER_MODE, ORDER_STATUS, COUNT(*)
FROM ORDERS
WHERE EXTRACT(YEAR FROM ORDER_DATE) = 2007 
GROUP BY ORDER_MODE, ORDER_STATUS
HAVING ORDER_MODE='online';
*/
6. Rozszerz poprzednie zapytanie w taki sposób aby pominąć rekordy o statusie=0.
/*V1
SELECT ORDER_MODE, ORDER_STATUS, COUNT(*)
FROM ORDERS
WHERE EXTRACT(YEAR FROM ORDER_DATE) = 2007 
GROUP BY ORDER_MODE, ORDER_STATUS
HAVING ORDER_MODE='online' AND ORDER_STATUS != 0;
*/
7. Tym razem podziel zbiór zamówień online na trzy kategorie: "entered": 0 i 1, "canceled": 2 oraz 3 i "shipped": 4,5,6,7,8,9,10. Znajdź liczbę zamówień w każdej kategorii. Wykorzystaj konstrukcję CASE.
/*V1
SELECT ORDER_MODE, ORDER_STATUS,
CASE
WHEN ORDER_STATUS IN (0,1) THEN 'ENTERED'
WHEN ORDER_STATUS IN (2,3) THEN 'CANCELED'
ELSE 'SHIPPED'
END AS KATEGORIA, COUNT(*)
FROM ORDERS
WHERE EXTRACT(YEAR FROM ORDER_DATE) = 2007 
GROUP BY ORDER_MODE, ORDER_STATUS
HAVING ORDER_MODE='online';
*/
/*V2
with  LISTA AS(
SELECT order_mode, order_status,
CASE
WHEN ORDER_STATUS IN (0,1) THEN 'ENTERED'
WHEN ORDER_STATUS IN (2,3) THEN 'CANCELED'
ELSE 'SHIPPED'
END AS KATEGORIA
FROM ORDERs
WHERE EXTRACT(YEAR FROM ORDER_DATE) = 2007 AND ORDER_MODE ='online'
)
SELECT count(order_status), KATEGORIA
FROM lista
GROUP BY KATEGORIA
*/
8. Policz, ilu klientów przypada na poszczególnych pracowników.Posortuj wynik wg malejącej liczby klientów.
/*V1
SELECT EMPLOYEES.EMPLOYEE_ID, CUSTOMERS.ACCOUNT_MGR_ID, COUNT(CUSTOMERS.ACCOUNT_MGR_ID)
FROM EMPLOYEES LEFT JOIN CUSTOMERS
ON EMPLOYEES.EMPLOYEE_ID=CUSTOMERS.ACCOUNT_MGR_ID
GROUP BY EMPLOYEES.EMPLOYEE_ID, CUSTOMERS.ACCOUNT_MGR_ID
ORDER BY CUSTOMERS.ACCOUNT_MGR_ID ASC;
*/
9. Rozbuduj poprzednie zapytanie w taki sposób, aby pominąć pracowników, którzy obsługują
mniej niż 70 osób (użyj w zapytaniu klauzuli HAVING).
/*V1
SELECT EMPLOYEES.EMPLOYEE_ID, CUSTOMERS.ACCOUNT_MGR_ID, COUNT(CUSTOMERS.ACCOUNT_MGR_ID)
FROM EMPLOYEES LEFT JOIN CUSTOMERS
ON EMPLOYEES.EMPLOYEE_ID=CUSTOMERS.ACCOUNT_MGR_ID
GROUP BY EMPLOYEES.EMPLOYEE_ID, CUSTOMERS.ACCOUNT_MGR_ID
HAVING COUNT(CUSTOMERS.ACCOUNT_MGR_ID)>=70
ORDER BY CUSTOMERS.ACCOUNT_MGR_ID ASC;
*/
