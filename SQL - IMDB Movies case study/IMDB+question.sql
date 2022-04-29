USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
SELECT table_name, table_rows
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_SCHEMA = 'imdb';


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT SUM(CASE WHEN TITLE IS NULL THEN 1 ELSE 0 END) AS NULL_TITLE, 
	SUM(CASE WHEN YEAR IS NULL THEN 1 ELSE 0 END) AS NULL_YEAR,
	SUM(CASE WHEN DATE_PUBLISHED IS NULL THEN 1 ELSE 0 END) AS NULL_DATE_PUBLISH, 
	SUM(CASE WHEN DURATION IS NULL THEN 1 ELSE 0 END) AS NULL_DURATION,
	SUM(CASE WHEN COUNTRY IS NULL THEN 1 ELSE 0 END) AS NULL_COUNTRY,
	SUM(CASE WHEN WORLWIDE_GROSS_INCOME IS NULL THEN 1 ELSE 0 END) AS NULL_WORLWIDE_GROSS_INCOME,
	SUM(CASE WHEN LANGUAGES IS NULL THEN 1 ELSE 0 END) AS NULL_LANGUAGES,
	SUM(CASE WHEN PRODUCTION_COMPANY IS NULL THEN 1 ELSE 0 END) AS NULL_PRODUCTION_COMPANY 
FROM MOVIE;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+--------year-------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- number of movies released each year
SELECT YEAR, COUNT(id) as NUMBER_OF_MOVIES
	FROM MOVIE
	GROUP BY YEAR
	ORDER BY YEAR;

-- Monthwise trend for the movie releases.
SELECT MONTH(DATE_PUBLISHED) AS MONTH_NUM, COUNT(ID) AS NUMBER_OF_MOVIES
	FROM MOVIE
	GROUP BY MONTH_NUM
	ORDER BY MONTH_NUM;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) AS NUM_MOVIES 
	FROM MOVIE
	WHERE YEAR = '2019' AND (COUNTRY LIKE '%USA%' OR COUNTRY LIKE '%INDIA%');

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT(GENRE) from GENRE;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT GENRE,YEAR, COUNT(movie_id)as NUM_MOVIES
FROM GENRE AS G
INNER JOIN MOVIE AS M
ON g.movie_id=m.id
WHERE YEAR = 2019
GROUP BY GENRE
ORDER BY NUM_MOVIES DESC
LIMIT 1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH TEMP_GENRE AS
( 
SELECT movie_id,
			COUNT(GENRE) AS MOVIE_COUNT
FROM GENRE
GROUP BY movie_id
HAVING MOVIE_COUNT= 1
)
SELECT COUNT(movie_id) AS MOVIE_COUNT
FROM  TEMP_GENRE;  

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT GENRE, ROUND(AVG(duration),2) AS AVG_DURATION
FROM GENRE AS g
INNER JOIN MOVIE AS m
ON g.movie_id = m.id
GROUP BY GENRE
ORDER BY AVG_DURATION DESC;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH GENRE_RANK AS
(
	SELECT GENRE, COUNT(movie_id) AS MOVIE_COUNT,
			RANK() OVER(ORDER BY COUNT(movie_id)DESC ) AS GENRE_RANK
	FROM GENRE
	GROUP BY GENRE
)

SELECT *
FROM GENRE_RANK
WHERE GENRE='thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating) AS min_avg_rating, 
		MAX(avg_rating) AS max_avg_rating,
		MIN(total_votes) AS min_total_votes, 
        MAX(total_votes) AS max_total_votes,
		MIN(median_rating) AS min_median_rating, 
        MAX(median_rating) AS max_median_rating
        
FROM RATINGS;

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT TITLE, AVG_RATING,
		DENSE_RANK() OVER(ORDER BY AVG_RATING DESC) AS MOVIE_RANK
FROM MOVIE AS m
INNER JOIN RATINGS AS r
ON r.movie_id = m.id
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT MEDIAN_RATING, COUNT(AVG_RATING) AS MOVIE_COUNT
FROM RATINGS
GROUP BY MEDIAN_RATING
ORDER BY MEDIAN_RATING;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT PRODUCTION_COMPANY, COUNT(id) AS MOVIE_COUNT,
		DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS PROD_COMPANY_RANK
        
