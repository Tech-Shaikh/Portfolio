/*********************What is the total number of movies and TV shows available on Netflix?******************/

SELECT TYPE, COUNT(*) as Total_number FROM Netflix_TITLES
GROUP BY TYPE


/*************************Find most common rating for the movies and TV shows*****************************************/

WITH SUB AS (
SELECT TYPE, imdb_score,COUNT(*) NO_SHOWS,
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RNK
FROM Netflix_TITLES
GROUP BY TYPE,imdb_score
)
SELECT TYPE,NO_SHOWS,imdb_score
FROM SUB WHERE RNK=1


/*********************How has the distribution of content (movies and TV shows) changed over time?************************/

select release_year as year,
	SUM(CASE WHEN TYPE='Movie' then 1 else 0 end) AS Movie_count,
	SUM(CASE WHEN TYPE='Show' THEN 1 ELSE 0 END) AS Show_count
from Netflix_TITLES
group by release_year

/*********************Which were the top years in terms of the number of titles released?*********************************/

select top 1 release_year,count(id) as num_title
from Netflix_TITLES
group by release_year
order by num_title desc

/********************How many movies and TV shows were released in each decade?*********************************/

WITH decade AS (
SELECT title, FLOOR((release_year - 1950) / 10) AS decade
FROM Netflix_TITLES
WHERE release_year BETWEEN 1953 AND 2022 
GROUP BY title, FLOOR((release_year - 1950) / 10)
)
SELECT decade,
CASE WHEN decade = 0 THEN '1950-1960'
	 WHEN decade = 1 THEN '1961-1970'
	 WHEN decade = 2 THEN '1971-1980'
	 WHEN decade = 3 THEN '1981-1990'
	 WHEN decade = 4 THEN '1991-2000'
	 WHEN decade = 5 THEN '2001-2010'
	 WHEN decade = 6 THEN '2011-2020'
	 WHEN decade = 7 THEN '2021-2030'
END range_of_years,
COUNT(title) AS num_content
FROM decade
GROUP BY decade
ORDER BY decade ASC;

/***************************** What are the most common genres of movies and TV shows on Netflix?********************/
/***********for moview************************/
SELECT TOP 1 value,count(distinct id) as count FROM Netflix_TITLES CROSS APPLY STRING_SPLIT(genre, ',')
WHERE TYPE='Movie'
GROUP BY value
ORDER BY COUNT DESC

/************for TV Show***********************/

SELECT TOP 1 value,count(distinct id) as count FROM Netflix_TITLES CROSS APPLY STRING_SPLIT(genre, ',')
WHERE TYPE='Show'
GROUP BY value
ORDER BY COUNT DESC

/*****************************Which country produces the most movies and TV shows on Netflix?***********************/


WITH SUB AS (
SELECT  value,TYPE,count(distinct id) as content,
DENSE_RANK() OVER(PARTITION BY TYPE ORDER BY count(distinct id) DESC) AS RNK
FROM Netflix_TITLES CROSS APPLY STRING_SPLIT(country, ',')
--WHERE TYPE='Movie'
GROUP BY TYPE,value)
SELECT TYPE,VALUE,CONTENT FROM SUB
WHERE RNK<=5


/***************** Which shows/movies are of longest and shortest runtime*********************/

----LONGEST
SELECT TITLE,RUNTIME FROM Netflix_TITLES
WHERE RUNTIME=(SELECT MAX(runtime) FROM Netflix_TITLES)

---SHORTEST
SELECT TITLE,RUNTIME FROM Netflix_TITLES
WHERE RUNTIME=(SELECT MIN(runtime) FROM Netflix_TITLES)

/***********************Calculate the distribution of seasons for shows.**********************/

SELECT SEASONS,COUNT(*)  AS NUM_SHOWS FROM Netflix_TITLES
WHERE TYPE='Show'
group by SEASONS
ORDER BY NUM_SHOWS  DESC

/********************What are the 10 top-rated movies and shows on Netflix?*************************/

SELECT TOP 10 TITLE ,imdb_score FROM Netflix_TITLES 
WHERE TYPE='Show'
ORDER BY imdb_score DESC;


SELECT TOP 10 TITLE ,imdb_score FROM Netflix_TITLES 
WHERE TYPE='Movie'
ORDER BY imdb_score DESC;

/****************** What are the most popular certifications on Netflix?****************/

select age_certification,COUNT(id) as count from Netflix_TITLES
group by age_certification
order by count desc

/********************Which actor has most films/series on Netflix?************************/

SELECT * FROM Netflix_TITLES

SELECT TOP 1 COUNT(TITLE.ID) AS NUM_SHOW,NAME FROM New_Credits CREDIT
JOIN Netflix_TITLES TITLE
ON TITLE.ID=CREDIT.ID
GROUP BY NAME
ORDER BY NUM_SHOW DESC

/************************List Top 10 Directors with number of shows/movies directed.*******************/

SELECT TOP 1 NAME,COUNT(TITLE.ID) AS NUM_SHOWS FROM New_Credits CREDIT
JOIN
Netflix_TITLES TITLE
ON TITLE.ID=CREDIT.ID
WHERE ROLE='Director'
GROUP BY NAME
ORDER BY NUM_SHOWS DESC

