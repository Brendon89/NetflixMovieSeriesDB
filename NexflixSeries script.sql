/*
TV-MA is content for mature audience. Typically anyone above 17.
TV-Y: TV Youth. This is content suitable for children including those 2-6 years of age
TV-G: TV Genra; audience. Content suitable for all ages including children
NC-17:No under 17 years. Its suitable for audience 18 years and older
NR: Not rated. Content has not been assigned official rating by a recognised rating organization.
PG -Parental guidance is advised.Some content may not be suitable for children.
TV-Y7-FV: TV Youth 7 and Older-Fantasy Voilence: content is sutable for children 7 and older with focus on fantasy violence.
TV-Y7: TV Youth 7 and oldder.Content suitable for children aged 7 and older
TV-14: 14 years and older
G- General audience
R- Restricted. Its for views older than 18
*/

---------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------TV Shows-----------------------------------------------------------------------



--Series that are suitable for children alone
select sr.s_title as 'Movie Name', sr.s_rating as 'Move Rating'
from Series sr
where sr.s_rating LIKE'%TV-G%' OR sr.s_rating LIKE'%TV-Y7-FV%'
OR sr.s_rating LIKE'%TV-Y%'

--Gives auidience an idea of which series to watch with depending on the rating of the content(for children or not)

--------------------------------------------
CREATE PROCEDURE GetSeriesRatingDescription
AS
BEGIN
    -- Declare variables
    DECLARE @RatingDescription NVARCHAR(100);

    -- Select series title, rating, and rating description
    SELECT
        sr.s_title,
        sr.s_rating,
        CASE
            WHEN sr.s_rating = 'TV-G' THEN 'General Audience'
            WHEN sr.s_rating = 'R' THEN 'Restricted'
            WHEN sr.s_rating = 'TV-MA' THEN 'For mature audience'
            WHEN sr.s_rating = 'TV-Y' THEN 'Suitable for children 2-6 years old'
            WHEN sr.s_rating = 'TV-Y7-FV' THEN 'Suitable for children with fantasy violence'
            WHEN sr.s_rating = 'TV-14' THEN 'Suitable for 14 years of age and older'
            WHEN sr.s_rating = 'NC-17' THEN 'Not suitable for younger than 17 viewers'
            WHEN sr.s_rating = 'TV-PG' THEN 'Parental guidance is advised'
            WHEN sr.s_rating = 'TV-Y7' THEN 'For children 7 years and older'
			WHEN sr.s_rating = 'PG' THEN 'Parental guidance is advised'
            ELSE 'Content is not rated. Most likely not suitable for children'
        END AS RatingDescription
    INTO #SeriesRatingDescription
    FROM Series sr;

    -- Retrieve the result
    SELECT *
    FROM #SeriesRatingDescription;

    -- Clean up temporary table
    DROP TABLE IF EXISTS #SeriesRatingDescription;
END;


EXEC GetSeriesRatingDescription




--Lets find series are not longer than 2 seasons that are for for viewers older than 18 years of age( TV-MA)
CREATE PROCEDURE GetSeriesAndRatings
AS
BEGIN
		DECLARE @MinDuration varchar(50);
		DECLARE @MaxDuration varchar(50);

		SELECT @MinDuration = MIN(s_duration),@MaxDuration=Max(s_duration) FROM Series 
		PRINT 'Duration Range: ' + CAST(@MinDuration AS VARCHAR(50)) + ' - ' + CAST(@MaxDuration AS VARCHAR(50));

		select sr.s_title, sr.s_duration,sr.s_rating
		from Series sr
		where sr.s_duration LIKE '1 %' AND SR.s_rating LIKE'TV-MA%'
	END;

EXEC GetSeriesAndRatings





--Series that were released in 2010 that is Anime. And if content is suitable for children or not.
--State if its suitable or not.
CREATE PROCEDURE AnimeNotForYoungViewers 
AS
BEGIN
select sr.s_title as 'Series Name',sr.s_listed_in as Listing , sr.s_release_year as Year,sr.s_rating as Rating,
 CASE
		WHEN s_rating ='TV-G' THEN 'General Audience' 
		WHEN s_rating = 'R' THEN 'Restricted'
		WHEN s_rating = 'TV-MA' THEN 'For mature audience'
		WHEN s_rating ='TV-Y' THEN 'Suitable for children 2-6 years old'
		WHEN s_rating = 'TV-Y7-FV' THEN 'Suitable for children with fantasy violence'
		WHEN s_rating ='TV-14' THEN 'Suitabel for 14 years of age and older'
		WHEN s_rating = 'NC-17' THEN 'Not suitable for younger than 17 viewers'
		WHEN s_rating = 'TV-PG' THEN 'Parental guidance is advised'
		WHEN s_rating = 'TV-Y7' THEN 'For children 7 years and older'
		ELSE 'Content is not rated.Most likely not suitable for children'
	END Description
 
