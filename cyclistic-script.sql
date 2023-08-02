CREATE TABLE year_data AS 
SELECT july22.* FROM  "202207_divvy_tripdata" july22 UNION ALL
SELECT aug22.* FROM  "202208_divvy_tripdata" aug22 UNION ALL
SELECT sep22.* FROM  "202209_divvy_publictripdata" sep22 UNION ALL
SELECT oct22.* FROM  "202210_divvy_tripdata" oct22 UNION ALL
SELECT nov22.* FROM  "202211_divvy_tripdata" nov22 UNION ALL
SELECT dec22.* FROM  "202212_divvy_tripdata" dec22 UNION ALL
SELECT jan23.* FROM  "202301_divvy_tripdata" jan23 UNION ALL
SELECT feb23.* FROM  "202302_divvy_tripdata" feb23 UNION ALL
SELECT mar23.* FROM  "202303_divvy_tripdata" mar23 UNION ALL
SELECT apr23.* FROM  "202304_divvy_tripdata" apr23 UNION ALL
SELECT may23.* FROM  "202305_divvy_tripdata" may23 


select * from year_data yd 


-- Peak months for casual riders
SELECT
	SUBSTR( yd.started_at, 4,2) as month,
	COUNT(yd.ride_id) as number_of_ride
FROM 
	year_data yd
WHERE 
	yd.member_casual = 'casual'
GROUP by
	SUBSTR( yd.started_at, 4,2)
ORDER BY 
	number_of_ride DESC


-- Average ride length for each rider type
SELECT 
	yd.member_casual as 'type',
	time(
          CAST(AVG(strftime('%s', yd.ride_length) * 1000 + SUBSTR(yd.ride_length, -3)) / 1000 AS INTEGER), 
         'unixepoch'
       )  as avg_ride_length
FROM 
	year_data yd 
GROUP BY
	yd.member_casual 
/*CONCLUSION: 
 * 			Casual riders take longer rides than members. casual riders have greater average ride_length than the ones with the membership.  
 * */	
	
	
-- Total rides for each weekday grouped by rider type
SELECT 
	yd.member_casual,
	yd.day_of_week as weekday,
	COUNT(yd.ride_id) as number_of_rides
FROM 
	year_data yd 
GROUP BY
	yd.member_casual, weekday
ORDER BY
	yd.member_casual, number_of_rides DESC
/*CONCLUSION: 
 * 			Saturday is the busiest for casual riders. Wednesday for members. Weekend for casual and Week for members
 * */
	
	
--  Busiest days and the respective ride_lengths at these days.
SELECT 
	yd.member_casual as 'type',
	yd.day_of_week as weekday,
	COUNT(yd.ride_id) as number_of_rides,
	time(
          CAST(AVG(strftime('%s', yd.ride_length) * 1000 + SUBSTR(yd.ride_length, -3)) / 1000 AS INTEGER), 
         'unixepoch'
       )  as avg_ride_length
FROM 
	year_data yd 
GROUP BY
	yd.member_casual,  weekday
ORDER BY
	yd.member_casual, number_of_rides DESC
/*CONCLUSION: 
 * 			 Yes, Saturday is the busiest for casual riders and the rides are also the longest on this day, on average.
 * */


-- Top 3 start stations
SELECT 
	yd.member_casual as 'type',
	yd.start_station_name as start_station,
	COUNT(yd.ride_id) as number_of_rides
FROM 
	year_data yd 
WHERE 
	yd.start_station_name != ''
GROUP BY
	yd.member_casual,  start_station
ORDER BY
	yd.member_casual, number_of_rides DESC
LIMIT 
	3
	
-- Top 3 end stations
SELECT 
	yd.member_casual as 'type',
	yd.end_station_name as end_station,
	COUNT(yd.ride_id) as number_of_rides
FROM 
	year_data yd 
WHERE 
	end_station != ''
GROUP BY
	yd.member_casual,  end_station
ORDER BY
	yd.member_casual, number_of_rides DESC
LIMIT 
	3
	

-- Bikes mostly used by the riders
SELECT
	yd.member_casual,
	yd.rideable_type,
	COUNT(yd.ride_id) as number_of_ride
FROM 
	year_data yd
GROUP by
	yd.member_casual, yd.rideable_type
ORDER BY 
	number_of_ride DESC
	
	
-- Max of ride length for each rider type
SELECT 
	yd.member_casual as 'type',
	max(time(trim(yd.ride_length)))   as max_ride_length
FROM 
	year_data yd 
GROUP BY
	yd.member_casual 
	

-- Min of ride length for each rider type
SELECT 
	min(time(trim(yd.ride_length)))   as max_ride_length
FROM 
	year_data yd
GROUP BY
	yd.member_casual