FROM MOVIE AS m
INNER JOIN RATINGS AS r
ON m.id = r.MOVIE_id
WHERE AVG_RATING > 8 AND PRODUCTION_COMPANY IS NOT NULL
GROUP BY PRODUCTION_COMPANY
ORDER BY MOVIE_COUNT DESC;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.GENRE, COUNT(g.MOVIE_ID) AS MOVIE_COUNT
FROM GENRE AS g
INNER JOIN ratings AS r
ON g.MOVIE_ID = r.MOVIE_ID
INNER JOIN movie AS m
ON m.id = g.MOVIE_ID
WHERE m.country='USA' AND r.total_votes>1000 AND MONTH(date_published)=3 AND year=2017
GROUP BY g.GENRE	
ORDER BY MOVIE_COUNT DESC;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT TITLE, AVG_RATING, GENRE
FROM GENRE AS g
INNER JOIN RATINGS AS r
ON g.MOVIE_ID = r.MOVIE_ID
INNER JOIN MOVIE AS m
ON m.id = g.MOVIE_ID
WHERE TITLE LIKE 'The%' AND avg_rating > 8;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT MEDIAN_RATING, COUNT(MOVIE_ID) AS MOVIE_COUNT
FROM MOVIE AS m
INNER JOIN RATINGS AS r
ON m.ID = r.MOVIE_ID
WHERE MEDIAN_RATING = 8 AND DATE_PUBLISHED BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY MEDIAN_RATING;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT  TOTAL_VOTES, LANGUAGES
FROM MOVIE as m
INNER JOIN RATINGS as r
ON m.ID = r.MOVIE_ID
WHERE LANGUAGES  LIKE 'GERMAN' OR LANGUAGES LIKE 'ITALIAN'
GROUP BY LANGUAGES
ORDER BY TOTAL_VOTES DESC;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) AS NULL_NAME,
	SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) AS NULL_HEIGHT, 
	SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END) AS NULL_DOB,
	SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) AS NULL_KNOWN_FOR_MOVIES
FROM NAMES;




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH TOP_GENRE AS
(
	SELECT g.GENRE, COUNT(g.MOVIE_ID) AS MOVIE_COUNT
		FROM GENRE AS g
		INNER JOIN RATINGS AS r
		ON g.MOVIE_ID = r.MOVIE_ID
		WHERE AVG_RATING > 8
	GROUP BY GENRE
    ORDER BY MOVIE_COUNT
),

TOP_DIRECTOR AS
( 
	SELECT n.NAME AS DIRECTOR_NAME,
				COUNT(g.MOVIE_ID) AS MOVIE_COUNT,
			ROW_NUMBER() OVER (ORDER BY COUNT(g.MOVIE_ID) DESC) AS DIRECTOR_ROW_RANK
		FROM NAMES AS n
		INNER JOIN DIRECTOR_MAPPING AS dm
		ON n.ID = dm.NAME_ID
		INNER JOIN GENRE AS g
		ON dm.MOVIE_ID = g.MOVIE_ID
		INNER JOIN RATINGS AS r
		ON r.MOVIE_ID = g.MOVIE_ID,
	TOP_GENRE
	WHERE g.GENRE IN (TOP_GENRE.GENRE) AND AVG_RATING > 8
	GROUP BY DIRECTOR_NAME
	ORDER BY MOVIE_COUNT DESC
)

SELECT * 
FROM TOP_DIRECTOR
WHERE DIRECTOR_ROW_RANK<=3
LIMIT 3;
    

    


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT NAME AS ACTOR_NAME, 
		COUNT(r.MOVIE_ID) AS MOVIE_COUNT
	FROM RATINGS AS r
	INNER JOIN ROLE_MAPPING AS rm
	ON rm.MOVIE_ID = r.MOVIE_ID
	INNER JOIN NAMES AS n
	ON rm.NAME_ID = n.ID
