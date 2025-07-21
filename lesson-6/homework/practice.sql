-- Puzzle 1: Finding Distinct Values (2 Ways)

-- Method 1: Use GROUP BY on least/greatest logic to treat (a,b) and (b,a) as same
SELECT 
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl
GROUP BY 
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END;

-- Method 2: Use DISTINCT with same logic (simpler alternative)
SELECT DISTINCT
    CASE WHEN col1 < col2 THEN col1 ELSE col2 END AS col1,
    CASE WHEN col1 < col2 THEN col2 ELSE col1 END AS col2
FROM InputTbl;



-- Puzzle 2: Removing Rows with All Zeroes
-- Select only rows where at least one column is not 0
SELECT *
FROM TestMultipleZero
WHERE 
    ISNULL(A, 0) <> 0 OR 
    ISNULL(B, 0) <> 0 OR 
    ISNULL(C, 0) <> 0 OR 
    ISNULL(D, 0) <> 0;



-- Puzzle 3: Find those with odd ids
SELECT *
FROM section1
WHERE id % 2 = 1;



-- Puzzle 4: Person with the smallest id
SELECT TOP 1 *
FROM section1
ORDER BY id ASC;



-- Puzzle 5: Person with the highest id
SELECT TOP 1 *
FROM section1
ORDER BY id DESC;



-- Puzzle 6: People whose name starts with 'b' (case-insensitive)
SELECT *
FROM section1
WHERE name LIKE 'b%';



-- Puzzle 7: Return rows where code contains a literal underscore '_'
-- ESCAPE is used to treat underscore as a literal, not wildcard
SELECT *
FROM ProductCodes
WHERE Code LIKE '%\_%' ESCAPE '\';
