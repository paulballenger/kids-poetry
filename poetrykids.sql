--1a
SELECT grade_id, SUM(grade_id) AS poets_in_grade
FROM author
GROUP BY grade_id
ORDER By grade_id;
/*
1: 623
2: 2874
3: 7032
4: 13152
5: 17320
*/

--1b
SELECT COUNT(*) AS Female
FROM author
WHERE gender_id = 1
LIMIT 10;

SELECT COUNT(*) AS Male
FROM author
WHERE gender_id = 2
LIMIT 10;
--Female: 4331
--Male: 2632

--1c
SELECT grade_id, SUM(grade_id) AS poets_in_grade,
		CASE WHEN gender_id = 1 THEN 'Female'
		WHEN gender_id = 2 THEN 'Male'
		ELSE 'NA'
		END AS gender								
FROM author
GROUP BY grade_id, gender
ORDER By grade_id;
-- more males than females
--2
SELECT COUNT(*), ROUND(AVG(char_count),2),
		CASE WHEN LOWER(text) LIKE '%love%' OR LOWER(title) LIKE '%love%' THEN 'Love'
		WHEN LOWER(text) LIKE '%death%' OR LOWER(title) LIKE '%death%' THEN 'Death'
		END AS love_death
FROM poem
GROUP BY love_death;
--love 225
--death 323

--3a
SELECT emotion.name, poem.char_count
FROM poem INNER JOIN poem_emotion USING(id) 
INNER JOIN emotion USING(id)
ORDER BY poem.char_count DESC;
-- Sadness: 491
-- Joy: 74

--3b
WITH joy_count AS (SELECT id, emotion.name, poem.char_count
			FROM poem INNER JOIN poem_emotion USING(id) 
			INNER JOIN emotion USING(id)
				  WHERE name = 'Joy')
SELECT title, intensity_percent
FROM poem INNER JOIN poem_emotion USING(id)
INNER JOIN joy_count USING(id)				  
GROUP BY title DESC
LIMIT 5;
				  
SELECT intensity_percent, poem.title, joy_count.char_count, 
	AVG(poem.char_count)::integer
FROM poem_emotion INNER JOIN poem USING(id)
INNER JOIN joy_count USING(id)
GROUP BY intensity_percent, poem.title, joy_count.char_count
ORDER BY poem_emotion.intensity_percent DESC
LIMIT 5;

 


--4a
SELECT author.grade_id, emotion.name, COUNT(poem.title)
FROM author INNER JOIN poem USING(id)
INNER JOIN poem_emotion USING(id)
INNER JOIN emotion USING(id)
WHERE emotion.name LIKE 'Anger'
AND author.grade_id = 1
OR author.grade_id = 5
GROUP BY author.grade_id, emotion.name

