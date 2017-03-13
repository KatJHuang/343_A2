-- Solo superior

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q3;

-- You must not change this table definition.
CREATE TABLE q3 (
	assignment_id integer,
	description varchar(100), 
	num_solo integer, 
	average_solo real,
	num_collaborators integer, 
	average_collaborators real, 
	average_students_per_submission real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS assignment_outof CASCADE;
DROP VIEW IF EXISTS real_grade CASCADE;
DROP VIEW IF EXISTS solo_group CASCADE;
DROP VIEW IF EXISTS col_group CASCADE;
DROP VIEW IF EXISTS solo_num CASCADE;
DROP VIEW IF EXISTS col_num CASCADE;
DROP VIEW IF EXISTS solo_avg CASCADE;
DROP VIEW IF EXISTS col_avg CASCADE;
DROP VIEW IF EXISTS assg_num_students CASCADE;
DROP VIEW IF EXISTS assg_num_groups CASCADE;
DROP VIEW IF EXISTS assg_num_per_group CASCADE;
-- Define views for your intermediate steps here.

--first get a list of all grades
create view assignment_outof as
select assignment_id, sum(out_of * weight) as assignment_outof
from RubricItem group by assignment_id;

create view real_grade as 
select assignment_id, group_id, mark * 100/assignment_outof as r_grade
from AssignmentGroup natural join assignment_outof natural join Result;

--list all groups work alone
create view solo_group as
select group_id from Membership
group by group_id having count(username) = 1;

--list all groups have at least 2 people
create view col_group as
select group_id from Membership
group by group_id having count(username) >1;

--get the num_solo
--*******************************************
create view solo_num as
select assignment_id, count(group_id) as num_solo
from solo_group natural join AssignmentGroup
group by assignment_id;

--get the num_collaborators
--*******************************************
create view col_num as
select assignment_id, count(username) as num_collaborators
from col_group natural join AssignmentGroup natural join Membership
group by assignment_id;

--get the average_solo
--*******************************************
create view solo_avg as
select assignment_id, avg(r_grade) as average_solo
from solo_group natural join real_grade
group by assignment_id;

--get the average_collaborators
--*******************************************
create view col_avg as
select assignment_id, avg(r_grade) as average_collaborators
from col_group natural join real_grade
group by assignment_id;

--get the average number of students per group of an assignment_id
create view assg_num_students as
select assignment_id, count(username) as us_count
from AssignmentGroup natural join Membership
group by assignment_id;

create view assg_num_groups as
select assignment_id, count(group_id) as gp_count
from AssignmentGroup group by assignment_id;

--*******************************************
create view assg_num_per_group as
select assignment_id, (us_count::float / gp_count::float) as average_students_per_submission
from assg_num_students natural join assg_num_groups;
--end of getting average_students_per_submission

-- Final answer.
INSERT INTO q3
	-- put a final query here so that its results will go into the table.
select assignment_id, description, num_solo, 
average_solo, num_collaborators, average_collaborators, average_students_per_submission
from (assg_num_per_group natural join col_avg 
natural join solo_avg natural join col_num 
natural join solo_num) natural full join Assignment;
