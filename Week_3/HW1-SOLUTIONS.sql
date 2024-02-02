-- HW1
-- Student names:
--Maximilian Klimko
--Daniel Zaher El Deen


-- A. How much does the most expensive equipment cost? Return only the price.
-- Explanation: 250.000isk

SELECT max(price)
FROM equipment;


-- B. 792 members have started the gym in April (of any year). How many members have started the gym in January (of any year)?
-- Explanation: 899

SELECT count(*)
FROM member
WHERE EXTRACT(MONTH FROM start_date) = 1; 

-- C. 154 classes were held with ‘burn’ somewhere in their type name. How many classes were held that 
-- have ‘fit’ somewhere in their type name? (Note that your query should be case-insensitive, 
-- i.e. classes with ‘fiT’ and ‘Fit’ in their type name should also be counted).
-- Explanation: 292

SELECT count(*)
FROM class C
JOIN type T on C.tid = T.id
WHERE name ILIKE '%fit%';

-- D. How many different instructors have led at least one class in which a member that they have in personal training attended?
-- Explanation: 52


SELECT count(DISTINCT M.iid)
FROM attends A
JOIN member M ON A.mid = M.id
JOIN class C ON C.id = A.cid
WHERE C.iid = M.iid;


-- E. Return the name of every class type along with the average rating that all classes of the type have received. 
-- The result should be rounded to the nearest integer and ordered from highest to lowest. 
-- Name the column with the average rating “Average Rating”.
-- Explanation: 

SELECT T.name, round(avg(A.rating)) as "Average Rating"
FROM type T
JOIN attends A ON T.id = A.cid
GROUP BY T.name, A.cid
ORDER BY  "Average Rating" DESC


-- F. How many members have not attended any classes and do not have a personal instructor?
-- Explanation: 6086

SELECT count(*)
FROM member M  
WHERE M.id NOT IN (
    SELECT A.mid
    FROM attends A)
AND M.iid IS NULL;


-- G. 43 instructors have led 15 or more classes. How many instructors have led 10 or more classes?
-- Explanation: 66

SELECT count(*)
FROM (
    SELECT count(C.id)
    FROM class C
    GROUP BY C.iid 
    HAVING count(C.id) >= 10
    )

-- H. For how many members is it true that there exists at least one other member with the same start date and quit date as them? 
-- (Note that if that is true for John and Mary, they should be counted as two results.
-- Note also that two people that have not quit cannot be considered as having the same quit date.).
-- Explanation: 8


SELECT count(*)
FROM member M1
JOIN member M2 ON M1.start_date = M2.start_date
AND M1.quit_date = M2.quit_date
WHERE M1.quit_date IS NOT NULL 
ANd M1.id != M2.id
  


--I. How many classes were held in gyms in Reykjavik and have a capacity of either 30 or 40 people, but the capacity was not used fully?
-- Explanation: 



-- J. Return the ID and name of the member(s) that attended classes for the longest total time (in minutes) of all members?
-- Explanation: 

