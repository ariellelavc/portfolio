CREATE TABLE patients (
patient_id integer NOT NULL,
status character varying(10) NOT NULL,
status_time timestamp NOT NULL
);

INSERT INTO patients
VALUES (1, 'in', '2024-10-10 09:00:00'),
           (1, 'out', '2024-10-10 10:00:00'),
	   (2, 'in', '2024-10-10 09:00:00'),
	   (2, 'out', '2024-10-10 10:00:00'),
	   (2, 'in', '2024-10-10 12:00:00'),
	   (3, 'out', '2024-10-10 10:30:00'),
	   (3, 'in', '2024-10-11 09:30:00'),
	   (3, 'out', '2024-10-11 11:00:00'),
	   (3, 'in', '2024-10-11 12:00:00'),
	   (4, 'in', '2024-10-11 10:00:00'),
	   (5, 'out', '2024-10-11 11:30:00')
Returning *;

-- Common Table Expression making use of MAX OVER window function to find patients who are 'in' hospital 
WITH in_patients AS (
	SELECT patient_id, status,
	MAX(status_time) OVER (PARTITION BY patient_id, status) as in_time,
	MAX(status_time) OVER (PARTITION BY patient_id) as last_time
	FROM patients
)
SELECT DISTINCT patient_id
FROM in_patients 
WHERE status = 'in' 
AND in_time = last_time;

/*
-- Output

patient_id	
-----------
2		
3		
4			
/*