WHERE MEDIAN_RATING >= 8 AND CATEGORY = 'ACTOR'
GROUP BY NAME
ORDER BY MOVIE_COUNT DESC
LIMIT 2;





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT PRODUCTION_COMPANY, 
	SUM(TOTAL_VOTES) AS VOTE_COUNT,
    DENSE_RANK() OVER (ORDER BY SUM(TOTAL_VOTES) DESC) AS PROD_COMP_RANK
    
FROM MOVIE AS m
INNER JOIN RATINGS AS r
ON m.ID = r.MOVIE_ID
GROUP BY PRODUCTION_COMPANY
LIMIT 3;



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT NAME AS ACTOR_NAME, TOTAL_VOTES,	
			COUNT(m.ID) AS MOVIE_COUNT,
            ROUND(SUM(AVG_RATING*TOTAL_VOTES)/SUM(TOTAL_VOTES),2) AS ACTOR_AVG_RATING,
            RANK() OVER(ORDER BY AVG_RATING DESC) AS ACTOR_RANK
	
    FROM MOVIE AS m
    INNER JOIN RATINGS AS r
    ON m.ID = r.MOVIE_ID
    INNER JOIN ROLE_MAPPING AS rm
    ON m.ID = rm.MOVIE_ID
    INNER JOIN NAMES AS n
    ON rm.NAME_ID = n.ID
    
WHERE CATEGORY = 'ACTOR' AND COUNTRY = 'INDIA'
GROUP BY NAME
HAVING COUNT(m.ID) >= 5
LIMIT 1;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT NAME AS ACTRESS_NAME, TOTAL_VOTES,
			COUNT(m.ID) AS MOVIE_COUNT,
            ROUND(SUM(AVG_RATING*TOTAL_VOTES)/SUM(TOTAL_VOTES),2) AS ACTRESS_AVG_RATING,
            RANK() OVER(ORDER BY AVG_RATING DESC) AS ACTRESS_RANK
		
	FROM MOVIE AS m
    INNER JOIN RATINGS AS r
    ON m.ID = r.MOVIE_ID
    INNER JOIN ROLE_MAPPING AS rm
    ON m.ID = rm.MOVIE_ID
    INNER JOIN NAMES AS n
    ON rm.NAME_ID = n.ID
    
WHERE CATEGORY = 'ACTRESS' AND COUNTRY = 'INDIA' AND LANGUAGES = 'HINDI'
GROUP BY NAME
HAVING COUNT(m.ID) >= 3
LIMIT 1;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT TITLE,
		CASE WHEN AVG_RATING > 8 THEN 'SUPERHIT MOVIES'
			 WHEN AVG_RATING BETWEEN 7 AND 8 THEN 'HIT MOVIES'
             WHEN AVG_RATING BETWEEN 5 AND 7 THEN 'ONE-TIME-WATCH MOVIES'
             WHEN AVG_RATING < 5 THEN 'FLOP MOVIES'
		END AS AVG_RATING_CATEGORY
	
	FROM MOVIE AS m
	INNER JOIN GENRE AS g
	ON m.ID = g.MOVIE_ID
	INNER JOIN RATINGS AS r
	ON m.ID=r.MOVIE_ID

WHERE GENRE = 'THRILLER';



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT GENRE,
		ROUND(AVG(DURATION),2) AS AVG_DURATION,
        SUM(ROUND(AVG(DURATION),2)) OVER(ORDER BY GENRE ROWS UNBOUNDED PRECEDING) AS RUNNING_TOTAL_DURATION,
        AVG(ROUND(AVG(DURATION),2)) OVER(ORDER BY GENRE ROWS 10 PRECEDING) AS MOVING_AVG_DURATION

FROM MOVIE AS m
INNER JOIN GENRE AS g
ON m.ID = g.MOVIE_ID
GROUP BY GENRE
ORDER BY GENRE;

	
    

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH GENRE_TOP_3 AS
( 	
	SELECT GENRE, COUNT(MOVIE_ID) AS NUM_OF_MOVIES
    FROM GENRE AS g
    INNER JOIN MOVIE AS m
    ON g.MOVIE_ID = m.id
    GROUP BY GENRE
    ORDER BY COUNT(MOVIE_ID) DESC
    LIMIT 3
),

