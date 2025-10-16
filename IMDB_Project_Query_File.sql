USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 'director_mapping' AS table_name, COUNT(*) AS total_rows FROM director_mapping
UNION ALL
-- Total rows in genre
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
-- Total rows in movie
SELECT 'movie', COUNT(*) FROM movie
UNION ALL
-- Total rows in names
SELECT 'names', COUNT(*) FROM names
UNION ALL
-- Total rows in role_mapping
SELECT 'role_mapping', COUNT(*) FROM role_mapping
UNION ALL
-- Total rows in ratings
SELECT 'ratings', COUNT(*) FROM ratings; 


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 'id' AS column_name FROM movie WHERE id IS NULL
UNION
SELECT 'title' FROM movie WHERE title IS NULL
UNION
SELECT 'year' FROM movie WHERE year IS NULL
UNION
SELECT 'date_published' FROM movie WHERE date_published IS NULL
UNION
SELECT 'duration' FROM movie WHERE duration IS NULL
UNION
SELECT 'country' FROM movie WHERE country IS NULL
UNION
SELECT 'worlwide_gross_income' FROM movie WHERE worlwide_gross_income IS NULL
UNION
SELECT 'languages' FROM movie WHERE languages IS NULL
UNION
SELECT 'production_company' FROM movie WHERE production_company IS NULL;


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

--- First part
SELECT year, COUNT(*) AS number_of_movies FROM movie GROUP BY year;

--- second part
SELECT MONTH(date_published) AS month_num, COUNT(*) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published);


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

/* interpretation 1 : Show counts separately for USA and India */

SELECT
    SUM(CASE WHEN country LIKE '%USA%' THEN 1 ELSE 0 END) AS USA,
    SUM(CASE WHEN country LIKE '%India%' THEN 1 ELSE 0 END) AS India
FROM 
    movie
WHERE 
    year = 2019
    AND (country LIKE '%USA%' OR country LIKE '%India%');
    
/*  Interpretation 2: Show the total number of 2019 movies that were produced in USA or India (combined count) */

SELECT 
    COUNT(*) AS total_movies_in_USA_or_India
FROM 
    movie
WHERE 
    year = 2019
    AND (country LIKE '%USA%' OR country LIKE '%India%');



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre from genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, COUNT(*) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) AS single_genre_movie_count
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(*) = 1
) AS single_genre_movies;



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

SELECT g.genre, ROUND(AVG(m.duration), 2) AS avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre;



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

SELECT genre, COUNT(*) AS movie_count,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
FROM genre
GROUP BY genre;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
  MIN(avg_rating) AS min_avg_rating,
  MAX(avg_rating) AS max_avg_rating,
  MIN(total_votes) AS min_total_votes,
  MAX(total_votes) AS max_total_votes,
  MIN(median_rating) AS min_median_rating,
  MAX(median_rating) AS max_median_rating
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
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

SELECT m.title, r.avg_rating,
       RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM movie m
JOIN ratings r ON m.id = r.movie_id
ORDER BY r.avg_rating DESC
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

SELECT median_rating, COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;


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

SELECT 
    production_company,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_company_rank
FROM 
    movie
INNER JOIN 
    ratings ON movie.id = ratings.movie_id
WHERE 
    avg_rating > 8
    AND production_company IS NOT NULL
GROUP BY 
    production_company
ORDER BY 
    prod_company_rank;


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

SELECT 
    genre.genre,
    COUNT(*) AS movie_count
FROM 
    movie
INNER JOIN 
    ratings ON ratings.movie_id = movie.id
INNER JOIN 
    genre ON genre.movie_id = movie.id
WHERE 
    MONTH(date_published) = 3
    AND YEAR(date_published) = 2017
    AND country LIKE '%USA%'
    AND total_votes > 1000
GROUP BY 
    genre.genre
ORDER BY 
    movie_count DESC;



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

SELECT 
    movie.title, 
    ratings.avg_rating, 
    genre.genre AS genre
FROM 
    movie
INNER JOIN 
    genre ON genre.movie_id = movie.id
INNER JOIN 
    ratings ON ratings.movie_id = movie.id
WHERE 
    movie.title LIKE 'The%'
    AND ratings.avg_rating > 8
ORDER BY 
    ratings.avg_rating DESC;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(*) AS movie_count
FROM 
    movie
INNER JOIN 
    ratings ON ratings.movie_id = movie.id
