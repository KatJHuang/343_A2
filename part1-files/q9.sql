-- Inseparable

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q9;

-- You must not change this table definition.
CREATE TABLE q9 (
	student1 varchar(25),
	student2 varchar(25)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS possiblePairing CASCADE;
DROP VIEW IF EXISTS allowsGroup CASCADE;
DROP VIEW IF EXISTS inseparable CASCADE;

-- Define views for your intermediate steps here.
create view possiblePairing as
	select distinct m1.username as s1, m2.username as s2
	from membership as m1, membership as m2
	where m1.group_id = m2.group_id and m1.username < m2.username;

-- find number of assignments that allows group
create view allowsGroup as
	select count(distinct assignment_id) as num_of_assignments
	from Assignment natural join AssignmentGroup
	where group_max > 1;

create view inseparable as
	select * 
	from possiblePairing
	group by s1, s2
	having count(*) = (select num_of_assignments from allowsGroup);

-- Final answer.
INSERT INTO q9 
	-- put a final query here so that its results will go into the table.
	select * from inseparable;