TOP_5 AS
(
	SELECT GENRE,
			year,
			TITLE AS MOVIE_NAME,
			WORLWIDE_GROSS_INCOME,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY WORLWIDE_GROSS_INCOME DESC) AS MOVIE_RANK
        
	FROM MOVIE AS m 
    INNER JOIN GENRE AS g 
    ON m.ID= g.MOVIE_ID
	WHERE GENRE IN (SELECT GENRE FROM GENRE_TOP_3)
)

SELECT *
FROM TOP_5
WHERE MOVIE_RANK<=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT PRODUCTION_COMPANY,
		COUNT(m.ID) AS MOVIE_COUNT,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS PROD_COMP_RANK
FROM MOVIE AS m 
INNER JOIN RATINGS AS r 
ON m.ID=r.MOVIE_ID
WHERE MEDIAN_RATING>=8 AND PRODUCTION_COMPANY IS NOT NULL AND POSITION(',' IN LANGUAGES)>0
GROUP BY PRODUCTION_COMPANY
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT NAME, SUM(TOTAL_VOTES) AS TOTAL_VOTES,
		COUNT(rm.MOVIE_ID) AS MOVIE_COUNT,
		AVG_RATING,
        DENSE_RANK() OVER(ORDER BY AVG_RATING DESC) AS ACTRESS_RANK
FROM NAMES AS n
INNER JOIN ROLE_MAPPING AS rm
ON n.ID = rm.NAME_ID
INNER JOIN RATINGS AS r
ON r.MOVIE_ID = rm.MOVIE_ID
INNER JOIN GENRE AS g
ON r.MOVIE_ID = g.MOVIE_ID
WHERE CATEGORY = 'actress' AND AVG_RATING > 8 AND GENRE = 'drama'
GROUP BY NAME
LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH DATE_INFO AS
(
SELECT d.NAME_ID, name, d.MOVIE_ID,
	   m.DATE_PUBLISHED, 
       LEAD(DATE_PUBLISHED, 1) OVER(PARTITION BY d.NAME_ID ORDER BY DATE_PUBLISHED, d.MOVIE_ID) AS MOVIE_NEXT_DATE
       FROM DIRECTOR_MAPPING d
	 JOIN names AS n 
     ON d.NAME_ID=n.ID 
	 JOIN MOVIE AS m 
     ON d.MOVIE_ID=m.ID
),

DATE_DIFF AS
(
	 SELECT *, DATEDIFF(MOVIE_NEXT_DATE, DATE_PUBLISHED) AS DIFF
	 FROM DATE_INFO
 ),
 
 AVG_INTER_DAYS AS
 (
	 SELECT NAME_ID, AVG(diff) AS AVG_INTER_MOVIE_DAYS
	 FROM DATE_DIFF
	 GROUP BY NAME_ID
 ),
 
 END_RESULT AS
 (
	 SELECT d.NAME_ID AS DIRECTOR_ID,
		 name AS DIRECTOR_NAME,
		 COUNT(d.movie_id) AS NUMBER_OF_MOVIES,
		 ROUND(AVG_INTER_MOVIE_DAYS) AS INTER_MOVIE_DAYS,
		 ROUND(AVG(AVG_RATING),2) AS AVG_RATING,
		 SUM(TOTAL_VOTES) AS TOTAL_VOTES,
		 MIN(AVG_RATING) AS MIN_RATING,
		 MAX(AVG_RATING) AS MAX_RATING,
		 SUM(DURATION) AS TOTAL_DURATION,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.MOVIE_ID) DESC) AS DIRECTOR_ROW_RANK
	 FROM
		 names AS n 
         JOIN DIRECTOR_MAPPING AS d 
         ON n.ID=d.NAME_ID
		 JOIN RATINGS AS r 
         ON d.MOVIE_ID=r.MOVIE_ID
		 JOIN MOVIE AS m 
         ON m.ID=r.MOVIE_ID
		 JOIN AVG_INTER_DAYS AS a 
         ON a.NAME_ID=d.NAME_ID
	 GROUP BY DIRECTOR_ID
 )
 SELECT *	
 FROM END_RESULT
 LIMIT 9;







