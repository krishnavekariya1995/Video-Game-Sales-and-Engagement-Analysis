show databases;
create database video_game_analysis;
use video_game_analysis;
CREATE TABLE games_clean (
    Title VARCHAR(255),
    Platform VARCHAR(50),
    Genres VARCHAR(100),
    Rating DECIMAL(3,1),
    Wishlist INT,
    Plays INT,
    Backlogs INT,
    Release_Year INT,
    Team VARCHAR(255)
);
CREATE TABLE vgsales_clean (
    Name VARCHAR(255),
    Platform VARCHAR(50),
    Year INT,
    Genre VARCHAR(100),
    Publisher VARCHAR(255),
    NA_Sales DECIMAL(6,2),
    EU_Sales DECIMAL(6,2),
    JP_Sales DECIMAL(6,2),
    Other_Sales DECIMAL(6,2),
    Global_Sales DECIMAL(6,2)
);


SET GLOBAL local_infile = 1;
select count(*) from games_clean;
TRUNCATE TABLE games_clean;
DROP TABLE IF EXISTS games_clean;

CREATE TABLE games_clean (
    Title VARCHAR(255),
    Genres VARCHAR(100),
    Rating DECIMAL(3,1),
    Wishlist VARCHAR(20),
    Plays VARCHAR(20),
    Backlogs VARCHAR(20),
    Release_Year INT,
    Team VARCHAR(255)
);

TRUNCATE TABLE games_clean;
select count(*) from games_clean;

CREATE TABLE vgsales_clean (
    Rank INT,
    Name VARCHAR(255),
    Platform VARCHAR(50),
    Year INT,
    Genre VARCHAR(100),
    Publisher VARCHAR(255),
    NA_Sales DECIMAL(6,2),
    EU_Sales DECIMAL(6,2),
    JP_Sales DECIMAL(6,2),
    Other_Sales DECIMAL(6,2),
    Global_Sales DECIMAL(6,2)
);
select count(*) from vgsales_clean;

select
	g.Title,
    g.Rating,
    g.Wishlist,
    g.Plays,
    v.Platform,
    v.Year,
    v.Global_Sales,
    v.NA_Sales,
    v.EU_Sales,
    v.JP_Sales
From games_clean g
inner join vgsales_clean v
	on g.Title = v.Name;

--What are the top-rated games by user reviews?
SELECT
    Title,
    AVG(Rating) AS avg_rating
FROM games_clean
GROUP BY Title
ORDER BY avg_rating DESC
LIMIT 10;

--Which developers (Teams) have the highest average ratings?

SELECT
    Team,
    AVG(Rating) AS avg_rating,
    COUNT(*) AS total_games
FROM games_clean
WHERE Team IS NOT NULL
GROUP BY Team
HAVING COUNT(*) >= 3
ORDER BY avg_rating DESC
LIMIT 10;

--What are the most common genres in the dataset?

SELECT
    Genres,
    COUNT(*) AS game_count
FROM games_clean
GROUP BY Genres
ORDER BY game_count DESC
LIMIT 10;

--Which games have the highest backlog compared to wishlist?

SELECT
    Title,
    SUM(Backlogs) AS total_backlogs,
    SUM(Wishlist) AS total_wishlist,
    ROUND(SUM(Backlogs) / NULLIF(SUM(Wishlist), 0), 2) AS backlog_wishlist_ratio
FROM games_clean
GROUP BY Title
HAVING SUM(Wishlist) > 0
ORDER BY backlog_wishlist_ratio DESC
LIMIT 10;

--What is the game release trend across years?

SELECT
    Release_Year,
    COUNT(*) AS games_released
FROM games_clean
WHERE Release_Year IS NOT NULL
GROUP BY Release_Year
ORDER BY Release_Year;

--What is the distribution of user ratings?

SELECT
    Rating,
    COUNT(*) AS rating_count
FROM games_clean
WHERE Rating IS NOT NULL
GROUP BY Rating
ORDER BY Rating;

--What are the top 10 most wishlisted games?

SELECT
    Title,
    SUM(Wishlist) AS total_wishlist
FROM games_clean
GROUP BY Title
ORDER BY total_wishlist DESC
LIMIT 10;

--What’s the average number of plays per genre?

SELECT
    Genres,
    ROUND(AVG(Plays), 0) AS avg_plays
