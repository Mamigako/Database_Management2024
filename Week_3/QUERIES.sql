-- HW1
-- Student names:
--Maximilian Klimko
--Daniel Zaher El Deen

-- A. How much does the most expensive equipment cost? Return only the price.
-- Explanation: We select the price from equipment and use the max fucntion to output the highest value.

SELECT max(price)
FROM equipment;

-- B. 792 members have started the gym in April (of any year). How many members have started the gym in January (of any year)?
-- Explanation: We get the count of all start dates including 1(January) from the member table. 

SELECT count(*)
FROM member
WHERE EXTRACT(MONTH FROM start_date) = 1; 

-- C. 154 classes were held with ‘burn’ somewhere in their type name. How many classes were held that 
-- have ‘fit’ somewhere in their type name? (Note that your query should be case-insensitive, 
-- i.e. classes with ‘fiT’ and ‘Fit’ in their type name should also be counted).
-- Explanation: We join type and class on the type id and get the count of classes woth "fit" in the name (case insensitive due to ILIKE)

SELECT count(*)
FROM class C
JOIN type T on C.tid = T.id
WHERE name ILIKE '%fit%';

-- D. How many different instructors have led at least one class in which a member that they have in personal training attended?
-- Explanation: We get the count of unique instructors from the member table  and we join it with attends and class on their respective ids, filtering by the instructor id.


SELECT count(DISTINCT M.iid)
FROM attends A
JOIN member M ON A.mid = M.id
JOIN class C ON C.id = A.cid
WHERE C.iid = M.iid;


-- E. Return the name of every class type along with the average rating that all classes of the type have received. 
-- The result should be rounded to the nearest integer and ordered from highest to lowest. 
-- Name the column with the average rating “Average Rating”.
-- Explanation: We join type and attends on the class id and use round() and avg() to find the average rating, rounded and DESC to sort descending.

SELECT T.name, round(avg(A.rating)) as "Average Rating"
FROM type T
JOIN attends A ON T.id = A.cid
GROUP BY T.name, A.cid
ORDER BY  "Average Rating" DESC;


-- F. How many members have not attended any classes and do not have a personal instructor?
-- Explanation: We get the count of all members from the member table and use a subquery to to filter those memebers who attend classes as per attends and who do not have an assigned instructor.

SELECT count(*)
FROM member M  
WHERE M.id NOT IN (
    SELECT A.mid
    FROM attends A)
AND M.iid IS NULL;

-- G. 43 instructors have led 15 or more classes. How many instructors have led 10 or more classes?
-- Explanation: We select the count and use a subquery to select the cout of classes, grouped by instructor id, which have a class id of 10 or more. 

SELECT count(*)
FROM (
    SELECT count(C.id)
    FROM class C
    GROUP BY C.iid 
    HAVING count(C.id) >= 10
    );

-- H. For how many members is it true that there exists at least one other member with the same start date and quit date as them? 
-- (Note that if that is true for John and Mary, they should be counted as two results.
-- Note also that two people that have not quit cannot be considered as having the same quit date.).
-- Explanation: We select the count and join member with itself and match the start and quit dates(where there is a quit date) and exclude people being paired up with themselves 
-- by stating the ids should be different.


SELECT count(*)
FROM member M1
JOIN member M2 ON M1.start_date = M2.start_date
AND M1.quit_date = M2.quit_date
WHERE M1.quit_date IS NOT NULL 
ANd M1.id != M2.id;
  

--I. How many classes were held in gyms in Reykjavik and have a capacity of either 30 or 40 people, but the capacity was not used fully?
-- Explanation: We first create a temp table of all classes in Reykjavík with cap. 30 or 40 . We then select the count of lines in a subquery including the temp table, where it is joined with attends on the class id.
-- grouped by class id, class capacity and where the amount of attendees is lower than the capacity.  

WITH RVKgymtable (ClassID, capacity)
AS(
    SELECT C.id, T.capacity
    FROM class C
    JOIN type T ON T.id = C.tid
    WHERE (C.gid = 2 OR C.gid = 4)
    AND (T.capacity = 30 OR T.capacity = 40)
    )

SELECT count(*)
FROM (
    SELECT count(A.mid), A.cid
    FROM RVKgymtable R
    JOIN attends A ON A.cid = R.ClassID
    GROUP BY A.cid, R.capacity 
    HAVING count(A.mid) < R.capacity
    );

-- J. Return the ID and name of the member(s) that attended classes for the longest total time (in minutes) of all members?
-- Explanation: We creat a temp table by joining attends, member and class on their respective ids and grouping by members and ordering by total minutes spent in classes.
-- We then selesct the name, id and total minutes from the temp table and display only the row with the highest total minute value. 

WITH temp_table(name, id, total_minutes)
AS(
    SELECT M.name, A.mid, sum(C.minutes) as total_minutes
    FROM Attends A
    join Member M on A.mid = M.id
    join Class C on C.id = A.cid 
    GROUP BY A.mid, M.name
    ORDER BY total_minutes DESC
)
SELECT name, id, total_minutes
FROM temp_table
where total_minutes = (SELECT max(total_minutes) FROM temp_table);

