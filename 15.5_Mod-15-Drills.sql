-- Karan Patel MOD 15 drills

-- 2. Write a query that returns the namefirst and namelast fields of the people table, along with the inducted field from the hof_inducted table. 
--All rows from the people table should be returned, and NULL values for the fields from 
--hof_inducted should be returned when there is no match found.

SELECT namefirst, namelast, inducted
FROM people LEFT OUTER JOIN hof_inducted
ON people.playerid = hof_inducted.playerid;

-- 3. Write a query that returns the yearid, playerid, teamid, and salary fields from the salaries table, 
--along with the category field from the hof_inducted table. Keep only the records that are in both salaries and hof_inducted. 
--Hint: Although a field named yearid is found in both tables, don't JOIN by it. But you must explicitly name which field to include.

SELECT salaries.yearid, salaries.playerid, teamid, salary, category
FROM salaries INNER JOIN hof_inducted
ON salaries.playerid = hof_inducted.playerid;

-- 4. Write a query that returns the playerid, yearid, teamid, lgid, and salary fields from the salaries table and the 
--inducted field from the hof_inducted table. Keep all records from both tables.

SELECT salaries.playerid, salaries.yearid, teamid, lgid, salary, inducted
FROM salaries FULL OUTER JOIN hof_inducted
ON salaries.playerid = hof_inducted.playerid;

-- 5. There are two tables, hof_inducted and hof_not_inducted, indicating successful and unsuccessful inductions 
--into the Baseball Hall of Fame, respectively.
-- a. Combine these two tables by all fields. Keep all records.
-- b. Get a distinct list of all player IDs for players who have been put up for HOF induction.

SELECT * FROM hof_inducted
UNION ALL
SELECT * FROM hof_not_inducted;

SELECT playerid FROM hof_inducted
UNION 
SELECT playerid FROM hof_not_inducted;

-- 6. Write a query that returns the last name, first name (see the people table), 
--and total recorded salaries for all players found in the salaries table.

SELECT namelast, namefirst, SUM(salary) AS total_salary
FROM people LEFT OUTER JOIN salaries
ON people.playerid = salaries.playerid
GROUP by people.playerid, namelast, namefirst;

-- 7. Write a query that returns all records from the hof_inducted and hof_not_inducted tables that include playerid, yearid, 
--namefirst, and namelast. Hint: Each FROM statement will include a LEFT OUTER JOIN.

SELECT hof_inducted.playerid, yearid, namefirst, namelast
FROM hof_inducted LEFT OUTER JOIN people
ON hof_inducted.playerid = people.playerid

UNION ALL

SELECT hof_not_inducted.playerid, yearid, namefirst, namelast
FROM hof_not_inducted LEFT OUTER JOIN people
ON hof_not_inducted.playerid = people.playerid;

-- 8. Return a table including all records from both hof_inducted and hof_not_inducted. Include a new field, namefull, which is 
--formatted as namelast , namefirst (in other words, the last name, followed by a comma, then a space, then the first name). 
--The query should also return the yearid and inducted fields. Include only records since 1980 from both tables. 
--Sort the resulting table by yearid, then inducted so that Y comes before N. Finally, sort by the namefull field alphabetically.

SELECT CONCAT(namelast, ', ', namefirst) AS namefull, yearid, inducted
FROM hof_inducted LEFT OUTER JOIN people
ON hof_inducted.playerid = people.playerid
WHERE yearid >= 1980

UNION ALL 

SELECT CONCAT(namelast, ', ', namefirst) AS namefull, yearid, inducted
FROM hof_not_inducted LEFT OUTER JOIN people
ON hof_not_inducted.playerid = people.playerid
WHERE yearid >= 1980

ORDER BY yearid, inducted DESC, namefull;

-- 9. Write a query that returns each year's highest annual salary for each team ID, ranked from high to low, 
--along with the corresponding player ID. Bonus: Return namelast and namefirst in the resulting table. 
--(You can find these in the people table.)

WITH max AS
(SELECT MAX(salary) as max_salary, teamid, yearid
FROM salaries
GROUP BY teamid, yearid)
SELECT salaries.yearid, salaries.teamid, playerid, max.max_salary
FROM max LEFT OUTER JOIN salaries
ON salaries.teamid = max.teamid AND salaries.yearid = max.yearid AND salaries.salary = max.max_salary
ORDER BY max.max_salary DESC;

-- 10. Select birthyear, deathyear, namefirst, and namelast of all the players born since the birth year of 
--Babe Ruth (whose playerid is ruthba01). Sort the results by birth year from low to high.

SELECT birthyear, deathyear, namefirst, namelast
FROM people
WHERE birthyear > ANY
			(SELECT birthyear
			FROM people
			WHERE playerid = 'ruthba01')
ORDER by birthyear;

-- 11. Using the people table, write a query that returns namefirst, namelast, and a field called usaborn. 
--The usaborn field should show the following: if the player's birthcountry is the USA, then the record is USA.
--Otherwise, it's non-USA. Order the results by non-USA records first.

SELECT namefirst, namelast,
	CASE
		 WHEN birthcountry = 'USA' then 'USA'
		 ELSE 'non-USA'
	END as usaborn
FROM people
ORDER BY 3;

-- 12. Calculate the average height for players throwing with their right hand versus their left hand. 
--Name these fields right_height and left_height, respectively.

SELECT 
AVG(CASE WHEN throws = 'R' then height END) AS right_height,
AVG(CASE WHEN throws = 'L' then height END) AS left_height
FROM people;

-- 13. Get the average of each team's maximum player salary since 2010. Hint: WHERE will go outside of your CTE.
WITH max_sal_by_team_by_year AS
  (
  SELECT teamid, yearid, max(salary) AS max_sal
  FROM salaries
  GROUP BY teamid, yearid
  )
SELECT teamid, AVG(max_sal) AS avg_max_sal_since_2010
FROM max_sal_by_team_by_year
WHERE yearid >= 2010
GROUP BY teamid; 