FROM games_clean
GROUP BY Genres
ORDER BY avg_plays DESC
LIMIT 10;

--Which developer studios are the most productive and impactful?

SELECT
    Team,
    COUNT(*) AS total_games,
    ROUND(AVG(Rating), 2) AS avg_rating
FROM games_clean
WHERE Team IS NOT NULL
GROUP BY Team
HAVING COUNT(*) >= 3
ORDER BY total_games DESC, avg_rating DESC
LIMIT 10;

--Which region generates the most game sales?

SELECT
    'NA' AS region, ROUND(SUM(NA_Sales), 2) AS total_sales FROM vgsales_clean
UNION ALL
SELECT
    'EU', ROUND(SUM(EU_Sales), 2) FROM vgsales_clean
UNION ALL
SELECT
    'JP', ROUND(SUM(JP_Sales), 2) FROM vgsales_clean
UNION ALL
SELECT
    'Other', ROUND(SUM(Other_Sales), 2) FROM vgsales_clean;

--What are the best-selling platforms?

SELECT
    Platform,
    ROUND(SUM(Global_Sales), 2) AS total_sales
FROM vgsales_clean
GROUP BY Platform
ORDER BY total_sales DESC
LIMIT 10;

--What’s the trend of game releases and sales over years?

SELECT
    Year,
    ROUND(SUM(Global_Sales), 2) AS total_sales
FROM vgsales_clean
WHERE Year IS NOT NULL
GROUP BY Year
ORDER BY Year;

--Who are the top publishers by sales?

SELECT
    Publisher,
    ROUND(SUM(Global_Sales), 2) AS total_sales
FROM vgsales_clean
WHERE Publisher IS NOT NULL
GROUP BY Publisher
ORDER BY total_sales DESC
LIMIT 10;

--Which games are the top 10 best-sellers globally?

SELECT
    Name,
    ROUND(SUM(Global_Sales), 2) AS total_global_sales
FROM vgsales_clean
GROUP BY Name
ORDER BY total_global_sales DESC
LIMIT 10;

--How do regional sales compare for specific platforms?

SELECT
    Platform,
    ROUND(SUM(NA_Sales), 2) AS NA_sales,
    ROUND(SUM(EU_Sales), 2) AS EU_sales,
    ROUND(SUM(JP_Sales), 2) AS JP_sales,
    ROUND(SUM(Other_Sales), 2) AS Other_sales
FROM vgsales_clean
GROUP BY Platform
ORDER BY NA_sales DESC
LIMIT 10;

--How has the market evolved by platform over time?

SELECT
    Year,
    Platform,
    ROUND(SUM(Global_Sales), 2) AS total_sales
FROM vgsales_clean
WHERE Year IS NOT NULL
GROUP BY Year, Platform
ORDER BY Year, total_sales DESC;

--What are the regional genre preferences?

SELECT
    Genre,
    ROUND(SUM(NA_Sales), 2) AS NA_sales,
    ROUND(SUM(EU_Sales), 2) AS EU_sales,
    ROUND(SUM(JP_Sales), 2) AS JP_sales
FROM vgsales_clean
GROUP BY Genre
ORDER BY NA_sales DESC;

--What’s the yearly sales change per region?

SELECT
    Year,
    ROUND(SUM(NA_Sales), 2) AS NA_sales,
    ROUND(SUM(EU_Sales), 2) AS EU_sales,
    ROUND(SUM(JP_Sales), 2) AS JP_sales,
    ROUND(SUM(Other_Sales), 2) AS Other_sales
FROM vgsales_clean
WHERE Year IS NOT NULL
GROUP BY Year
ORDER BY Year;

--What is the average sales per publisher?

SELECT
    Publisher,
    ROUND(AVG(Global_Sales), 2) AS avg_global_sales
FROM vgsales_clean
WHERE Publisher IS NOT NULL
GROUP BY Publisher
ORDER BY avg_global_sales DESC
LIMIT 10;

--What are the top 5 best-selling games per platform?

SELECT
    Platform,
    Name,
    total_sales
FROM (
    SELECT
        Platform,
        Name,
        ROUND(SUM(Global_Sales), 2) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY Platform
            ORDER BY SUM(Global_Sales) DESC
        ) AS rn
    FROM vgsales_clean
    GROUP BY Platform, Name
) ranked
WHERE rn <= 5
ORDER BY Platform, total_sales DESC;





