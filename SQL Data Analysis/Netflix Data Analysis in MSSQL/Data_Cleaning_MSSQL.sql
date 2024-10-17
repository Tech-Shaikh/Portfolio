/***************Size of the data******************/

SELECT COUNT(*) AS TOTAL_COUNT FROM [Netflix_db].[dbo].[Titles];
SELECT COUNT(*) AS TOTAL_COUNT FROM [Netflix_db].[dbo].[Credits];

/***************Checking data type****************/

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Titles'

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Credits'

/***********************Identify the null values from titles table***********************/
SELECT 
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id, 
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title, 
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS description, 
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS release_year,
    SUM(CASE WHEN age_certification IS NULL THEN 1 ELSE 0 END) AS age_certification, 
    SUM(CASE WHEN runtime = 0 THEN 1 ELSE 0 END) AS runtime,
    SUM(CASE WHEN genres = '[]' THEN 1 ELSE 0 END) AS genres, 
    SUM(CASE WHEN production_countries = '[]' THEN 1 ELSE  0 END) AS production_countries,
    SUM(CASE WHEN seasons IS NULL THEN 1 ELSE 0 END) AS seasons,
    SUM(CASE WHEN imdb_id IS NULL THEN 1 ELSE 0 END) AS imdb_id,
    SUM(CASE WHEN imdb_score IS NULL THEN 1 ELSE 0 END) AS imdb_score,
    SUM(CASE WHEN imdb_votes IS NULL THEN 1 ELSE 0 END) AS imdb_votes,
    SUM(CASE WHEN tmdb_popularity IS NULL THEN 1 ELSE 0 END) AS tmdb_popularity,
    SUM(CASE WHEN tmdb_score IS NULL THEN 1 ELSE 0 END) AS tmdb_score
FROM Titles;

/*************************type wise null count based on the season*********************/

SELECT type, COUNT(*) AS nulls FROM titles WHERE seasons IS NULL GROUP BY type; 

/*************************Removing null column which are not surving the purpose for detail 
                          reason of removing please gothrough README **********************/

DELETE FROM TITLES
WHERE title IS NULL 
       OR runtime = 0 
       OR imdb_score IS NULL
       OR imdb_votes IS NULL;

/*************************Looking for the duplicates in Titles**************************/

WITH SUB_QUERY AS (
SELECT ID,ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID DESC) AS DUBP_VALUE
FROM TITLES )
SELECT ID,DUBP_VALUE FROM SUB_QUERY
WHERE DUBP_VALUE>1;


/**************************Capitalizing some values*********************/

UPDATE Titles SET type = UPPER(left(type,1))+SUBSTRING(type,2,LEN(type));
UPDATE Titles SET title= UPPER(left(title,1))+SUBSTRING(title,2,LEN(title));
UPDATE Titles SET genres= UPPER(left(genres,1))+SUBSTRING(genres,2,LEN(genres));
UPDATE Credits SET role = UPPER(left(role,1))+SUBSTRING(role,2,LEN(role));
UPDATE Credits SET name = UPPER(left(name,1))+SUBSTRING(name,2,LEN(name));

/************************* Trimming leading and trailing spaces *********************/

UPDATE Credits SET name = TRIM(name);
UPDATE Credits SET character = TRIM(character);
UPDATE Titles SET title = TRIM(title);
UPDATE Titles SET genres = TRIM(genres);

/************************setting  'No information' in character column for null values *********************/

UPDATE Credits 
SET character = 'N/A' 
WHERE character IS NULL;

/***********************character column to 'Director' where role is Director******************************/

UPDATE Credits 
SET character = 'Director' 
WHERE role = 'Director';


/******************** Setting the null values in seasons to 0 which corresponds to Movies**********************/

UPDATE Titles 
SET seasons = 0 
WHERE seasons IS NULL;

/******************** Setting the null values in age_certification to 'Others'********************************/

