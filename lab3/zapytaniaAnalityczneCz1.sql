1. Zbuduj zapytanie, które dla każdej podkategorii znajdzie liczbę produktów do niej należących. 
Następnie utwórz ranking podkategorii ze względu liczbę na produktów.
/*V1
SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
RANK() OVER(ORDER BY COUNT(*) DESC) RANKING
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID);
*/
2. Zmodyfikuj zapytanie z p. 1 w taki sposób, aby w zbiorze wynikowym pojawiła się dodatkowa 
kolumna pokazująca ranking gęsty. Czy występują różnice pomiędzy rankingami?
/*V1
SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
RANK() OVER(ORDER BY COUNT(*) DESC) RANKING,
DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) RANKING_DENSE
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID);
*/
3. Zmodyfikuj zapytanie z poprzedniego punktu w taki sposób, aby otrzymać dane jedynie trzech 
pierwszych podkategorii w rankingu (weź pod uwagę ranking zwykły).
/*V1
SELECT * FROM (
  SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
  RANK() OVER(ORDER BY COUNT(*) DESC) RANKING,
  DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) RANKING_DENSE
  FROM H_PRODUCTS
  GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID))
WHERE RANKING < 4;
*/
4. Dokonaj kolejnej modyfikacji zapytania, tym razem chcemy uzyskać informacje o pięciu najmniej 
Licznych podkategoriach (ponownie użyj zwykłego rankingu).
/*V1
SELECT * FROM (
  SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
  RANK() OVER(ORDER BY COUNT(*) ASC) RANKING
  FROM H_PRODUCTS
  GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID))
WHERE RANKING < 5;
*/
5. Przekształć ranking, uzyskany w zadaniu 1., w ranking procentowy (użyj funkcji PERCENT_RANK). 
Ogranicz wynik do dwóch pozycji po przecinku.
/*V1
SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
ROUND(PERCENT_RANK() OVER(ORDER BY COUNT(*) DESC),2) RANKING
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID);
*/
6. Zmodyfikuj zapytanie z punktu poprzedniego w taki sposób, aby otrzymać informacje o podkategoriach, 
które lokują się w 25% najliczniej obsadzonych podkategorii.
/*V1
WITH RANKING_TAB AS (
  SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
  ROUND(PERCENT_RANK() OVER(ORDER BY COUNT(*) DESC),2) AS RANKING
  FROM H_PRODUCTS
  GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID))
SELECT * FROM RANKING_TAB
WHERE RANKING < 0.25;
*/
7. Dodaj do wyniku zadania 6. kolumnę wyliczającą percentyle (funkcja CUME_DIST). Porównaj wyniki uzyskane 
w kolumnach RANKING_PROC i PERCENTYL.
WITH RANKING_TAB AS (
/*V1
WITH RANKING_TAB AS (
  SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
  ROUND(PERCENT_RANK() OVER(ORDER BY COUNT(*) DESC),2) AS RANKING,
  CUME_DIST() OVER(ORDER BY COUNT(*) DESC) AS PERCENTYL
  FROM H_PRODUCTS
  GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID))
SELECT * FROM RANKING_TAB
WHERE RANKING < 0.25;
*/
8. Podaj hipotetyczną pozycję w rankingu podkategorii, która zawiera dokładnie 9 produktów. Użyj rankingu 
zwykłego.
/*V1
SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
RANK() OVER(ORDER BY COUNT(*) DESC) RANKING
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID);

SELECT RANK(9) WITHIN GROUP
  (ORDER BY COUNT(*) DESC) AS POSITION
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID);
*/
9. Przydziel każdej pozycji w rankingu podkategorii z punktu 1. unikalny numer porządkowy (wykorzystaj 
funkcję ROW_NUMBER). Porównaj numer porządkowy rekordu z pozycją w rankingu.
/*V1
SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
RANK() OVER(ORDER BY COUNT(*) DESC) RANKING,
ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ROW_NUMBER
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID);
*/
10. Podziel podkategorie na cztery "koszyki" w zależności od ich pozycji w rankingu zbudowanym wg 
liczby produktów. W każdym koszyku powinno znaleźć się tyle samo podkategorii (liczby podkategorii w poszczególnych koszykach mogą się różnić o co najwyżej 1).
