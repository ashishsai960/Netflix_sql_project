
select * from netflix;

select count(*) as total_count from netflix;

select distinct type  from netflix;

--Problems
--Q1 Count the number of Movies vs TV Shows
Select
   type,
   count(*) as total_content
from netflix
Group by type;

--Q2 Find the most common rating for Movies and TV Shows
SELECT 
type,
rating
from
(
select
type,
rating,
count(*),
RANK()over(partition by type order by count(*) DESC) as ranking
from netflix
group by 1,2
)as t1
where 
ranking=1;

--LIST ALL MOVIES RELEASED IN A SPEFCIFIC YEAR
SELECT * FROM netflix
where 
   type='Movie'
   And
   release_year=2020;


--Find the top 5 countries with the most content on netflix
SELECT
    UNNEST(STRING_TO_ARRAY(country,','))as mew_country,
	count(show_id) as total_content
from netflix
GROUP by 1
ORDER BY 2 DESC
LIMIT 5;


--Identify the longest movie?
SELECT * FROM netflix
where
   type='Movie'
   and
   duration=(select max(duration)from netflix);


-- find content added in the last 5 year?
Select
  *
from netflix
where
    TO_DATE(date_added,'Month DD,YYYY')>=CURRENT_DATE-INTERVAL '4 years';



-- Q7 Find all the movies/T shows by director "Rajiv Chilaka"
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';


-- LIST ALL TV SHOWS WITH MORE THAN EQUAL TO 5 SEASONS
SELECT 
    *
from netflix
where
    type='TV Show'
	AND
	SPLIT_PART(duration,' ',1)::numeric>=5;


-- COUNT THE NUMBER OF CONTENT ITEMS IN EACH GENRE AND SHOW THE RESUTL IN DESC ORDER

SELECT 
     UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	 COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1 
ORDER BY 2 DESC;


--10Q FIND EACH YEAR AND THE AVERAGE NUMBER OF CONTENT RELEASE BY INDIA ON NETFLIX.RETURN TOP 5 YEAR WITH HIGHEST AVG CONTENT RELEASE!
SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(Count(*)::numeric/(SELECT COUNT(*) FROM netflix where country='India')::numeric*100,2) as avg_content_per_year
FROM netflix
WHERE country='India'
GROUP BY 1;

-- 11Q LIST ALL MOVIES THAT ARE DOCUMENTARIES
SELECT * From netflix
WHERE listed_in like '%Documentaries%';

--12 Q Find all content without a director
SELECT
    *
FROM netflix
WHERE director IS NULL;


--13Q FIND HOW MANY MOVIES ACTOR 'SALMAN KHAN' APPEARED IN LAST 10 YEAR!
SELECT * FROM netflix
WHERE casts Ilike '%salman khan%'
    And 
	release_year> EXTRACT(YEAR FROM CURRENT_DATE)-10;



--14Q FIND THE TOP10 ACTORS WHO HAVE APPEARED IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA.
SELECT
   UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
   count(*) as total_content
from netflix
WHERE country ILIKE '%INDIA'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;