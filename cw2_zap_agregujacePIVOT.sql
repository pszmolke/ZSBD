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
(SELECT NLS_TERRITORY, GENDER
FROM CUSTOMERS
GROUP BY NLS_TERRITORY,GENDER)
PIVOT(COUNT(*) FOR GENDER IN
('F' AS FEMALE,
'M' AS MALE));
*/
3. Zbuduj zapytanie, które tym razem pokaże w kolejnych kolumnach, osobno dla kobiet i mężczyzn, średnie kwotę wydaną na zamówienia w podziale na pracowników obsługujących klientów
/*V1
*/
4. Przekształć powyższe zapytanie w taki sposób, aby średnie kwota były prezentowana z dokładnością do dwóch miejsc po przecinku.
/*V1
*/
5. Z powyższego zapytania utwórz perspektywę o nazwie SREDNIE_PIVOT. Sprawdź, jakie dane udostępnia perspektywa.
/*V1
*/
6. Zbuduj zapytanie z klauzulą UNPIVOT, które przekształci dane perspektywy SREDNIE_PIVOT do układu wierszowego.
/*V1
*/