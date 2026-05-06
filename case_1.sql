-- ============================================
-- CASE 1: User Behavior Analytics
-- Platform: MySQL | DB: miniproject1
-- ============================================


-- Task 1.1: Unique users in date range 2023-11-07 to 2023-11-15
-- Filters by date range, counts distinct users

SELECT COUNT(DISTINCT user_id) AS unique_users
FROM users
WHERE `date` BETWEEN '2023-11-07' AND '2023-11-15';


-- Task 1.2: User with highest total ad views (all time)
-- Aggregates views per user, returns top 1

SELECT user_id, SUM(view_adverts) AS total_ads_viewed
FROM users
GROUP BY user_id
ORDER BY total_ads_viewed DESC
LIMIT 1;


-- Task 1.3: Day with highest avg ads/user (DAU filter > 500)
-- Business use: find peak ad engagement day for planning
-- HAVING filters out low-traffic days before ranking

SELECT `date`,
       CAST(SUM(view_adverts) AS DECIMAL(10,2)) / COUNT(DISTINCT user_id) AS avg_ads_per_user
FROM users
GROUP BY `date`
HAVING COUNT(DISTINCT user_id) > 500
ORDER BY avg_ads_per_user DESC
LIMIT 1;


-- Task 1.4: User Lifetime (LT) = last_date - first_date per user
-- Metric shows how long each user stays active on the platform

SELECT user_id,
       DATEDIFF(MAX(`date`), MIN(`date`)) AS LT
FROM users
GROUP BY user_id
ORDER BY LT DESC;


-- Task 1.5: Power user by avg daily ad views (min 5 active days)
-- Subquery aggregates daily views per user per day
-- Outer query filters users with 5+ active days, ranks by avg

SELECT user_id,
       AVG(daily_views) AS avg_ads_per_day
FROM (
    SELECT user_id, `date`, SUM(view_adverts) AS daily_views
    FROM users
    GROUP BY user_id, `date`
) t
GROUP BY user_id
HAVING COUNT(*) >= 5
ORDER BY avg_ads_per_day DESC
LIMIT 1;