from Series sr
where sr.s_listed_in LIKE 'Anime%' AND sr.s_release_year BETWEEN '2010' AND '2015'
Group by sr.s_title, sr.s_listed_in,sr.s_listed_in,sr.s_rating,sr.s_release_year
HAVING COUNT(*) > 0
Order by sr.s_release_year
END;
EXEC AnimeNotForYoungViewers 

 
--How many series has Rajiv Chilaka directed between the years 2000 and 2005 ?

Select sr.s_title AS 'Rajiv Series', sr.s_release_year as 'Year released'
from Series sr
where sr.s_director = 'Rajiv Chilaka' and sr.s_release_year BETWEEN '2000' AND '2005'
Order by sr.s_release_year
---------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------MOVIES-----------------------------------------------------------------------

--Cleaning data. Replacing Old rated to NR-not rated.

select mv.m_rating, mv.m_title
from Movies mv where mv.m_rating = 'Old'

UPDATE Movies
SET m_rating = 'NR'
where m_rating = 'Old';

--Purely Dramas
--Movies which are purely dramas and only that
Select mv.m_listed_in, mv.m_title 
from Movies mv 
where mv.m_listed_in LIKE 'Dramas'


--Which of these movies are Stand up comedy and the country created by
Select mv.m_listed_in, mv.m_title ,mv.m_country
from Movies mv 
where mv.m_listed_in LIKE '%Stand-up Comedy%'


--Which of these movies are Stand up comedy and which how many are South African and which one
Select mv.m_listed_in, mv.m_title ,mv.m_country
from Movies mv 
where mv.m_listed_in LIKE '%Stand-up Comedy%' AND mv.m_country LIKE'%South Africa%'




--COME CHECK THIS ONE OUT AGAIN PLEASEE -CHECK IF THERE IS CLEANER WAY TO FILTER RATING
--Movies which are drama and comedy which are not suitable for children.

SELECT mv.m_listed_in, mv.m_title, mv.m_rating
FROM Movies mv
WHERE mv.m_listed_in LIKE '%Drama%' AND mv.m_listed_in LIKE '%Comedies%'
  AND mv.m_listed_in NOT LIKE '%Children & Family%'
  AND mv.m_rating NOT IN ('TV-14', 'PG-13', 'TV-Y7', 'TV-Y7-FV');

 


--List of movies that aren't rated that are Action movies
/*A lot of these movies will not be recommended for children to watch.
There is horror movies, documentaries, stand up comedy which probably has strong language in and story lines may not be suitable for children
*/
Select mv.m_title,mv.m_rating,mv.m_listed_in
from
Movies mv
where mv.m_rating ='NR' AND mv.m_listed_in LIKE '%Action%'
Order by mv.m_title asc



/*
Which movies are suitable for 14 year olds strictly ,directed by Rajiv Chilaka
Children rating include:TV-Y,PG13,PG13,TV-G
*/
Select mv.m_title, mv.m_duration,mv.m_rating,MV.m_director
from Movies mv
where MV.m_director LIKE '%Rajiv Chilaka%' AND
mv.m_rating LIKE '%TV-14%'


--How many movies are directed by Brad Peyton
Select mv.m_title, mv.m_duration,mv.m_rating,MV.m_director
from Movies mv
where MV.m_director LIKE '%Brad Peyton%'




--Movies that were released between 2010 and 2015 that is Anime. And if content is suitable for children or not.
--State if its suitable or not.
CREATE PROCEDURE AnimeSeriesDetails2010_2015
AS
BEGIN
select mv.m_title as 'Series Name',mv.m_listed_in as Listing , mv.m_release_year as Year,mv.m_rating as Rating,
 CASE
		WHEN m_rating ='TV-G' THEN 'General Audience' 
		WHEN m_rating = 'R' THEN 'Restricted'
		WHEN m_rating = 'TV-MA' THEN 'For mature audience'
		WHEN m_rating ='TV-Y' THEN 'Suitable for children 2-6 years old'
		WHEN m_rating = 'TV-Y7-FV' THEN 'Suitable for children with fantasy violence'
		WHEN m_rating ='TV-14' THEN 'Suitabel for 14 years of age and older'
		WHEN m_rating = 'NC-17' THEN 'Not suitable for younger than 17 viewers'
		WHEN m_rating = 'TV-PG' THEN 'Parental guidance is advised'
		WHEN m_rating = 'TV-Y7' THEN 'For children 7 years and older'
		WHEN m_rating = 'PG-13' THEN 'For children 13 years and older,parental guidance is advised'
		WHEN m_rating = 'PG' THEN 'Parental guidance is advised'
		ELSE 'Content is not rated.Most likely not suitable for children'
	END Description
 
from Movies mv
where mv.m_listed_in LIKE 'Anime%' AND mv.m_release_year BETWEEN '2010' AND '2018'
Group by mv.m_title, mv.m_listed_in,mv.m_listed_in,mv.m_rating,mv.m_release_year
HAVING COUNT(*) > 0
END;

EXEC AnimeSeriesDetails2010_2015



----