WHERE 
    date_published BETWEEN '2018-04-01' AND '2019-04-01'
    AND median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    german_votes,
    italian_votes,
    CASE 
        WHEN german_votes > italian_votes THEN 'Yes'
        ELSE 'No'
    END AS german_has_more_votes
FROM (
    SELECT
        SUM(CASE WHEN languages LIKE '%German%' THEN total_votes ELSE 0 END) AS german_votes,
        SUM(CASE WHEN languages LIKE '%Italian%' THEN total_votes ELSE 0 END) AS italian_votes
    FROM movie
    JOIN ratings ON ratings.movie_id = movie.id
    WHERE languages LIKE '%German%' OR languages LIKE '%Italian%'
) AS vote_summary;


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

Select 
sum(name is null) as name_nulls,
sum(height is null) as height_nulls,
sum(date_of_birth is null) as date_of_birth_nulls,
sum(known_for_movies is null) as knowm_for_movies_nulls
from names; 



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

WITH top_genres AS (
    SELECT 
        genre.genre
    FROM 
        genre
    INNER JOIN 
        ratings ON ratings.movie_id = genre.movie_id
    WHERE 
        avg_rating > 8
    GROUP BY 
        genre.genre
    ORDER BY 
        COUNT(*) DESC
    LIMIT 3
),
top_directors AS (
    SELECT 
        names.name AS director_name,
        COUNT(*) AS movie_count
    FROM 
        movie
    INNER JOIN 
        ratings ON ratings.movie_id = movie.id
    INNER JOIN 
        genre ON genre.movie_id = movie.id
    INNER JOIN 
        director_mapping ON director_mapping.movie_id = movie.id
    INNER JOIN 
        names ON names.id = director_mapping.name_id
    WHERE 
        avg_rating > 8
        AND genre.genre IN (SELECT genre FROM top_genres)
    GROUP BY 
        names.name
    ORDER BY 
        movie_count DESC
    LIMIT 3
)
SELECT 
    director_name, 
    movie_count
FROM  top_directors;


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

SELECT n.name AS actor_name, COUNT(*) AS movie_count
FROM role_mapping r
JOIN names n ON r.name_id = n.id
JOIN ratings ra ON r.movie_id = ra.movie_id
WHERE ra.median_rating >= 8 AND r.category = 'actor'
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

SELECT 
    production_company,
    SUM(total_votes) AS vote_count,
    RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 
    movie
INNER JOIN 
    ratings ON ratings.movie_id = movie.id
WHERE 
    production_company IS NOT NULL
GROUP BY 
    production_company
ORDER BY 
    prod_comp_rank
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

WITH actor_stats AS (
    SELECT 
        names.name AS actor_name,
        COUNT(*) AS movie_count,
        SUM(total_votes) AS total_votes,
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating
    FROM 
        movie
    INNER JOIN 
        ratings ON ratings.movie_id = movie.id
    INNER JOIN 
        role_mapping ON role_mapping.movie_id = movie.id
    INNER JOIN 
        names ON names.id = role_mapping.name_id
    WHERE 
        role_mapping.category = 'actor'
        AND movie.country LIKE '%India%'
    GROUP BY 
        names.name
    HAVING 
        COUNT(*) >= 5
),
ranked_actors AS (
    SELECT *,
        RANK() OVER (
            ORDER BY actor_avg_rating DESC, total_votes DESC
        ) AS actor_rank
    FROM actor_stats
)
SELECT 
    actor_name,
    total_votes,
    movie_count,
    actor_avg_rating,
    actor_rank
FROM 
    ranked_actors
ORDER BY 
    actor_rank
LIMIT 10;

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

