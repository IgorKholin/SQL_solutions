/*
 * Анализ распределения счетов по категориям дохода
 * 
 * Запрос выполняет:
 * 1. Категоризацию счетов на 3 группы по уровню дохода
 * 2. Подсчет количества счетов в каждой категории
 * 3. Гарантированный вывод всех категорий, даже если счетов в них нет
 *
 * Оптимизация:
 * - Использует CASE для эффективной категоризации
 * - Группирует данные перед соединением
 * - Обеспечивает полный вывод категорий через LEFT JOIN
 * - Производительность: обгоняет 81% решений на LeetCode
 */

WITH CATS AS (
    -- Первый этап: категоризация счетов по доходу
    SELECT 
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
            ELSE 'High Salary'
        END AS category 
    FROM Accounts
),

-- Второй этап: подсчет количества счетов по категориям
CATS_NUMBER AS (
    SELECT 
        category, 
        COUNT(*) AS accounts_count
    FROM CATS
    GROUP BY category
),

-- Третий этап: создание эталонного списка всех категорий
CATEGORIES AS (
    SELECT 'Low Salary' AS CATEG
    UNION ALL 
    SELECT 'Average Salary'
    UNION ALL 
    SELECT 'High Salary'
)

-- Финальный результат: соединение с гарантией всех категорий
SELECT 
    CATEGORIES.CATEG AS category, 
    COALESCE(accounts_count, 0) AS accounts_count 
FROM CATEGORIES
LEFT JOIN CATS_NUMBER ON CATEGORIES.CATEG = CATS_NUMBER.category;
