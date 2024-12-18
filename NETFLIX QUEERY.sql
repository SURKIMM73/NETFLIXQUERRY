--COUNT THE NUMBER OF TV SHOWS AND MOVIES
SELECT *from netflix_titles;
select type,COUNT(*) as	Total
from netflix_titles
group by type
order by Total desc;

--FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOW
select type,rating
from
(select type,rating,count(*)as count ,
rank() over(partition by type order by count(*) desc ) rank
from netflix_titles
group by type,rating) t1
where rank = 1;

--LIST ALL MOVIES RELEASED IN 2020
SELECT *
from netflix_titles
where type = 'movie' and release_year = 2020;
 
--FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENT IN NETFLIX
select  top 5 count (*) as count,value
from netflix_titles
cross apply 
string_split(country,',')

group by value
order by count desc 

--IDENTIFY THE LONGEST MOVIE
select *from netflix_titles
where type = 'movie' and duration = (select MAX(duration) from netflix_titles);

--FIND THE CONTENT ADDED IN THE LAST 5YEARS
select * ,
cast (date_added as date) as format_date 
from netflix_titles
where cast( date_added as date) >= dateadd(year,-5,getdate())

--	FIND ALL THE MOVIES AND TVSHOWS DIRECTED BY RAJIV CHILANKA

select * from netflix_titles

-- LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS
select * from netflix_titles
where type = 'TV Show' 
              and
			  cast(substring(duration,1,CHARINDEX(' ',duration) -1 ) as int) > 5;
			
--	COUNT THE NUMBER OF CONTENT ITEM IN EACH GENRE
select value,COUNT(*) as count
from netflix_titles
cross apply
string_split(listed_in,',')
group by value
order by count desc

--FIND EACH YEAR AND THE AVERAGE NUMBERS OF CONTENT RELEASED BY INDIA AND NETFLIX .RETURNS TO TOP 5YEARS WITH HIGHIEST AVERAGE CONTENT RELEASED

--LIST ALL DOCUMENTARIES
select netflix_titles.*,genre.value
from netflix_titles
cross apply
string_split(listed_in,',') genre
where lower(value) like  '%documentaries%'

--FIND ALL CONTENT WITHOUT A DIRECTOR
select netflix_titles.*
from netflix_titles

where director is null 

--	FIND MOVIES WHERE SALMAN KHAN APPEAARED IN THE LAST 10 YEARS

select netflix_titles.*,CAST(date_added as date)
from netflix_titles
where LOWER(cast) like '%salman khan%' 
and 
cast(date_added as date ) >= DATEADD(year,-10,getdate())

--FIND THE TOP 10 ACTORS WHO HAVE APPEARED IN THE HIEest number of movies produced in india
select top 10 cast.value, netflix_titles.type,count(*) as count
from netflix_titles
cross apply
string_split(cast,',') cast
group by value,type
order by count desc

-- CATEGORIZE THE CONTENT BASED ON THE KEYWORD KILL KILL AND VIOLENCE IN THE DESCRIPTION FIELD . LABEL THE CONTENT CONTAINING THIS KEYWORDS ASS BAD AND ALL OTHERS AS GOOD .COUNT HOW MANY ITEMS FALLLS IN EACH CATEGORY
with new_Table as
(
select *,
case  
    when lower(description) like '%kill%' then 'Bad_contet'
	when lower(description) like '%violence%' then 'Bad_content'
	else 'Good_content'
	end as category
from netflix_titles
)
select category, count(*)
from new_Table
group by category;