CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(50),
    city VARCHAR(50)
);


CREATE TABLE subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT,
    start_date DATE,
    end_date DATE,
    plan VARCHAR(20), -- Basic / Standard / Premium
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50),
    release_year INT
);


CREATE TABLE watch_history (
    watch_id SERIAL PRIMARY KEY,
    user_id INT,
    movie_id INT,
    watch_date DATE,
    duration INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    user_id INT,
    movie_id INT,
    rating INT, -- 1 to 5
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);




INSERT INTO users(user_name, city) VALUES
('Ali Khan','Karachi'),
('Sara Ahmed','Lahore'),
('Usman Tariq','Islamabad'),
('Ayesha Noor','Karachi');


INSERT INTO subscriptions(user_id, start_date, end_date, plan) VALUES
(1,'2024-01-01','2024-12-31','Premium'),
(2,'2024-02-01','2024-08-31','Standard'),
(3,'2024-03-01','2024-09-30','Basic'),
(4,'2024-01-15','2024-12-31','Premium');


INSERT INTO movies(title, genre, release_year) VALUES
('The Matrix','Sci-Fi',1999),
('Inception','Sci-Fi',2010),
('The Godfather','Crime',1972),
('Parasite','Thriller',2019);


INSERT INTO watch_history(user_id, movie_id, watch_date, duration) VALUES
(1,1,'2024-01-05',120),
(1,2,'2024-02-10',150),
(2,3,'2024-02-15',175),
(3,4,'2024-03-05',130),
(4,1,'2024-01-20',120),
(4,2,'2024-02-25',150);


INSERT INTO ratings(user_id, movie_id, rating) VALUES
(1,1,5),
(1,2,4),
(2,3,5),
(3,4,4),
(4,1,5),
(4,2,4);


-- TASK 6:
-- Active subscriptions count per plan

SELECT plan,
COUNT(*) AS total_users
FROM subscriptions
WHERE start_date <= CURRENT_DATE AND end_date >=CURRENT_DATE
GROUP BY plan;

-- TASK 7:
-- Users who watched Sci-Fi movies

SELECT DISTINCT u.user_name,m.genre
FROM users u
JOIN watch_history wh
ON u.user_id = wh.user_id
JOIN movies m
ON m.movie_id = wh.movie_id
WHERE m.genre = 'Sci-Fi';


-- TASK 8:
-- Total watch time genre

SELECT m.genre, SUM(wh.duration) AS total_watch_time
FROM watch_history wh
JOIN movies m
ON m.movie_id = wh.movie_id
GROUP BY m.genre
ORDER BY total_watch_time DESC;


-- TASK 9:
-- User watch streak(CTE)

WITH watch_cte AS(
     SELECT user_id,watch_date,
	 ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY watch_date)-
	 ROW_NUMBER() OVER(PARTITION BY user_id,watch_date
	 ORDER BY watch_date) AS streak
	 FROM watch_history
)
SELECT user_id, COUNT(*) AS streak_length
FROM watch_cte
GROUP BY user_id;


-- TASK 10:
-- Top 2 users by total watch time(ROW_NUMBER)

WITH user_watch AS (
    SELECT u.user_id, u.user_name, SUM(wh.duration) AS total_watch_time
    FROM users u
    JOIN watch_history wh 
	ON u.user_id = wh.user_id
    GROUP BY u.user_id, u.user_name
)
SELECT *, ROW_NUMBER() OVER(ORDER BY total_watch_time DESC) AS rank
FROM user_watch;