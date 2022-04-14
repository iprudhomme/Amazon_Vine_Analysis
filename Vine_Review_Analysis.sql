-- vine table to hold the data we exported from AWS
CREATE TABLE vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating INTEGER,
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
);


DROP TABLE IF EXISTS vines_table_gte_20;
-- Create a table with records that have more than 20 votes
SELECT * 
INTO vines_table_gte_20
FROM vine_table 
WHERE total_votes >= 20; 

DROP TABLE IF EXISTS vines_table_helpful_50pct;
-- Create a table from the total votes >= 20 and filter by helpful_votes/total_votes more than 50%
SELECT * 
INTO vines_table_helpful_50pct
FROM vines_table_gte_20
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;

DROP TABLE IF EXISTS vines_table_program_y;
-- Create a table for the records from the previous filter that are paid vine members
SELECT *  
INTO vines_table_program_y
FROM vines_table_helpful_50pct
WHERE vine = 'Y';

DROP TABLE IF EXISTS vines_table_program_n;
-- Create a table for the records from the previous filter that are NOT paid vine members
SELECT *  
INTO vines_table_program_n
FROM vines_table_helpful_50pct
WHERE vine = 'N';

-- Provide the Total Count, FiveStarReviews, and percent of five star reviews for Vine members
SELECT count(*) as "TotalCount",
	   sum(case when star_rating = 5 then 1 else 0 end) as FiveStarReviews,
	   ROUND((cast(sum(case when star_rating = 5 then 1 else 0 end) as numeric)/count(*))*100,1)  as Percent5StarReview
FROM vines_table_program_y;

-- Provide the Total Count, FiveStarReviews, and percent of five star reviews for Non-Vine members
SELECT count(*) as "TotalCount",
	   sum(case when star_rating = 5 then 1 else 0 end) as FiveStarReviews,
	   ROUND((cast(sum(case when star_rating = 5 then 1 else 0 end) as numeric)/count(*))*100,1)  as Percent5StarReview
FROM vines_table_program_n;
