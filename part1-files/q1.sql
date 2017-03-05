-- Distributions

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q1;

-- You must not change this table definition.
CREATE TABLE q1 (
	assignment_id integer,
	average_mark_percent real, 
	num_80_100 integer, 
	num_60_79 integer, 
	num_50_59 integer, 
	num_0_49 integer
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here.

-- find # of grades that are between 80 and 100 for each assignment
CREATE VIEW NUM_80_100(
	select count(AssignmentGroup.grade)
	from Grade outer join AssignmentGroup on group_id
	where Grade.grade >= 80 and Grade.grade <= 100
	group by AssignmentGroup.assignment_id;
);

-- find # of grades that are between 60 and 79 for each assignment
CREATE VIEW NUM_60_79(
	select count(AssignmentGroup.grade)
	from Grade outer join AssignmentGroup on group_id
	where Grade.grade >= 60 and Grade.grade <= 79
	group by AssignmentGroup.assignment_id;
);

-- find # of grades that are between 50 and 59 for each assignment
CREATE VIEW NUM_50_59(
	select count(AssignmentGroup.grade)
	from Grade outer join AssignmentGroup on group_id
	where Grade.grade >= 50 and Grade.grade <= 59
	group by AssignmentGroup.assignment_id;
);

-- find # of grades that are between 0 and 49 for each assignment
CREATE VIEW NUM_0_49(
	select count(AssignmentGroup.grade)
	from Grade outer join AssignmentGroup on group_id
	where Grade.grade >= 0 and Grade.grade <= 49
	group by AssignmentGroup.assignment_id;
);

-- find # of grades that are between 50 and 59 for each assignment
CREATE VIEW AVG(
	select avg(Grade.grade)
	from Grade, AssignmentGroup
	where Grade.group_id = AssignmentGroup.group_id
	group by AssignmentGroup.assignment_id;
);

CREATE VIEW ID(
	select AssignmentGroup.assignment_id
	from Grade outer join AssignmentGroup on group_id
	group by AssignmentGroup.assignment_id;
);


-- Final answer.
INSERT INTO q1 values
	-- put a final query here so that its results will go into the table.
	(ID, AVG, NUM_80_100, NUM_60_79, NUM_50_59, NUM_0_49);
