-- Netflix project
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(20),
    title VARCHAR(255),
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(255),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(20),
    duration VARCHAR(50),
    listed_in TEXT,
    description TEXT
);

SELECT COUNT(*) FROM netflix;

SELECT * FROM netflix;



TRUNCATE TABLE netflix;


SHOW VARIABLES LIKE 'local_infile';



-- 1. Count the Number of Movies vs TV Shows

SELECT
	type,
    COUNT(*) AS total_amount
FROM netflix
GROUP BY 1;

-- 2. Find the Most Common Rating for Movies and TV Shows




SELECT
    type,
    rating
FROM
(
    SELECT
        type,
        rating,
        COUNT(*),
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking -- Corrected alias
    FROM netflix
    GROUP BY 1, 2
) as t1
WHERE ranking = 1;


-- 3. List All Movies Released in a Specific Year (e.g., 2020)


SELECT * FROM netflix
WHERE
    type = 'Movie'
AND
    release_year = 2020;
    
-- 4. Identify the Longest Movie

SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;


-- 5. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;

-- 6. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- 7. List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
  
  
  -- 8. Find each year and the average numbers of content release in United States on netflix.
  
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        (COUNT(show_id) / 
        (SELECT COUNT(show_id) 
         FROM netflix 
         WHERE country LIKE '%United States%')) * 100, 2
    ) AS avg_release
FROM netflix
WHERE country LIKE '%United States%'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
  
-- 9. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

-- 10.  Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;

-- 11.  Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix;

SELECT *
FROM netflix
WHERE cast LIKE '%Salman Khan%'
AND release_year >= YEAR(CURDATE()) - 10;

-- 12. Categorize Content Based on the Presence of 'Mafia' and 'Violence' Keywords

SELECT
    category,
    COUNT(*) AS content_count
FROM (
    SELECT
        CASE
            WHEN description LIKE '%mafia%' OR description LIKE '%violence%' THEN 'Violent content'
            ELSE 'Neutral'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;