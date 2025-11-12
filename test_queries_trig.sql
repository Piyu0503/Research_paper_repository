-- Check initial state --
SELECT Dept_ID, Dept_Name, Faculty_count
FROM Department
WHERE Dept_ID = 101;

-- Test Insert Trigger -- 
INSERT INTO Author (Author_ID, Name, Email, Dept_ID) 
VALUES (204, 'Dr. New Faculty', 'new.f@uni.edu', 101);

SELECT Faculty_count FROM Department WHERE Dept_ID = 101;

-- Test Delete Trigger -- 
DELETE FROM Author WHERE Author_ID = 204;
SELECT Faculty_count FROM Department WHERE Dept_ID = 101;

-- Test impact factor trigger --
-- This should succeed as 10.0 is within the 0 to 50 range.
INSERT INTO Journal (Journal_ID, Journal_Name, Impact_factor) 
VALUES (403, 'Journal of Safe Tech', 10.000);

-- This should fail as 55.0 is outside the allowed range.
INSERT INTO Journal (Journal_ID, Journal_Name, Impact_factor) 
VALUES (404, 'Journal of Bad Tech', 55.000); 
