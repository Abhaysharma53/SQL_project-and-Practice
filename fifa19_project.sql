#lets implement our project of FIFA19... for this we have to make a db first
CREATE DATABASE fifa19;
SHOW DATABASES;
USE fifa19;
#lets just create a table to store players details
CREATE TABLE Players (
    ID INT,
    Player VARCHAR(255),
    Age INT,
    Nationality VARCHAR(255),
    Overallrating INT,
    Potentialrating INT,
    Club VARCHAR(255),
    Value INT,
    Wage INT,
    Preferredfoot ENUM('Left', 'Right'),
    Jerseynumber INT,
    Joined DATETIME,
    Height VARCHAR(255),
    Weight INT,
    Penalities INT
);
#DROP Table Players;
SHOW TABLES;
DESC players;
#lets fill the data into this table from FIFA.CSV
LOAD DATA LOCAL INFILE "C:/Users/USER/Desktop/Abhay/sql/SQL_project/fifa19.csv" INTO TABLE players CHARACTER SET latin1 COLUMNS TERMINATED BY ","
OPTIONALLY ENCLOSED BY "'" IGNORE 1 LINES;
# lets just check few rows of it
SELECT * FROM players LIMIT 5;
#lets answer a few questions now
#no of players in the dataset
SELECT COUNT(*) AS total_players FROM players;
#no of nationalities un the dataset
SELECT COUNT(DISTINCT Nationality) FROM Players;
#SUM of wages, avg. of wages and standard deviation
SELECT SUM(Wage), AVG(Wage), STDDEV(Wage) FROM players;
#we can clearly see that there is so much of deviation in Wage of these players and many players either have very low or very high wage
#which nationality have highest no of players , top 3 nations by players and the no of players they have
SELECT Nationality, COUNT(*) AS Freq FROM Players GROUP BY Nationality ORDER BY Freq DESC LIMIT 3;
#Which Players Have highest and lowest package
#since by Max and min we can find the highest and lowest wage but in order to find the name associated with it, we need to either use 2 queries or subqueries
SELECT Player, Wage FROM Players WHERE Wage = (SELECT MAX(Wage) FROM Players);  #SUBQUERY
#Alternatively
SELECT MAX(Wage) FROM players;
SELECT Player, Wage FROM players WHERE WAGE = 565000;
#we can see that l. messi is the highest paid footballer
SELECT Player, Wage FROM Players WHERE Wage = (SELECT MIN(Wage) FROM Players);
#Player Having the best overall rating
SELECT Player, Overallrating FROM Players WHERE Overallrating = (SELECT MAX(Overallrating) FROM Players);
#WE can see messi and ronaldo both have overall best rating i.e. 94
#Best Club on the basis of its rating - Even then this problem can be further classified into 2 Parts
#1 - Best Club can be the one with the highest total rating(Sum of rating of all the players of that club
#2 - Best club can be the one with the highest avg. rating
SELECT Club, SUM(Overallrating) AS total_rating FROM Players GROUP BY Club ORDER BY total_rating DESC Limit 3;
#as per total rating Real madrid, FC Barcelona and Manchester United are the best clubs
#what if we take avg. rating into the consideration
SELECT Club, AVG(Overallrating) AS avg_rating FROM Players GROUP BY Club ORDER BY avg_rating DESC LIMIT 3;
#BY avg. rating Juventus, Napoli and Inter are the best Clubs out there
#so in descriptive Statistics, the way we define our problem can also change the result we have
#top 5 clubs by avg. rating and their corresponding rating
SELECT Club, AVG(Overallrating) AS avg_rating FROM players GROUP BY Club ORDER BY avg_rating DESC LIMIT 5;
#distribution of players whose preferred foot is left or right
SELECT * FROM players LIMIT 5;
SELECT Preferredfoot, COUNT(*) AS Frequency FROM Players GROUP BY Preferredfoot;
#we can see most of the players preferred foot is right - 12823
#Which jersey number is luckiest - since its a subjective question. we may define the luckiest jersey like the players who wear that 
#no of jersey have highest average wage or highest total wage or have highest rating or even highest perceived market value.
#so its kind of a subjective question to answer but seeing it from the perspective of data science, we can't say its subjective , we have to come up with some quantifiable numbers
#so the best approach can be to make certain assumption about the data and trying to solve the problem according to it, and whille making those assumptions the stakeholders should be aware of it, so that all will be on the same page.
#so lets make an assumption player with highest wage = luckiest jersey number
SELECT Jerseynumber, SUM(Wage) as total_wage FROM Players GROUP BY Jerseynumber ORDER BY total_wage DESC LIMIT 1;
#so according to that jersey number 10 is luckiest = total_wage = 9975000
#frequency distribution of nations among players whose club name starts with "M"
SELECT Nationality, COUNT(*) AS no_of_players FROM Players WHERE Club LIKE "M%" GROUP BY Nationality;
#how many players have joined their respective clubs in data range 20 may 2018 to 10 April 2019
SELECT COUNT(*) FROM players WHERE DATE(Joined) >= "2018-05-20" AND DATE(Joined) <= "2019-04-10";#will try again
#alternatively
SELECT COUNT(*) FROM players WHERE JOINED BETWEEN "2018-05-20" AND "2019-04-10";
#distribution of players joined date to their respective clubs Datewise and Yearwise
SELECT DATE(JOINED), COUNT(*) AS Frequency FROM Players GROUP BY DATE(Joined) ORDER BY DATE(JOINED);
#if ill see it yearwise
SELECT YEAR(Joined), COUNT(*) AS Frequency FROM Players GROUP BY YEAR(JOINED) ORDER BY YEAR(Joined);



