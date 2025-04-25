# SQL Solutions Repository

![SQL](https://img.shields.io/badge/SQL-Intermediate%2B-blue)
![LeetCode](https://img.shields.io/badge/LeetCode-Solutions-orange)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Compatible-brightgreen)

Решения задач среднего и повышенного уровня сложности по SQL из различных источников с подробными объяснениями и оптимизациями.

## 📌 О репозитории

Коллекция тщательно подобранных SQL-решений для сложных задач, преимущественно с LeetCode. Каждое решение содержит:

- Подробные комментарии в коде
- Анализ производительности
- Альтернативные подходы
- Оптимизированные запросы

## 🔍 Пример решения

```sql
/*
 * Расчет среднего процента срочных первых доставок 
 * (LeetCode #1174 - Immediate Food Delivery II)
 *
 * Особенности:
 * - Только первые заказы каждого пользователя
 * - Оптимизированное CTE с оконными функциями
 * - Производительность: быстрее 94.43% решений
 */

WITH first_orders AS (
    SELECT 
        CASE
            WHEN order_date = customer_pref_delivery_date THEN 1
            ELSE 0
        END AS is_immediate,
        RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS order_rank
    FROM Delivery
)
SELECT ROUND(AVG(is_immediate)*100, 2) AS immediate_percentage
FROM first_orders
WHERE order_rank = 1;
