-- High coverage

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q7;

-- You must not change this table definition.
CREATE TABLE q7 (
	ta varchar(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS all_grader CASCADE;
DROP VIEW IF EXISTS grader_not_1cond CASCADE;
DROP VIEW IF EXISTS grader_1cond CASCADE;
DROP VIEW IF EXISTS total_students CASCADE;
DROP VIEW IF EXISTS grader_2cond CASCADE;


-- Define views for your intermediate steps here.

--pick out usernames of graders
create view all_grader as
select username 
from MarkusUser where type != 'student';

--get the actually existing <grader, assignment> pairs
create view exist_grader_assg as
select distinct username, assignment_id
from AssignmentGroup natural join Grader;

--get all possible grader and assignment pairs
create view all_p_grader_assg as
select distinct username, assignment_id
from Assignment cross join all_grader;

-- graders not satisfying the first condition
create view grader_not_1cond as
(select * from all_p_grader_assg) 
except (select * from exist_grader_assg);

-- filtering out those who didn't grade all assignments and leaving graders satisfying the first condition
create view grader_1cond as 
select * from all_grader EXCEPT
select username from grader_not_1cond;

--total number of students
create view total_students as
select count(distinct username) as num_stu
from Membership;

-- find grader (username) who marked all students
create view grader_2cond as
select Grader.username as username
from (Grader join Membership on Grader.group_id = Membership.group_id) 
group by Grader.username having 
count(distinct Membership.username) = (select * from total_students);

-- Final answer.
INSERT INTO q7 
	-- put a final query here so that its results will go into the table.
select * from grader_1cond intersect select * from grader_2cond;
	