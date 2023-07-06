USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 'DIRECTOR_MAPPING' AS name_of_table , COUNT(*) AS total_row_count FROM DIRECTOR_MAPPING
UNION ALL
SELECT 'GENRE', COUNT(*) FROM GENRE
UNION ALL
SELECT 'MOVIE', COUNT(*) FROM MOVIE
UNION ALL
SELECT 'NAMES', COUNT(*) FROM NAMES
UNION ALL
SELECT 'RATINGS', COUNT(*) FROM RATINGS
UNION ALL
SELECT 'ROLE_MAPPING', COUNT(*) FROM ROLE_MAPPING
Order BY total_row_count DESC;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_values_id,
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_values_title,
SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_values_year,
SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS null_values_date_published,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS null_values_duration,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_values_country,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS null_values_worlwide_gross_income,
SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS null_values_languages,
SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS null_values_production_company
FROM movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT Year,
COUNT(title) AS NUMBER_OF_MOVIES_PER_YEAR
FROM movie
GROUP BY Year;

SELECT Month(date_published) AS MONTH_NUM,
      Count(*) AS Movies_per_month
FROM movie
GROUP BY month_num
ORDER BY month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT year, COUNT(id) AS Total_movies_count
FROM movie
WHERE (country LIKE '%INDIA%' OR country LIKE '%USA%') AND year = 2019
GROUP BY year;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, COUNT(*) AS movies_count
FROM genre
GROUP BY genre
ORDER BY movies_count DESC
LIMIT 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) AS movies_with_one_genre
FROM (
  SELECT movie_id
  FROM genre
  GROUP BY movie_id
  HAVING COUNT(DISTINCT genre) = 1
) AS movies_with_one_genre;

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

SELECT DISTINCT
genre,
ROUND(AVG(duration) OVER(PARTITION BY genre), 2) AS avg_time
FROM movie 
JOIN genre 
ON movie.id = genre.movie_id
ORDER BY avg_time DESC;

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

SELECT genre,
       movie_count,
       genre_rank
FROM (
  SELECT genre,
         COUNT(movie_id) AS movie_count,
         RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
  FROM genre
  GROUP BY genre
) AS genre_summary
WHERE genre = 'THRILLER';

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

SELECT Min(avg_rating) AS MIN_AVG_RATING,
       Max(avg_rating) AS MAX_AVG_RATING,
       Min(total_votes) AS MIN_TOTAL_VOTES,
       Max(total_votes) AS MAX_TOTAL_VOTES,
       Min(median_rating) AS MIN_MEDIAN_RATING,
       Max(median_rating) AS MAX_MEDIAN_RATING
FROM ratings;

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

SELECT title,
       avg_rating,
       DENSE_Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM ratings AS r
INNER JOIN movie AS m
ON m.id = r.movie_id limit 10;

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

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

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
SELECT production_company, number_of_movies, rank_of_prod_company
FROM (
    SELECT production_company, COUNT(movie_id) AS number_of_movies,
           RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS rank_of_prod_company
    FROM ratings
    INNER JOIN movie ON movie.id = ratings.movie_id
    WHERE avg_rating > 8 AND production_company IS NOT NULL
    GROUP BY production_company
) AS summary
WHERE rank_of_prod_company = 1;

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

SELECT genre,
       Count(M.id) AS MOVIE_COUNT
FROM movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

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

SELECT title, avg_rating, genre
FROM genre AS G
INNER JOIN ratings AS R
ON G.movie_id = R.movie_id
INNER JOIN movie AS M
ON M.id = G.movie_id
WHERE title LIKE 'The%' AND avg_rating > 8
ORDER BY avg_rating DESC;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating, COUNT(movie_id) AS movie_count
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE median_rating = 8 AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT languages,
       Sum(total_votes) AS Combined_votes
FROM movie AS m
	INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE languages LIKE '%Italian%'
UNION
SELECT languages,
       Sum(total_votes) AS Combined_votes
FROM movie AS m
       INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE languages LIKE '%GERMAN%'
ORDER BY Combined_votes;

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
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

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

SELECT n.name AS director_name, COUNT(*) AS movie_tally
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN director_mapping d ON m.id = d.movie_id
JOIN names n ON d.name_id = n.id
JOIN ratings r ON m.id = r.movie_id
JOIN (
  SELECT g.genre
  FROM genre g
  JOIN ratings r ON g.movie_id = r.movie_id
  WHERE r.avg_rating > 8
  GROUP BY g.genre
  ORDER BY COUNT(*) DESC
  LIMIT 3
) top_genres ON g.genre = top_genres.genre
WHERE r.avg_rating > 8
GROUP BY n.name
ORDER BY movie_tally DESC
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

SELECT n.name AS actor_name, COUNT(DISTINCT m.id) AS movie_count
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN movie m ON rm.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE r.median_rating >= 8 AND rm.category = 'ACTOR'
GROUP BY n.name
ORDER BY movie_count DESC
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

SELECT production_company,
	   Sum(total_votes) AS vote_tally,
	   Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r ON r.movie_id = m.id
GROUP BY production_company 
limit 3;

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

