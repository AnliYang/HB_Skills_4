-- Note: Please consult the directions for this assignment 
-- for the most explanatory version of each question.

-- 1. Select all columns for all brands in the Brands table.
SELECT * 
FROM Brands
;


-- 2. Select all columns for all car models made by Pontiac in the Models table.
SELECT *
FROM Models
WHERE brand_name = 'Pontiac'
;


-- 3. Select the brand name and model 
--    name for all models made in 1964 from the Models table.
SELECT brand_name AS "brand name", 
       name AS "model name"
FROM Models
WHERE year = 1964
;


-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the Models and Brands tables.
SELECT m.name AS "model name", 
       b.name AS "brand name", 
       headquarters
FROM Models AS m
    JOIN Brands AS b ON b.name = m.brand_name
WHERE m.name = 'Mustang'
;


-- 5. Select all rows for the three oldest brands 
--    from the Brands table (Hint: you can use LIMIT and ORDER BY).
SELECT *
FROM Brands
ORDER BY founded
LIMIT 3
;


-- 6. Count the Ford models in the database (output should be a number).
SELECT count(id)
FROM Models
WHERE brand_name = 'Ford'
;


-- 7. Select the name of any and all car brands that are not discontinued.
SELECT name 
FROM Brands 
WHERE discontinued IS NULL
;


-- 8. Select rows 15-25 of the DB in alphabetical order by model name.
-- if you meant sort alphabetically first and then limit the results: 
SELECT *
FROM Models
ORDER BY name
OFFSET 14
LIMIT 11
;

-- or if you meant id's 15-25, just sorted alphabetically by model name:
SELECT * 
FROM 
    (SELECT * 
    FROM Models 
    ORDER BY id 
    OFFSET 14 
    LIMIT 11) AS subquery 
ORDER by name;


-- 9. Select the brand, name, and year the model's brand was 
--    founded for all of the models from 1960. Include row(s)
--    for model(s) even if its brand is not in the Brands table.
--    (The year the brand was founded should be NULL if 
--    the brand is not in the Brands table.)
SELECT b.name AS "brand", 
       m.name AS "model", 
       b.founded AS "brand founding year"
FROM Models AS m
    LEFT JOIN Brands AS b ON b.name = m.brand_name
WHERE m.year = 1960
;


-- Part 2: Change the following queries according to the specifications. 
-- Include the answers to the follow up questions in a comment below your
-- query.

-- 1. Modify this query so it shows all brands that are not discontinued
-- regardless of whether they have any models in the models table.
-- before:
    -- SELECT b.name,
    --        b.founded,
    --        m.name
    -- FROM Models AS m
    --   LEFT JOIN brands AS b
    --     ON b.name = m.brand_name
    -- WHERE b.discontinued IS NULL;
SELECT b.name AS "make"
       ,b.founded 
       ,m.name AS "model"
FROM Brands AS b
  LEFT JOIN Models AS m
    ON m.brand_name = b.name
WHERE b.discontinued IS NULL;

-- if you just want brands alphabetically, and a list of their distinct models:
SELECT b.name AS "make",
       b.founded, 
       string_agg(distinct m.name, ', ') AS "model(s)"
FROM Brands AS b
  LEFT JOIN Models AS m
    ON m.brand_name = b.name
WHERE b.discontinued IS NULL
GROUP BY b.name,
         b.founded
ORDER BY b.name
;


-- 2. Modify this left join so it only selects models that have brands in the Brands table.
-- before: 
    -- SELECT m.name,
    --        m.brand_name,
    --        b.founded
    -- FROM Models AS m
    --   LEFT JOIN Brands AS b
    --     ON b.name = m.brand_name;

SELECT m.name,
       m.brand_name,
       b.founded
FROM Models AS m
  INNER JOIN Brands AS b
    ON b.name = m.brand_name;

-- followup question: In your own words, describe the difference between 
-- left joins and inner joins.

-- ANLI'S DISCUSSION COMMENT:
-- LEFT JOINS retain values from the first table (the one to the left of the JOIN)
-- that don't actually have a match in the second table (to the right of the JOIN).
-- An INNER JOIN only retains values where a match is found across both tables.
-- (In venn-diagram talk, with a left circle and a right circle overlapping in the
-- middle: a LEFT JOIN keeps all values in the left circle, including but not
-- limited to those overlapping with the right circle; an INNER JOIN, however,
-- only keeps the values in the overlapping section.)
-- In the above example exercise, the original query with a LEFT JOIN was keeping 
-- the Fillmore car that existed in the models table.  Because Fillmore doesn't 
-- exist in the brands table, the Fillmore result dropped off in the updated query 
-- with the INNER JOIN. 



-- 3. Modify the query so that it only selects brands that don't have any models in the models table. 
-- (Hint: it should only show Tesla's row.)
-- before: 
    -- SELECT name,
    --        founded
    -- FROM Brands
    --   LEFT JOIN Models
    --     ON brands.name = Models.brand_name
    -- WHERE Models.year > 1940;

SELECT brands.name,
       founded
FROM Brands
  LEFT JOIN Models
    ON brands.name = models.brand_name
WHERE models.id is null;


-- 4. Modify the query to add another column to the results to show 
-- the number of years from the year of the model until the brand becomes discontinued
-- Display this column with the name years_until_brand_discontinued.
-- before: 
    -- SELECT b.name,
    --        m.name,
    --        m.year,
    --        b.discontinued
    -- FROM Models AS m
    --   LEFT JOIN brands AS b
    --     ON m.brand_name = b.name
    -- WHERE b.discontinued NOT NULL;

SELECT b.name,
       m.name,
       m.year,
       b.discontinued,
       (b.discontinued - m.year) AS "years_until_brand_discontinued"
FROM Models AS m
  LEFT JOIN Brands AS b
    ON m.brand_name = b.name
WHERE b.discontinued IS NOT NULL;


-- Part 3: Further Study

-- 1. Select the name of any brand with more than 5 models in the database.
SELECT b.name, 
       count(m.id)
FROM brands b
    LEFT JOIN models m ON m.brand_name = b.name
GROUP BY b.name
HAVING count(m.id) > 5
;

-- 2. Add the following rows to the Models table.

-- year    name       brand_name
-- ----    ----       ----------
-- 2015    Chevrolet  Malibu
-- 2015    Subaru     Outback

-- Note: brand name and name columns are reversed in above example
INSERT INTO Models (year, brand_name, name)
VALUES (2015, 'Chevrolet', 'Malibu'), 
       (2015, 'Suburu', 'Outback')
;


-- 3. Write a SQL statement to crate a table called `Awards`
--    with columns `name`, `year`, and `winner`. Choose
--    an appropriate datatype and nullability for each column
--   (no need to do subqueries here).
CREATE TABLE Awards (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    winner INTEGER NOT NULL
        REFERENCES Models
);


-- 4. Write a SQL statement that adds the following rows to the Awards table:

--   name                 year      winner_model_id
--   ----                 ----      ---------------
--   IIHS Safety Award    2015      the id for the 2015 Chevrolet Malibu
--   IIHS Safety Award    2015      the id for the 2015 Subaru Outback

INSERT INTO Awards (name, year, winner)
VALUES ('IIHS Safety Award', 2015, 49),
       ('IIHS Safety Award', 2015, 50)
;


-- 5. Using a subquery, select only the *name* of any model whose 
-- year is the same year that *any* brand was founded.

SELECT *
FROM Models
WHERE year IN
-- subquery to get years brand foundings
    (SELECT DISTINCT founded
     FROM Brands)
;



