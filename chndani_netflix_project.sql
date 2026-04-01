--- Netflix Project

Create table netflix
(
	show_id	  VARCHAR(6),
	type	  VARCHAR(10),
	title	   VARCHAR(150),
	director     VARCHAR(208),
	castS	    VARCHAR(1000),
	country	     VARCHAR(150),
	date_added   VARCHAR(50),
	release_year  INT,
	rating     VARCHAR(10),
	duration	 VARCHAR(15),
	listed_in     VARCHAR(100),
	description   VARCHAR(250)
);

SELECT * FROM netflix;
--- checking if we have imported data correctly or NOT
-- SELECT 
-- 	COUNT(*) AS TOtal_Content
-- from netflix;

select 
	DISTINCT TYPE
from netflix;



---15.Business Problems

-- 1. count the no of movies vs tv shows

select 
	type,
	count(*) as total_content
from netflix
group by type


-- 2.Find Most Common Rating for movies and tv shows

SELECT
	TYPE,
	rating
FROM
(
	select type,
		rating,
		count(*),
		Rank()over (PARTITION BY TYPE ORDER BY COUNT(*)DESC) AS RANKING
	from netflix
	group by 1,2
) as t1
where
	ranking = 1

--3.List all movies released in a specific year (e.g.,2020)
-- fILTER BY 2020
-- MOVIE

select * from netflix
WHERE type ='Movie'
	AND
	release_year = 2020
	
--4. Find the top 5 countries with the most content on netflix

select 
	UNNEST(STRING_TO_ARRAY(country, ','))as new_country,
	COUNT(show_id) as total_content
from netflix
group by 1
ORDER BY 2 DESC
LIMIT 5


select 
	UNNEST(STRING_TO_ARRAY(country, ','))AS new_country
FROM netflix

-- 5.identify the longest movie?

SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	duration = (select MAX(duration)from netflix)

--6. Find Content added in last 5 year

select 
	*
FROM netflix
where 
	TO_Date(date_added, 'Month DD,YYYY')>= CURRENT_DATE -INTERVAL '5 YEARS'

SELECT CURRENT_DATE -INTERVAL '5 YEARS'


-- 7. Find all the movies/Tv shows by director 'Rajiv chilaka'1!


select * from netflix
where director ILIKE '%Rajiv Chilaka%'


-- 8.List all tv shows with more than 5 seasons

select 
	* 
from netflix
where 
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ',1)::numeric > 5 

--9.count the number of content items in each genre

select 
	UNNEST(STRING_TO_ARRAY(LISTED_IN,','))AS TOTAL_CONTENT,
	COUNT(show_id)
from netflix
GROUP BY 1


--10.Find each year and the average number of content release by india on netflix.
return top 5 year with highest avg content release;

select 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYY'))AS YEAR,
	COUNT(*)
from netflix
where country = 'India'
GROUP BY 1



--11.List all movies that are documentaries

select * from netflix
	WHERE 
		listed_in ILIKE '%DOCUMENTARIES%'
	

--12. Find all contents without Director

select * from netflix
where
	director IS NULL

--13.Find how many movies actor 'salman khan'appeared in last 10 years!

select * from netflix
where 
	casts = 'Salman Khan'

select * from netflix
where
	casts ILIKE '%salman khan%'
	AND
	Release_year > EXTRACT(YEAR FROM CURRENT_DATE)- 10

--14. Find the top 10 actor who have appeared in the highest number of movies produced in india

select 
	UNNEST(STRING_TO_ARRAY (casts ,',')) as actors,
	COUNT(*) AS total_content
from netflix
where
country ILIKE '%india%'
Group by 1
order by 2 DESC
limit 10


--15. Categorize the content based on presence of keywords 'KILL' and 'violence' in the
description field .label the content containing these keyword  as 'BAD' and all other
content as 'good'.Count how many items fall into each category



WITH new_table
AS
(
select 
*,
	CASE
	WHEN
		description ILIKE '%KILL%' OR
		description ILIKE '%violence%' THEN 'BAD CONTENT'
	    ELSE 'GOOD CONTENT'
	END category
FROM netflix
)
SELECT
	category,
	COUNT(*)as total_content
from new_table
group by 1

	 
	
	
	
	
