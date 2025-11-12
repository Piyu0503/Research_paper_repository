-- Testing InsertJournalPaper procedure --
CALL InsertJournalPaper(
    603,
    'Quantum Field Teleportation',
    'New findings in QFT...',
    2025,
    '10.1007/physics.603',
    401  -- Journal_ID for Journal of Machine Learning
);
SELECT Paper_ID, Title, Journal_ID, Conference_ID
FROM Research_Paper
WHERE Paper_ID = 603;

-- Testing AssignReviewer procedure --
CALL AssignReviewer(603, 501, '2025-01-10');

SELECT Paper_ID, Reviewer_ID, Review_Date, Rating
FROM Paper_Reviewer
WHERE Paper_ID = 603 AND Reviewer_ID = 501;