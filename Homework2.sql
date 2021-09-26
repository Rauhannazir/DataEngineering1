#Exercise 1#
create table employee
(id INTEGER NOT NULL,
employee_name VARCHAR(255) NOT NULL, primary key(id)); 

# Exercise 2
Answer = Tennessee#
SELECT state FROM birdstrikes LIMIT 144,1;

#Exercise 3
Answer = 2000-04-18#
SELECT flight_date FROM birdstrikes ORDER BY flight_date DESC LIMIT 1;

#Exercise 4
Answer = 5345#
SELECT DISTINCT cost FROM birdstrikes ORDER BY cost DESC LIMIT 49,1;

#Exercise 5
SELECT * FROM birdstrikes WHERE state <>'' AND bird_size <>'';

#Exercise 6
Answer = 7939#
SELECT datediff(NOW(), FLIGHT_DATE) FROM birdstrikes WHERE state = 'Colorado' AND weekofyear(flight_date) = 52;

