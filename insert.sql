-- -----------------------------------------------------------
-- DML for Inserting Sample Data
-- (This is executed after the DDL has set up the database and tables)
-- -----------------------------------------------------------

-- 1. Department Data
INSERT INTO Department (Dept_ID, Dept_Name, Faculty_count) VALUES
(101, 'Computer Science', 45),
(102, 'Electrical Engineering', 30),
(103, 'Physics', 25);

-- 2. Author Data
INSERT INTO Author (Author_ID, Name, Email, Affiliation, Dept_ID) VALUES
(201, 'Dr. Alice Smith', 'alice.smith@uni.edu', 'University of Tech', 101),
(202, 'Dr. Bob Johnson', 'bob.j@corp.com', 'Tech Corp R&D', 101),
(203, 'Dr. Carol King', 'carol.k@state.edu', 'State Research Lab', 102);

-- 3. Conference Data
INSERT INTO Conference (Conference_ID, Conference_Name, Year, Location) VALUES
(301, 'Intl Conf on AI', 2024, 'New York'),
(302, 'Global Wireless Summit', 2023, 'London');

-- 4. Journal Data
INSERT INTO Journal (Journal_ID, Journal_Name, Publisher, Impact_factor) VALUES
(401, 'Journal of Machine Learning', 'Springer', 5.512),
(402, 'Advanced Communication', 'Elsevier', 3.105);

-- 5. Reviewer Data
INSERT INTO Reviewer (Reviewer_ID, Name, Email, Expertise_area) VALUES
(501, 'Dr. David Lee', 'david.lee@review.org', 'Deep Learning, NLP'),
(502, 'Dr. Eva Chen', 'eva.chen@review.org', '5G, Signal Processing');

-- 6. Research_Paper Data
INSERT INTO Research_Paper (Paper_ID, Title, Abstract, Year, DOI, Conference_ID, Journal_ID) VALUES
(601, 'A Novel Approach to Contextual Embeddings', 'Abstract for paper 601...', 2024, '10.1007/ai.601', 301, NULL),
(602, 'Optimized MIMO Antenna Design', 'Abstract for paper 602...', 2023, '10.1016/ac.602', NULL, 402);

-- 7. Paper_Author Data (Written_by)
INSERT INTO Paper_Author (Paper_ID, Author_ID) VALUES
(601, 201),
(601, 202),
(602, 203);

-- 8. Paper_Reviewer Data (Reviewed_by)
INSERT INTO Paper_Reviewer (Paper_ID, Reviewer_ID, Review_Date, Rating) VALUES
(601, 501, '2024-03-15', 9),
(602, 502, '2023-08-20', 8);