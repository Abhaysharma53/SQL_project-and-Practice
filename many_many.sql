#starting with many to many relationship
CREATE DATABASE review_app;
USE review_app;
CREATE TABLE Reviewers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

CREATE TABLE Series (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    released_year YEAR(4) NOT NULL,
    genre ENUM('Drama', 'Comedy', 'Animation') NOT NULL
);

CREATE TABLE Reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rating DECIMAL(3 , 2 ) NOT NULL,
    series_id INT,
    reviewer_id INT,
    FOREIGN KEY (series_id)
        REFERENCES Series (id),
    FOREIGN KEY (reviewer_id)
        REFERENCES Reviewers (id)
);
DESC Reviews;
INSERT INTO series (title, released_year, genre) VALUES
    ('Archer', 2009, 'Animation'),
    ('Arrested Development', 2003, 'Comedy'),
    ("Bob's Burgers", 2011, 'Animation'),
    ('Bojack Horseman', 2014, 'Animation'),
    ("Breaking Bad", 2008, 'Drama'),
    ('Curb Your Enthusiasm', 2000, 'Comedy'),
    ("Fargo", 2014, 'Drama'),
    ('Freaks and Geeks', 1999, 'Comedy'),
    ('General Hospital', 1963, 'Drama'),
    ('Halt and Catch Fire', 2014, 'Drama'),
    ('Malcolm In The Middle', 2000, 'Comedy'),
    ('Pushing Daisies', 2007, 'Comedy'),
    ('Seinfeld', 1989, 'Comedy'),
    ('Stranger Things', 2016, 'Drama');
SELECT * FROM series;

INSERT INTO reviewers (first_name, last_name) VALUES
    ('Thomas', 'Stoneman'),
    ('Wyatt', 'Skaggs'),
    ('Kimbra', 'Masters'),
    ('Domingo', 'Cortes'),
    ('Colt', 'Steele'),
    ('Pinkie', 'Petit'),
    ('Marlon', 'Crafford');
SELECT * FROM reviewers;

INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
    (1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
    (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
    (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
    (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
    (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
    (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
    (7,2,9.1),(7,5,9.7),
    (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
    (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
    (10,5,9.9),
    (13,3,8.0),(13,4,7.2),
    (14,2,8.5),(14,3,8.9),(14,4,8.9);
    
SELECT * FROM reviews;
SHOW DATABASES;
USE review_app;
#question1
SELECT 
    title, rating
FROM
    series
        INNER JOIN
    reviews ON series.id = reviews.series_id
ORDER BY title;
    
#question2- with group by
SELECT 
    title, AVG(rating) AS avg_rating
FROM
    series
        INNER JOIN
    reviews ON series.id = reviews.series_id
GROUP BY title
ORDER BY AVG(rating);
SELECT * FROM reviews;
#question- 3 reviewers table inner join
SELECT 
    first_name, last_name, rating
FROM
    reviewers
        INNER JOIN
    reviews ON reviewers.id = reviews.reviewer_id;
    
#question -4 unreviewed series
SELECT 
    title, rating
FROM
    series
        LEFT JOIN
    reviews ON series.id = reviews.series_id
WHERE
    rating IS NULL;
    
#question-5
SELECT * FROM series;
SELECT 
    genre, AVG(rating) AS avg_rating
FROM
    series
        INNER JOIN
    reviews ON series.id = reviews.series_id
GROUP BY genre;

#question-6 reviewers stats
SELECT 
    first_name,
    last_name,
    COUNT(reviews.id) AS 'count',
    IFNULL(MIN(reviews.rating), 0) AS 'MIN',
    IFNULL(MAX(reviews.rating), 0) AS 'MAX',
    IFNULL(AVG(rating), 0) AS 'AVG',
    CASE
        WHEN AVG(rating) IS NULL THEN 'INACTIVE'
        ELSE 'ACTIVE'
    END AS STATUS
FROM
    reviewers
        LEFT JOIN
    reviews ON reviewers.id = reviews.reviewer_id
GROUP BY reviewers.id;
DESC reviews;
#we can even use if statment to get the same as case ---- if(condition, true, false)
SELECT 
    first_name,
    last_name,
    COUNT(reviews.id) AS 'count',
    IFNULL(MIN(reviews.rating), 0) AS 'MIN',
    IFNULL(MAX(reviews.rating), 0) AS 'MAX',
    ROUND(IFNULL(AVG(rating), 0),2) AS 'AVG',
IF(COUNT(rating) > 0, "Active", "Inactive") AS Status
FROM
    reviewers
        LEFT JOIN
    reviews ON reviewers.id = reviews.reviewer_id
GROUP BY reviewers.id;
DESC reviews;

#--- lets say if we want one more condition that he is an active user if count of reviews >= 10
SELECT 
    first_name,
    last_name,
    COUNT(rating) AS 'COUNT',
    IFNULL(MIN(rating), 0) AS 'MIN',
    IFNULL(MAX(rating), 0) AS 'MAX',
    ROUND(IFNULL(AVG(rating), 0), 2) AS 'AVG',
    CASE
        WHEN COUNT(rating) >= 10 THEN 'POWER USER'
        WHEN COUNT(rating) >= 1 THEN 'ACTIVE USER'
        ELSE 'INACTIVE USER'
    END AS Status
FROM
    reviewers
        LEFT JOIN
    reviews ON reviewers.id = reviews.reviewer_id
GROUP BY reviewers.id;

#mutiple joins- ---- now we want to join reviewers-series-reviews table togethor in a single query 
SELECT 
    title, rating, CONCAT(first_name, " ", last_name) AS reviewer
FROM
    reviewers
        INNER JOIN
    reviews ON reviewers.id = reviews.reviewer_id
        INNER JOIN
    series ON series.id = reviews.series_id
    ORDER BY series.title;