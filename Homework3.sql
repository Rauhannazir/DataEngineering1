-- Exercise 1 
SELECT aircraft, airline, speed, 
IF(speed < 100 OR speed IS NULL, 'LOW SPEED', 'HIGH SPEED') AS speed_category
FROM  birdstrikes
ORDER BY speed_category;

-- Exercise 2 Answer = 3
SELECT COUNT(DISTINCT(aircraft)) FROM birdstrikes;

-- Exercise 3 Answer = 9
SELECT MIN(speed) FROM birdstrikes WHERE aircraft LIKE 'H%';

-- Exercise 4 Answer = Taxi (2)
SELECT COUNT(id) AS number_of_incidents, phase_of_flight FROM birdstrikes GROUP BY phase_of_flight ORDER BY number_of_incidents LIMIT 1;

-- Exercise 5 Answer = 54673 (Climb)
SELECT round(avg(cost)) AS Avg_rcost, phase_of_flight FROM birdstrikes GROUP BY phase_of_flight ORDER BY Avg_rcost DESC LIMIT 1;

-- Exercise 6 Answer = 2862.5000 (Iowa)
SELECT avg(speed) AS Avg_speed, state FROM birdstrikes WHERE char_length(state) < 5 GROUP BY state ORDER BY Avg_speed DESC LIMIT 1;