UPDATE Titles 
SET age_certification = 'Others' 
WHERE age_certification IS NULL;

/******************Setting the values with [] in genres column with 'N/A'*************************************/

UPDATE Titles 
SET genres = 'N/A' 
WHERE genres = '[]';

/********************* Setting the values with [] in production_countries column with 'N/A'*******************/

UPDATE Titles 
SET production_countries = 'N/A' 
WHERE production_countries = '[]';

/********************adding two new columns 'country' and 'genre' to hold the cleaned values and removing extra column******************/


ALTER TABLE Titles ADD  country varchar(50);
ALTER TABLE Titles ADD  genre varchar(50);

UPDATE Titles 
SET country = SUBSTRING(production_countries, 2, (len(production_countries)-2)) 
WHERE id=id;

UPDATE Titles 
SET genre = SUBSTRING(genres, 2, (len(genres)-2)) 
WHERE id=id;

UPDATE Titles
SET genre = REPLACE(genre, '''', '')
WHERE genre LIKE '%''%';

UPDATE Titles
SET country = REPLACE(country, '''', '')
WHERE country LIKE '%''%';


ALTER TABLE Titles DROP COLUMN genres;
ALTER TABLE Titles DROP COLUMN production_countries;


/**************In the country column the entry for country code 'LB' was written as 'Lebanon'. Updating the data with 'LB'******************/

UPDATE Titles 
SET country = 'LB' 
WHERE country='Lebanon';

/********** Step 14 - Looking closely at some unusual titles
There are 4 shows/movies with names formatted as dates. A left join from (raw_titles to raw_credits) is used to get all the information.*********************************/

SELECT t.id, t.title, t.runtime,t.release_year, c.person_id, c.id, c.name, c.character, c.role
FROM Titles t 
LEFT JOIN credits c
ON t.id=c.id
WHERE t.id IN ('tm197423','tm461427', 'tm348993','tm1011248');


/**********  Renaming title '30 March' to 30.March******************/

UPDATE Titles 
SET title = '30.March' 
WHERE title = '30 March';

/**********  Step 15- Some more unusual titles starting with '#'******************/

SELECT Title
FROM Titles 
WHERE title like '#%' 
ORDER BY title;

UPDATE Titles 
SET title = ltrim(title) 
WHERE title like '#%' 


/****************************Retrieve the top 10 rows from the table, based on specific grouping and filtering conditions.***************/

SELECT TOP 10 id, person_id, COUNT(*) as count
FROM credits
GROUP BY id, person_id, role
HAVING COUNT(*) > 1
ORDER BY COUNT DESC 

SELECT t.title, c.name, c.character, c.role
FROM titles t
JOIN credits c ON t.id = c.id
WHERE c.id ='tm127384' AND c.person_id =11475;

SELECT t.title, c.name, c.character, c.role
FROM titles t
JOIN credits c ON t.id = c.id
WHERE c.id ='tm226362' AND c.person_id =307659;

SELECT t.title, c.name, c.character, c.role
FROM titles t
JOIN credits c ON t.id = c.id
WHERE c.id ='tm228574' AND c.person_id =65832;

/***********************Step - 17 Concatenating the character column
 creating a new credits table to hold the concatenated entries******************/

CREATE TABLE new_credits (
person_id INTEGER, 
id VARCHAR(20), 
name TEXT, 
role VARCHAR(8), 
character varchar(500));

INSERT INTO new_credits (person_id, id, name,role, character) 
SELECT person_id, id, name, role, STRING_AGG(character, ' , ') 
FROM [Netflix_db].[dbo].[Credits]
GROUP BY person_id, id, name, role;

/*********************** the query returns the cleaned data with one character row per id and person_id******************/

SELECT * 
FROM credits_new 
WHERE person_id = 307659 AND id = 'tm226362';

/***********************final count of the table************************************/

SELECT COUNT(*) FROM new_credits
SELECT COUNT(*) FROM Titles
	