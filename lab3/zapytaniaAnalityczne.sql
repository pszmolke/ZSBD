cw3 - cz1
1.
/*V1
SELECT PROD_SUBCATEGORY, COUNT(*),
RANK() OVER(ORDER BY COUNT(*) DESC) RANKING
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY);
*/
2.
/*V1
SELECT PROD_SUBCATEGORY, COUNT(*),
DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) RANKING
FROM H_PRODUCTS
GROUP BY (PROD_SUBCATEGORY);
*/
3.
4.
5.
6.
7.
8.
