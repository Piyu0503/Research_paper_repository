-- -----------------------------------------------------------
-- STEP 1: Database Creation and Selection
-- (Syntax is generally compatible with MySQL and SQL Server)
-- (For PostgreSQL, replace 'USE' with a separate connection/command)
-- -----------------------------------------------------------
DROP DATABASE research_paper_repository;
CREATE DATABASE Research_Paper_Repository;

-- Select the newly created database for subsequent commands
USE Research_Paper_Repository;

-- -----------------------------------------------------------
-- STEP 2: Table Creation (Entities and Relationships)
-- -----------------------------------------------------------

-- 1. Department Table
CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL,
    Faculty_count INT
);

-- 2. Author Table (References Department)
CREATE TABLE Author (
    Author_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Affiliation VARCHAR(255),
    Dept_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

-- 3. Conference Table
CREATE TABLE Conference (
    Conference_ID INT PRIMARY KEY,
    Conference_Name VARCHAR(255) NOT NULL,
    Year INT,
    Location VARCHAR(255)
);

-- 4. Journal Table
CREATE TABLE Journal (
    Journal_ID INT PRIMARY KEY,
    Journal_Name VARCHAR(255) NOT NULL,
    Publisher VARCHAR(100),
    Impact_factor DECIMAL(5, 3)
);

-- 5. Reviewer Table
CREATE TABLE Reviewer (
    Reviewer_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Expertise_area VARCHAR(255)
);

-- 6. Research_Paper Table (The main entity, with XOR constraint)
CREATE TABLE Research_Paper (
    Paper_ID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Abstract TEXT,
    Year INT NOT NULL,
    DOI VARCHAR(100) UNIQUE,
    Conference_ID INT,
    Journal_ID INT,
    -- CHECK constraint for XOR: EITHER Conference_ID or Journal_ID must be populated
    CHECK (
        (Conference_ID IS NOT NULL AND Journal_ID IS NULL) OR
        (Conference_ID IS NULL AND Journal_ID IS NOT NULL)
    ),
    FOREIGN KEY (Conference_ID) REFERENCES Conference(Conference_ID),
    FOREIGN KEY (Journal_ID) REFERENCES Journal(Journal_ID)
);

-- 7. Paper_Author Table (for "Written_by" M:N relationship)
CREATE TABLE Paper_Author (
    Paper_ID INT,
    Author_ID INT,
    PRIMARY KEY (Paper_ID, Author_ID),
    FOREIGN KEY (Paper_ID) REFERENCES Research_Paper(Paper_ID),
    FOREIGN KEY (Author_ID) REFERENCES Author(Author_ID)
);

-- 8. Paper_Reviewer Table (for "Reviewed_by" M:N relationship)
CREATE TABLE Paper_Reviewer (
    Paper_ID INT,
    Reviewer_ID INT,
    Review_Date DATE,
    Rating INT,
    PRIMARY KEY (Paper_ID, Reviewer_ID),
    FOREIGN KEY (Paper_ID) REFERENCES Research_Paper(Paper_ID),
    FOREIGN KEY (Reviewer_ID) REFERENCES Reviewer(Reviewer_ID)
);