WITH top_actor
     AS (SELECT n.NAME AS actor_name,
         Sum(r.total_votes) AS total_votes,
         Count(DISTINCT rm.movie_id) AS movie_count,
         Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actor_avg_rating
         FROM role_mapping rm
		 INNER JOIN names n
		 ON rm.name_id = n.id
		 INNER JOIN ratings r
		 ON rm.movie_id = r.movie_id
		 INNER JOIN movie m
		 ON rm.movie_id = m.id
         WHERE rm.category = 'actor'
		 AND m.country LIKE '%India%'
         GROUP BY rm.name_id,
                  n.NAME
         HAVING Count(DISTINCT rm.movie_id) >= 5)
SELECT *,
       Rank()
       OVER (ORDER BY actor_avg_rating DESC) AS actor_rank
FROM top_actor;

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

WITH actress_avg_rating_ranking AS 
        (SELECT n.name AS actress_name,
		SUM(r.total_votes) AS total_votes,
		COUNT(rm.movie_id) AS movie_count,
		ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actress_avg_rating,
		ROW_NUMBER() OVER (ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) DESC) AS actress_rank
        FROM names n
		INNER JOIN role_mapping rm
		ON n.id = rm.name_id
		INNER JOIN ratings r
		ON rm.movie_id = r.movie_id 
		INNER JOIN movie m
		ON rm.movie_id = m.id                 
        WHERE rm.category = 'actress'    
		AND m.country LIKE '%India%'  
		AND m.languages LIKE '%Hindi%'  
        GROUP BY n.name 
        HAVING movie_count >= 3)
SELECT *
 FROM actress_avg_rating_ranking
 WHERE actress_rank <= 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT DISTINCT m.Title,
				Avg_rating,
                CASE
                  WHEN avg_rating > 8 THEN 'Superhit movie'
                  WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
                  WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movie'
                  ELSE 'Flop movie'
                END AS Film_verdict
FROM movie AS m
INNER JOIN ratings AS r
   ON r.movie_id = m.id
INNER JOIN genre AS g
   ON g.movie_id = m.id
WHERE g.genre LIKE 'THRILLER'
GROUP BY m.title;

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

SELECT genre,
       ROUND(AVG(duration),2) AS avg_run_time,
       SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS total_run_time,
       ROUND(AVG(ROUND(AVG(duration), 2)) OVER(ORDER BY genre ROWS 10 PRECEDING), 2) AS avg_moving_duration
FROM movie AS m 
INNER JOIN genre AS g ON m.id = g.movie_id
GROUP BY genre
ORDER BY genre;

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

WITH top_genres AS (
    SELECT genre, COUNT(DISTINCT m.id) AS movie_tally
    FROM movie m
    JOIN genre g ON g.movie_id = m.id
    JOIN ratings r ON r.movie_id = m.id
    WHERE avg_rating > 8
    GROUP BY genre
    ORDER BY movie_tally DESC
    LIMIT 3
), 
movie_profile AS (
    SELECT g.genre, m.year, m.title AS movie_name, 
           CAST(REPLACE(REPLACE(IFNULL(m.worlwide_gross_income, 0), 'INR', ''), '$', '') AS DECIMAL(10)) AS worlwide_gross_income,
           DENSE_RANK() OVER(PARTITION BY m.year, g.genre ORDER BY CAST(REPLACE(REPLACE(IFNULL(m.worlwide_gross_income, 0), 'INR', ''), '$', '') AS DECIMAL(10)) DESC) AS movie_rank
    FROM movie m
    JOIN genre g ON g.movie_id = m.id
    WHERE g.genre IN (SELECT genre FROM top_genres)
)
SELECT *
FROM movie_profile
WHERE movie_rank <= 5
ORDER BY year;

-- Top 3 Genres based on most number of movies

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

WITH production_company_profile AS (
	SELECT production_company AS Production_name,
		   Count(*) AS Movie_tally
	FROM movie AS m
		 INNER JOIN ratings AS r ON r.movie_id = m.id
         WHERE median_rating >= 8 AND production_company IS NOT NULL AND languages LIKE '%,%'
         GROUP BY Production_name
         ORDER BY Movie_tally DESC)
SELECT *,
       Rank() OVER(ORDER BY Movie_tally DESC) AS Production_comp_rank
FROM production_company_profile
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

SELECT 
n.name AS actress_name,
ROUND(max(r.avg_rating),2) AS avg_rating,
SUM(total_votes) AS total_Votes ,
COUNT(m.id) AS movie_counts,
ROW_NUMBER() OVER (ORDER BY COUNT(m.id) DESC) AS actress_rank
FROM names AS n
INNER JOIN  role_mapping AS rm
ON n.id=rm.name_id
INNER JOIN movie AS m
ON rm.movie_id=m.id
INNER  JOIN ratings AS r
ON m.id=r.movie_id
INNER JOIN genre AS g
ON g.movie_id=r.movie_id
WHERE rm.category='actress' AND r.avg_rating>8 AND genre='Drama'
GROUP BY n.name
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

WITH next_date_published_summary AS
(SELECT d.name_id,
       NAME,
       d.movie_id,
       duration,
       r.avg_rating,
       total_votes,
       m.date_published,
       Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
       FROM director_mapping AS d
       INNER JOIN names AS n
	   ON n.id = d.name_id
	   INNER JOIN movie AS m
	   ON m.id = d.movie_id
	   INNER JOIN ratings AS r
	   ON r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
		Datediff(next_date_published, date_published) AS date_difference
        FROM next_date_published_summary )
SELECT name_id AS director_id,
         NAME AS director_name,
         Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;