/***********************Categorize the contents in 3 parts (Short, Medium and Long) in terms of duration and give their respective percentage frequency.****/

WITH total_count AS
(
SELECT 
    COUNT(*) AS total_content
FROM 
    Netflix_TITLES
)
,
duration AS
(SELECT title,
       runtime,
       CASE WHEN runtime> 0 AND runtime <= 60 THEN 'Short'
       WHEN runtime > 60 AND runtime <= 120 THEN 'Medium'
       WHEN runtime> 120 THEN 'Long'
       END duration
FROM 
    Netflix_TITLES
)
SELECT 
    d.duration, 
    COUNT(d.title)  AS frequency,
    CONCAT(ROUND(COUNT(d.title) / (SELECT total_content FROM total_count), 2)*100, ' %') AS relative_frequency
FROM 
    Netflix_TITLES s
JOIN 
    duration d ON d.title = s.title
GROUP BY 
    d.duration;

/*************************Categorize the contents in 10 ratings based on the imdb_score and give the percentage frequency for each of them**********************/

WITH rating AS
(
SELECT title, imdb_score, 
CASE 
	WHEN imdb_score >= 1.0 AND  imdb_score <2.0 THEN 'Do Not Want'
	WHEN imdb_score >= 2.0 AND  imdb_score <3.0 THEN 'Awful'
	WHEN imdb_score >= 3.0 AND  imdb_score < 4.0 THEN 'Bad'
	WHEN imdb_score >= 4.0 AND  imdb_score <5.0 THEN 'Nice Try, But No Cigar'
	WHEN imdb_score >= 5.0 AND  imdb_score < 6.0 THEN 'Meh'
	WHEN imdb_score >= 6.0 AND  imdb_score < 7.0 THEN 'Not Bad'
	WHEN imdb_score >= 7.0 AND  imdb_score < 8.0 THEN 'Good'
	WHEN imdb_score >= 8.0 AND  imdb_score < 9.0 THEN 'Very Good'
	WHEN imdb_score >= 9.0 AND  imdb_score <= 10.0 THEN 'Excellent'
	WHEN imdb_score = 10.0 THEN 'Masterpiece'
END rating
FROM Netflix_TITLES;


/*************************Calculate the number of shows with runtime greater than the average duration******************************/

SELECT COUNT(*) AS num_content
FROM Netflix_TITLES 
WHERE runtime > (SELECT ROUND(AVG(runtime),2) FROM Netflix_TITLES)

/*************************Find most common rating for the movies and TV shows*****************************************/

WITH SUB AS (
SELECT TYPE, imdb_score,COUNT(*) NO_SHOWS,
RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RNK
FROM Netflix_TITLES
GROUP BY TYPE,imdb_score
)
SELECT TYPE,NO_SHOWS,imdb_score
FROM SUB WHERE RNK=1

/***********************Find content added in last five year****************************************************/

SELECT TITLE,RELEASE_YEAR FROM Netflix_TITLES
WHERE RELEASE_YEAR >=YEAR(GETDATE())-5 
ORDER BY RELEASE_YEAR DESC

/************************list all the TV shows with more than 5 seasons*****************************************/

SELECT title ,count(seasons) as cnt_seasons FROM Netflix_TITLES
group by title
having count(seasons)=2

/********************find each year and average number of content release by India on Netflix**************************/



SELECT RELEASE_YEAR AS YEAR  ,COUNT(*) AS CONTENT,
COUNT(*)/(SELECT COUNT(*) FROM Netflix_TITLES CROSS APPLY STRING_SPLIT(COUNTRY, ',') WHERE VALUE='IN')*100 AS AVG_CONTENT
FROM Netflix_TITLES 
group by RELEASE_YEAR
ORDER BY AVG_CONTENT ,YEAR DESC

/******************lIST ALL THE MOVIES THAT ARE DOCUMENTRIES**************************************/

SELECT TITLE,VALUE FROM Netflix_TITLES CROSS APPLY STRING_SPLIT(GENRE,',')
WHERE VALUE LIKE'%Documentation%'

/******************find all the content without director****************************************/

SELECT COUNT(*) AS CONTENT FROM 
Netflix_TITLES TITLES
JOIN 
New_Credits CREDITS
ON TITLES.ID=CREDITS.ID
WHERE ROLE != 'Director'

/*****************Find how many movies actor salman khan appear in last 10 years********************/

SELECT COUNT(*) AS CONTENT FROM 
Netflix_TITLES TITLES
JOIN New_Credits CREDITS
ON TITLES.ID=CREDITS.ID
WHERE NAME LIKE '%Salman Khan%'
AND RELEASE_YEAR>=YEAR(GETDATE())-10

/***************Find top 10 actor  who have appeared  in highest numbers of movies produce in India***************/

SELECT TOP 10 CREDITS.NAME, COUNT(TITLE.ID) AS COUNT
FROM Netflix_TITLES TITLE
JOIN New_Credits CREDITS
  ON TITLE.ID = CREDITS.ID
CROSS APPLY STRING_SPLIT(TITLE.COUNTRY, ',') AS country_split
WHERE country_split.VALUE = 'IN'
GROUP BY CREDITS.NAME
ORDER BY COUNT DESC;