-- Data Exploration: How Can A Wellness Company Play It Smart?
-- FITABASE DATA EXPLORATION 

-- Began exploration process by creating a table with corrected data types in order to utilize aggregation 
-- First query was utilized for dropping data to avoid duplicating data in the table just in case I re-ran query
/* IF EXISTS SELECT 
	* 
FROM
	PortfolioProject.daily_activity_cleaned 
DROP TABLE 
	PortfolioProject.daily_activity_cleaned */
    
CREATE TABLE PortfolioProject.daily_activity_cleaned
(
    Id FLOAT,
    ActivityDate DATETIME(7),
    TotalSteps INT,
    TotalDistance FLOAT,
    VeryActiveDistance FLOAT,
    ModeratelyActiveDistance FLOAT,
    LightActiveDistance FLOAT,
    SedentaryActiveDistance FLOAT,
    VeryActiveMinutes INT,
    FairlyActiveMinutes INT,
    LightlyActiveMinutes INT,
    SedentaryMinutes INT,
    Calories FLOAT
);
INSERT INTO PortfolioProject.daily_activity_cleaned
(
	Id, 
	ActivityDate,
	TotalSteps,
    TotalDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
)
SELECT
	Id, 
	ActivityDate,
	TotalSteps,
    CAST(TotalDistance AS FLOAT) AS TotalDistance,
    CAST(VeryActiveDistance AS FLOAT) AS VeryActiveDistance,
    CAST(ModeratelyActiveDistance AS FLOAT) AS ModeratelyActiveDistance,
    CAST(LightActiveDistance AS FLOAT) AS LightActiveDIstance,
    CAST(SedentaryActiveDistance AS FLOAT) AS SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
FROM
	PorjectPortfolio.daily_activity;
    

-- Query utilized to calculate the number of users and daily averages to track their physical activities
SELECT 
	COUNT(DISTINCT Id) AS users_tracking_activity,
    AVG(TotalSteps) AS average_steps,
    AVG(TotalDistance) AS average_distance,
    AVG(Calories) AS average_calores
FROM
	PortfolioProject.daily_activity;


-- Query utilized to track heart rates
SELECT 
	COUNT(DISTINCT Id) AS users_tracking_activity,
    AVG(Value) AS average_heartRate,
    MIN(Value) AS minimum_heartRate,
    MAX(Value) AS maximum_heartRate
FROM
	PortfolioProject.heartrate_seconds;
    
    
-- Query utilized to track sleep
SELECT 
	COUNT(DISTINCT Id) AS users_tracking_sleep,
    AVG(TotalMinutesAsleep)/60.0 AS average_hours_asleep,
    MIN(TotalMinutesAsleep)/60.0 AS minimun_hours_asleep,
    MAX(TotalMinutesAsleep)/60.0 AS maximum_hours_asleep,
    AVG(TotalTimeInBed)/60.0 AS average_hours_inBed
FROM
	PortfolioProject.heartrate_seconds;
    
    
-- Query utilized to track weight 
SELECT 
	COUNT(DISTINCT Id) AS users_tracking_weight,
    AVG(WeightKg) AS average_weight,
    MIN(WeightKg) AS minimum_weight,
    MAX(WeightKg) AS maximum_weight
FROM
	PortfolioProject.weight_log_info;
    
    
-- Query utilized to calculate the number of days each user tracked their physical acitivty
SELECT
	DISTINCT Id,
    COUNT(ActivityDate)OVER (PARTITION BY ID) AS days_activity_recorded
FROM 
	PortfolioProject.daily_activty_cleaned
ORDER BY
	days_activity_recorded DESC;
    
    
-- Query utilized to calculate average minutes for each activity type
SELECT 
	ROUND(AVG(VeryActiveMinutes),2) AS AverageVeryActiveMinutes,
    ROUND(AVG(FairlyActiveMinutes),2) AS AverageFairlyActiveMinutes,
    ROUND(AVG(LightlyActiveMinutes)/60.0,2) AS AverageLightlyActiveMinutes,
    ROUND(AVG(SedentaryMinutes)/60.0,2) AS AverageSedentaryMinutes
FROM
	PortfolioProject.daily_activty_cleaned;
    
    
-- Query utilized to determine the time where users were most active 
-- High intensity or high METs implies more people are physically active during that time 
SELECT
	DISTINCT(CAST(ActivityHour AS TIME) AS activity_time,
    AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR, ActivityHour) AS average_intensity,
    AVG(METs/10.0) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_METs
FROM
	PorjectPortfolio.hourly_activity AS hourly_activity
JOIN
	ProjectPortfolio.minute_mets_narrow AS METs
    ON 
    hourly_activity.Id = METs.Id 
    AND
    hourly_activity.ActivityHour = METs.ActivityMinute
ORDER BY
	average_intensity DESC;

