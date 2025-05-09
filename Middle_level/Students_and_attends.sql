/*
 * Запрос для получения отчетности по посещаемости экзаменов
 * Возвращает всех студентов, все предметы и количество сданных экзаменов
 * Для студентов, не сдававших экзамен по предмету, выводится 0
 */
WITH attends AS(
    -- Считаем количество экзаменов, сданных каждым студентом по каждому предмету
    SELECT  student_id, subject_name, COUNT(*) attended_exams
    FROM Examinations
    GROUP BY student_id, subject_name
)
-- Объединение с помощью кросс-джоин для создания шаблонного формата, лефт-джоин - для кол-ва посещений студентами и 
SELECT
    S.student_id, 
    S.student_name, 
    SB.subject_name, 
    -- Заменяем NULL на 0 для предметов, по которым студент не сдавал экзамены
    COALESCE(A.attended_exams, 0) attended_exams
FROM Students S 
-- Создаем все возможные пары "студент-предмет"
CROSS JOIN Subjects SB
-- Добавляем информацию о фактически сданных экзаменах
LEFT JOIN attends A ON A.student_id = S.student_id 
                    AND A.subject_name = SB.subject_name
ORDER BY S.student_id, SB.subject_name;
