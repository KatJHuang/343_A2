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
DROP VIEW IF EXISTS assignment_outof CASCADE;
DROP VIEW IF EXISTS real_grade CASCADE;
DROP VIEW IF EXISTS TA CASCADE;
DROP VIEW IF EXISTS TAAssignment CASCADE;

DROP VIEW IF EXISTS TA_assg_group_mark CASCADE;
DROP VIEW IF EXISTS valid_TA CASCADE;
DROP VIEW IF EXISTS valid_TA_assg_group_mark CASCADE;
DROP VIEW IF EXISTS valid_TA_assg_avg CASCADE;
DROP VIEW IF EXISTS valid_TA_assg_avg_due CASCADE;
DROP VIEW IF EXISTS TA_not_softer CASCADE;
DROP VIEW IF EXISTS TA_softer CASCADE;
DROP VIEW IF EXISTS ans CASCADE;



-- Define views for your intermediate steps here.

create view assignment_outof as
select assignment_id, sum(out_of * weight) as assignment_outof
from RubricItem group by assignment_id;

create view real_grade as 
select assignment_id, group_id, mark * 100/assignment_outof as r_grade
from AssignmentGroup natural join assignment_outof natural join Result;

-- find all the TAs
create view TA as
	select username 
	from MarkusUser
	where type = 'TA';

-- find the groups TAs have been assigned to
create view TAAssignment as
	select username, group_id
	from TA natural join Grader;

-- for every TA, find which assignment done by which group and the marks given by him/her
create view TA_assg_group_mark as
select username, assignment_id, group_id, r_grade as mark
from TAAssignment natural join real_grade natural full join Assignment;

-- find the TA (just username) that has at least 10 grades for each assignment
create view valid_TA as
select username
from TA_assg_group_mark group by assignment_id, username
having count(group_id) >= 10;

-- for every valid TA, find which assignment done by which group and the marks given by him/her
create view valid_TA_assg_group_mark as
select * from TA_assg_group_mark natural join valid_TA;

-- for each TA, compute an average for each assignment
create view valid_TA_assg_avg as
select username, assignment_id, avg(mark) as mark
from valid_TA_assg_group_mark group by assignment_id, username;

-- throw in the extra info of due date for each assignment
create view valid_TA_assg_avg_due as 
select username, assignment_id, due_date, mark
from valid_TA_assg_avg natural join Assignment;

-- find the username of TAs who don't get softer over time
create view TA_not_softer as
select t1.username from valid_TA_assg_avg_due as t1 join valid_TA_assg_avg_due as t2 
on t1.username = t2.username
where t1.due_date > t2.due_date and t1.mark <= t2.mark;

-- remove the not-softer TA from all TAs and the ones left are the softer ones
create view TA_softer as
select username, avg(mark) as average_mark_all_assignments, max(mark) - min(mark) as mark_change_first_last
from valid_TA_assg_avg 
where username not in (select * from TA_not_softer)
group by username;

-- put TA name, average, and change in average together
create view ans as
select firstname || ' ' || surname as ta_name, average_mark_all_assignments, mark_change_first_last
from TA_softer natural join MarkusUser;

-- Final answer.
INSERT INTO q2 
	-- put a final query here so that its results will go into the table.
	select * from ans;
