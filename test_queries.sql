-- Content of Organizational Tables
SELECT * FROM Department;
SELECT * FROM Author;
SELECT * FROM Reviewer;

-- Content of Venue Tables
SELECT * FROM Conference;
SELECT * FROM Journal;

-- Content of Central Entity Table
SELECT * FROM Research_Paper;

-- Content of Junction (M:N) Tables
SELECT * FROM Paper_Author;
SELECT * FROM Paper_Reviewer;