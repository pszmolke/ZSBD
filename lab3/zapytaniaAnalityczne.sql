cw3 - cz1
1.
/*V1
SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
RANK() OVER(ORDER BY COUNT(*) DESC) RANKING
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID);
*/
2.
/*V1
SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
RANK() OVER(ORDER BY COUNT(*) DESC) RANKING,
DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) RANKING_DENSE
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID);
*/
3.
/*V1 -- DO POPRAWKI
SELECT * FROM (
  SELECT PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID, COUNT(*),
  RANK() OVER(ORDER BY COUNT(*) DESC) RANKING,
  FROM H_PRODUCTS
  GROUP BY (PROD_SUBCATEGORY,PROD_SUBCATEGORY_ID))
WHERE RAKING < 4;
*/
4.
/*V1

*/
5.
6.
7.
8.