WITH actress_stats AS (
    SELECT 
        names.name AS actress_name,
        COUNT(*) AS movie_count,
        SUM(total_votes) AS total_votes,
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating
    FROM 
        movie
    INNER JOIN 
        ratings ON ratings.movie_id = movie.id
    INNER JOIN 
        role_mapping ON role_mapping.movie_id = movie.id
    INNER JOIN 
        names ON names.id = role_mapping.name_id
    WHERE 
        role_mapping.category = 'actress'
        AND movie.languages LIKE '%Hindi%'
        AND movie.country LIKE '%India%'
    GROUP BY 
        names.name
    HAVING 
        COUNT(*) >= 3
),
ranked_actress AS (
    SELECT *,
        RANK() OVER (
            ORDER BY actress_avg_rating DESC, total_votes DESC
        ) AS actress_rank
    FROM actress_stats
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM 
    ranked_actress
ORDER BY 
    actress_rank
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT 
    movie.title AS movie_name,
    CASE 
        WHEN avg_rating > 8 THEN 'Superhit'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM 
    movie
INNER JOIN 
    genre ON genre.movie_id = movie.id
INNER JOIN 
    ratings ON ratings.movie_id = movie.id
WHERE 
    genre.genre = 'thriller'
    AND total_votes >= 25000
ORDER BY 
    avg_rating DESC;



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

WITH genre_avg_duration AS (
    SELECT 
        genre.genre,
        ROUND(AVG(movie.duration), 2) AS avg_duration
    FROM 
        movie
    INNER JOIN 
        genre ON genre.movie_id = movie.id
    GROUP BY 
        genre.genre
)
SELECT 
    genre,
    avg_duration,
    
    -- Running total (cumulative sum)
    SUM(avg_duration) OVER (
        ORDER BY genre
    ) AS running_total_duration,
    
    -- Moving average of last 3 rows (including current)
    ROUND(AVG(avg_duration) OVER (
        ORDER BY genre
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_duration

FROM genre_avg_duration;



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

WITH top_genres AS (
    SELECT genre
    FROM genre
    GROUP BY genre
    ORDER BY COUNT(*) DESC
    LIMIT 3
),
ranked_movies AS (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), ',', '') AS UNSIGNED) AS worldwide_gross_income,
        RANK() OVER (
            PARTITION BY m.year, g.genre 
            ORDER BY CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), ',', '') AS UNSIGNED) DESC
        ) AS movie_rank
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres)
      AND m.worlwide_gross_income IS NOT NULL
)
SELECT 
    genre,
    year,
    movie_name,
    worldwide_gross_income,
    movie_rank
FROM ranked_movies
WHERE movie_rank <= 5
ORDER BY year, genre, movie_rank;


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

SELECT 
    m.production_company,
    COUNT(*) AS movie_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_comp_rank
FROM 
    movie m
JOIN 
    ratings r ON r.movie_id = m.id
WHERE 
    r.median_rating >= 8
    AND m.production_company IS NOT NULL
    AND POSITION(',' IN m.languages) > 0  -- Multilingual check
GROUP BY 
    m.production_company
ORDER BY 
    prod_comp_rank
LIMIT 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH superhit_drama AS (
    SELECT m.id AS movie_id, r.avg_rating, r.total_votes
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    JOIN genre g ON m.id = g.movie_id
    WHERE r.avg_rating > 8 AND g.genre = 'Drama'
),
actress_stats AS (
    SELECT 
        n.name AS actress_name,
        COUNT(*) AS movie_count,
        SUM(r.total_votes) AS total_votes,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 4) AS actress_avg_rating
    FROM role_mapping rm
    JOIN names n ON rm.name_id = n.id
    JOIN superhit_drama r ON rm.movie_id = r.movie_id
    WHERE rm.category = 'actress'
    GROUP BY n.name
)
SELECT *,
       RANK() OVER (
           ORDER BY actress_avg_rating DESC, total_votes DESC, actress_name
       ) AS actress_rank
FROM actress_stats
ORDER BY actress_rank
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

WITH director_data AS (
    SELECT 
        dm.name_id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes
    FROM director_mapping dm
    JOIN names n ON dm.name_id = n.id
    JOIN movie m ON dm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.date_published IS NOT NULL
),
top_directors AS (
    SELECT director_id, director_name, COUNT(*) AS number_of_movies
    FROM director_data
    GROUP BY director_id, director_name
    ORDER BY number_of_movies DESC
    LIMIT 9
),
gaps AS (
    SELECT 
        director_id,
        DATEDIFF(
            LEAD(date_published) OVER (PARTITION BY director_id ORDER BY date_published),
            date_published
        ) AS gap_days
    FROM director_data
)
SELECT 
    td.director_id,
    td.director_name,
    td.number_of_movies,
    ROUND(AVG(g.gap_days), 0) AS avg_inter_movie_days,
    ROUND(AVG(d.avg_rating), 2) AS avg_rating,
    SUM(d.total_votes) AS total_votes,
    MIN(d.avg_rating) AS min_rating,
    MAX(d.avg_rating) AS max_rating,
    SUM(d.duration) AS total_duration
FROM top_directors td
JOIN director_data d ON td.director_id = d.director_id
LEFT JOIN gaps g ON td.director_id = g.director_id
GROUP BY td.director_id, td.director_name, td.number_of_movies
ORDER BY td.number_of_movies DESC;






