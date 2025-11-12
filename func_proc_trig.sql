-- Set the statement delimiter to '$$' to define routines containing ';'
DELIMITER $$

-- ==========================================================
-- STORED FUNCTIONS
-- ==========================================================

-- Function to get the total papers written by a specific author
CREATE FUNCTION GetAuthorPaperCount (p_Author_ID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE paper_count INT;
    SELECT COUNT(*) INTO paper_count
    FROM Paper_Author
    WHERE Author_ID = p_Author_ID;
    RETURN paper_count;
END$$

-- Function to get the average review rating for a specific paper
CREATE FUNCTION GetAverageReviewRating (p_Paper_ID INT)
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE avg_rating DECIMAL(5, 2);
    SELECT AVG(Rating) INTO avg_rating
    FROM Paper_Reviewer
    WHERE Paper_ID = p_Paper_ID;
    RETURN COALESCE(avg_rating, 0.00);
END$$

-- ==========================================================
-- STORED PROCEDURES
-- ==========================================================

-- Procedure to insert a new research paper published in a Journal
CREATE PROCEDURE InsertJournalPaper (
    IN p_Paper_ID INT,
    IN p_Title VARCHAR(255),
    IN p_Abstract TEXT,
    IN p_Year INT,
    IN p_DOI VARCHAR(100),
    IN p_Journal_ID INT
)
BEGIN
    INSERT INTO Research_Paper (Paper_ID, Title, Abstract, Year, DOI, Journal_ID, Conference_ID)
    VALUES (p_Paper_ID, p_Title, p_Abstract, p_Year, p_DOI, p_Journal_ID, NULL);
END$$

-- Procedure to assign a reviewer to a paper
CREATE PROCEDURE AssignReviewer (
    IN p_Paper_ID INT,
    IN p_Reviewer_ID INT,
    IN p_Review_Date DATE
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Research_Paper WHERE Paper_ID = p_Paper_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Paper ID does not exist.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Reviewer WHERE Reviewer_ID = p_Reviewer_ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Reviewer ID does not exist.';
    END IF;

    INSERT INTO Paper_Reviewer (Paper_ID, Reviewer_ID, Review_Date, Rating)
    VALUES (p_Paper_ID, p_Reviewer_ID, p_Review_Date, NULL);
END$$

-- ==========================================================
-- TRIGGERS
-- ==========================================================

-- Trigger to increment Department Faculty_count after a new Author is added
CREATE TRIGGER trg_Author_AfterInsert
AFTER INSERT ON Author
FOR EACH ROW
BEGIN
    UPDATE Department
    SET Faculty_count = Faculty_count + 1
    WHERE Dept_ID = NEW.Dept_ID;
END$$

-- Trigger to decrement Department Faculty_count after an Author is deleted
CREATE TRIGGER trg_Author_AfterDelete
AFTER DELETE ON Author
FOR EACH ROW
BEGIN
    UPDATE Department
    SET Faculty_count = Faculty_count - 1
    WHERE Dept_ID = OLD.Dept_ID;
END$$

-- Trigger to validate Impact_factor range before inserting or updating a Journal
CREATE TRIGGER trg_Journal_BeforeInsertUpdate
BEFORE INSERT ON Journal
FOR EACH ROW
BEGIN
    IF NEW.Impact_factor < 0 OR NEW.Impact_factor > 50.000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Journal Impact factor must be between 0.000 and 50.000.';
    END IF;
END$$

-- Reset the statement delimiter back to the default ';'
DELIMITER ;