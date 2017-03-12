-- Getting soft

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q2;

-- You must not change this table definition.
CREATE TABLE q2 (
	ta_name varchar(100),
	average_mark_all_assignments real,
	mark_change_first_last real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS TA CASCADE;
DROP VIEW IF EXISTS TAAssignment CASCADE;

DROP VIEW IF EXISTS student CASCADE;
DROP VIEW IF EXISTS studentGroup CASCADE;

DROP VIEW IF EXISTS partialMarks CASCADE;
DROP VIEW IF EXISTS groupMark CASCADE;
DROP VIEW IF EXISTS individualMark CASCADE;

DROP VIEW IF EXISTS numOfAssn CASCADE;
DROP VIEW IF EXISTS gradedEveryAssn CASCADE;
DROP VIEW IF EXISTS seasoned CASCADE;

DROP VIEW IF EXISTS seasonedMarking CASCADE;
DROP VIEW IF EXISTS notSofter CASCADE;
DROP VIEW IF EXISTS softer CASCADE;



-- Define views for your intermediate steps here.

-- find all the TAs
create view TA as
	select username 
	from MarkusUser
	where type = 'TA';

-- find all the students
create view student as
	select username 
	from MarkusUser
	where type = 'student';

-- find the groups TAs have been assigned to
create view TAAssignment as
	select username, group_id
	from TA natural join Grader;

	-- find the groups TAs have been assigned to
create view studentGroup as
	select username, group_id
	from student natural join Membership;

-- get a percentage grade for all groups in all assignments
create view partialMarks as
	select assignment_id, group_id, 100*grade/out_of*weight as partial
	from RubricItem natural join Grade;

create view groupMark as
	select assignment_id, group_id, sum(partial) as mark
	from partialMarks
	group by assignment_id, group_id;

-- get a percentage mark for every individual student
create view individualMark as
	select assignment_id, group_id, mark
	from groupMark natural join studentGroup;

-- find number of graded assignments
create view numOfAssn as
	select count(distinct assignment_id) as count
	from AssignmentGroup natural join groupMark;

-- find all the TAs who have graded every assignment
create view gradedEveryAssn as
	select username
	from TAAssignment natural join AssignmentGroup natural join groupMark
	group by username
	having count(username) = (select count from numOfAssn);

-- find all the seasoned TAs who have marked more than 10 groups for each assignment
create view seasoned as
	select username, group_id, assignment_id
	from gradedEveryAssn natural join AssignmentGroup natural join Grader
	group by username, assignment_id, group_id
	having count(group_id) >= 10;

-- find all the average marks given by seasoned TAs on each assignment
create view seasonedMarking as
	select seasoned.username, assignment_id, due_date, avg(mark) as mark
	from seasoned natural join individualMark natural join Assignment
	group by assignment_id, seasoned.username, due_date;

-- find the TAs who didn't get softer over time
create view notSofter as
	select s1.username, s1.assignment_id, s1.due_date, s1.mark
	from seasonedMarking as s1 join seasonedMarking as s2 on s1.username = s2.username
	where s1.due_date > s2.due_date and s1.mark > s2.mark;

-- find the TAs who got softer over time
create view softer as
	select username, assignment_id, due_date, mark
	from seasonedMarking
	where username not in (select username from notSofter); 

-- Final answer.
INSERT INTO q2 
	-- put a final query here so that its results will go into the table.
	select username, avg(mark), max(mark)-min(mark)
	from softer natural join MarkusUser
	group by username;
