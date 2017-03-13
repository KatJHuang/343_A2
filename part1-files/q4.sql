-- Grader report

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q4;

-- You must not change this table definition.
CREATE TABLE q4 (
	assignment_id integer,
	username varchar(25), 
	num_marked integer, 
	num_not_marked integer,
	min_mark real,
	max_mark real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
/* DROP VIEW IF EXISTS partialMarks CASCADE;
DROP VIEW IF EXISTS groupMark CASCADE;
DROP VIEW IF EXISTS gradeAssignment CASCADE;
 */
DROP VIEW IF EXISTS assignment_outof CASCADE;
DROP VIEW IF EXISTS real_grade CASCADE;
DROP VIEW IF EXISTS assg_graded CASCADE;
DROP VIEW IF EXISTS assg_group_graded CASCADE;
DROP VIEW IF EXISTS assg_grader_graded CASCADE;

create view assignment_outof as
select assignment_id, sum(out_of * weight) as assignment_outof
from RubricItem group by assignment_id;

create view real_grade as 
select assignment_id, group_id, mark * 100/assignment_outof as r_grade
from AssignmentGroup natural join assignment_outof natural join Result;

--find the assignment that has been graded any
create view assg_graded as 
select assignment_id from real_grade;

--find the valid assignment's group and their ta assignment
create view assg_group_graded as
select distinct assignment_id, group_id, username 
from assg_graded natural join AssignmentGroup natural join Grader;

create view assg_grader_graded as 
select assignment_id, username, count(r_grade) as num_marked, 
count(*) - count(r_grade) as num_not_marked, 
min(r_grade) as min_mark, max(r_grade) as max_mark
from assg_group_graded natural full join real_grade
group by assignment_id, username;


/* -- for calculating marks
create view partialMarks as
	select assignment_id, group_id, 100*grade/out_of*weight as partial
	from RubricItem natural join Grade;

create view groupMark as
	select assignment_id, group_id, sum(partial) as mark
	from partialMarks
	group by assignment_id, group_id;
-- end of mark calculation

-- find assignments that have been declared for grading along with its graders and available marks
create view gradeAssignment as
	select username, AssignmentGroup.assignment_id, AssignmentGroup.group_id, mark 
	from AssignmentGroup full join Grader on AssignmentGroup.group_id = Grader.group_id full join groupMark on AssignmentGroup.group_id = groupMark.group_id;
 */
-- Final answer.
INSERT INTO q4
	-- put a final query here so that its results will go into the table.
	select *
	from assg_grader_graded;