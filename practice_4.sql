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


-- TASK 1:
-- Total watch time per user

SELECT u.user_name,
SUM(wh.duration) AS total_watch_time
FROM users u
JOIN watch_history wh
ON u.user_id = wh.user_id
GROUP BY u.user_name
ORDER BY total_watch_time DESC;



-- TASK 2:
-- User ranking by watch time(ROW_NUMBER)

SELECT u.user_name,
SUM(wh.duration) AS total_watch_time,
ROW_NUMBER() OVER(ORDER BY SUM(wh.duration)DESC) AS rank
FROM users u
JOIN watch_history wh
ON u.user_id = wh.user_id
GROUP BY u.user_name;


-- TASK 3:
-- Average movie rating per user

SELECT u.user_name,
ROUND(AVG(r.rating),2) AS avg_rating
FROM users u
JOIN ratings r
ON u.user_id = r.user_id
GROUP BY u.user_name
ORDER BY avg_rating DESC;


-- TASK 4:
-- Top rated movie per genre(RANK)

WITH movie_avg AS(
     SELECT m.genre,m.title,
	 ROUND(AVG(r.rating),2) AS avg_rating
	 FROM movies m
	 JOIN ratings r
	 On m.movie_id = r.movie_id
     GROUP BY m.genre,m.title
)
SELECT *,
RANK() OVER(PARTITION BY genre 
ORDER BY avg_rating DESC) AS rank
FROM movie_avg;


-- TASK 5:
-- Most watched movie per user

SELECT user_id,movie_id,watch_date,
LAG(movie_id) OVER(PARTITION BY user_id 
ORDER BY watch_date) AS prev_movie,
LEAD(movie_id) OVER(PARTITION BY user_id 
ORDER BY watch_date) AS next_movie
FROM watch_history;