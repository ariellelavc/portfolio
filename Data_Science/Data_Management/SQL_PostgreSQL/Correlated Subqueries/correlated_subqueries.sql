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

-- Correlated subquery to find patients who are 'in' hospital 
SELECT patient_id
FROM patients p1
WHERE status_time = (
	SELECT MAX(status_time)
	FROM patients p2
	WHERE p1.patient_id = p2.patient_id
	)
AND status='in';

/*
-- Output

patient_id	
-----------
2		
3		
4			
/*