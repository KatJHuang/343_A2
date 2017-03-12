<<<<<<< HEAD
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

<<<<<<< HEAD
-- Add a column for percentage total grade of each group in each assignment
create view real_grade as 
select assignment_id, rubric_id, group_id, (grade*weight/out_of) as r_grade
from RubricItem natural join Grade;

-- **************************************************
--find the sum grade of each assignment
create view real_sum_grade as
select assignment_id, sum(r_grade) as assignment_total 
from real_grade 
group by assignment_id;

-- find the number of groups for each assignment
create view group_count_per_assignment as 
select assignment_id, count(group_id) as group_count 
from real_grade 
group by assignment_id;

-- find average_mark_percent for each assignment
-- *******this is one answer************
create view assignment_avg_grade as
select assignment_id, (assignment_total/group_count) as average_mark_percent 
from real_sum_grade natural join group_count_per_assignment;
-- ***************************************************

-- find the percentage mark for each group on each assignment
create view real_grade_each_group as
select assignment_id, group_id, sum(r_grade) as assignment_percent
from real_grade
group by assignment_id, group_id;

create view number_80to100 as
select assignment_id, count(group_id) as num_80_100
from real_grade_each_group
where assignment_percent >=80;

create view number_60to79 as
select assignment_id, count(group_id) as num_60_79
from real_grade_each_group
where assignment_percent >=60 and assignment_percent <80;

create view number_50to59 as
select assignment_id, count(group_id) as num_50_59
from real_grade_each_group
where assignment_percent >=50 and assignment_percent < 60;

create view number_0to49 as
select assignment_id, count(group_id) as num_0_49
from real_grade_each_group
where assignment_percent < 50;

-- Final answer.
INSERT INTO q1 (select assignment_id, average_mark_percent, num_80_100, num_60_79, num_50_59, num_0_49
from (assignment_avg_grade natural join number_80to100 natural join num_60_79 
natural join number_50to59 natural join number_0to49) as assignment_1 FULL join Assignment 
on Assignment.assignment_id = assignment_1.assignment_id);
	-- put a final query here so that its results will go into the table.
=======
-- find # of grades that are between 80 and 100 for each assignment
CREATE VIEW NUM_80_100 AS(
	select count(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	where Grade.grade >= 80 and Grade.grade <= 100
	group by AssignmentGroup.assignment_id
);

-- find # of grades that are between 60 and 79 for each assignment
CREATE VIEW NUM_60_79 AS (
	select count(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	where Grade.grade >= 60 and Grade.grade <= 79
	group by AssignmentGroup.assignment_id
);

-- find # of grades that are between 50 and 59 for each assignment
CREATE VIEW NUM_50_59 AS (
	select count(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	where Grade.grade >= 50 and Grade.grade <= 59
	group by AssignmentGroup.assignment_id
);

-- find # of grades that are between 0 and 49 for each assignment
CREATE VIEW NUM_0_49 AS (
	select count(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	where Grade.grade >= 0 and Grade.grade <= 49
	group by AssignmentGroup.assignment_id
);

-- find # of grades that are between 50 and 59 for each assignment
CREATE VIEW AVG AS (
	select avg(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	group by AssignmentGroup.assignment_id
);

CREATE VIEW ID AS (
	select AssignmentGroup.assignment_id
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	group by AssignmentGroup.assignment_id
);


-- Final answer.
INSERT INTO q1 values
	-- put a final query here so that its results will go into the table.
	(select * from ID, 
		select * from AVG, 
		select * from NUM_80_100, 
		select * from NUM_60_79, 
		select * from NUM_50_59, 
		select * from NUM_0_49);
>>>>>>> origin/master
=======
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

-- Add a column for percentage total grade of each group in each assignment
create view real_grade as 
select assignment_id, rubric_id, group_id, (grade*weight/out_of) as r_grade
from RubricItem natural join Grade;

-- **************************************************
--find the sum grade of each assignment
create view real_sum_grade as
select assignment_id, sum(r_grade) as assignment_total 
from real_grade 
group by assignment_id;

-- find the number of groups for each assignment
create view group_count_per_assignment as 
select assignment_id, count(group_id) as group_count 
from real_grade 
group by assignment_id;

-- find average_mark_percent for each assignment
-- *******this is one answer************
create view assignment_avg_grade as
select assignment_id, (assignment_total/group_count) as average_mark_percent 
from real_sum_grade natural join group_count_per_assignment;
-- ***************************************************

-- find the percentage mark for each group on each assignment
create view real_grade_each_group as
select assignment_id, group_id, sum(r_grade) as assignment_percent
from real_grade
group by assignment_id, group_id;

create view number_80to100 as
select assignment_id, count(group_id) as num_80_100
from real_grade_each_group
where assignment_percent >=80;

create view number_60to79 as
select assignment_id, count(group_id) as num_60_79
from real_grade_each_group
where assignment_percent >=60 and assignment_percent <80;

create view number_50to59 as
select assignment_id, count(group_id) as num_50_59
from real_grade_each_group
where assignment_percent >=50 and assignment_percent < 60;

create view number_0to49 as
select assignment_id, count(group_id) as num_0_49
from real_grade_each_group
where assignment_percent < 50;

-- Final answer.
INSERT INTO q1 (select assignment_id, average_mark_percent, num_80_100, num_60_79, num_50_59, num_0_49
from (assignment_avg_grade natural join number_80to100 natural join num_60_79 
natural join number_50to59 natural join number_0to49) as assignment_1 FULL join Assignment 
on Assignment.assignment_id = assignment_1.assignment_id);
	-- put a final query here so that its results will go into the table.
=======
-- find # of grades that are between 80 and 100 for each assignment
CREATE VIEW NUM_80_100 AS(
	select count(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	where Grade.grade >= 80 and Grade.grade <= 100
	group by AssignmentGroup.assignment_id
);

-- find # of grades that are between 60 and 79 for each assignment
CREATE VIEW NUM_60_79 AS (
	select count(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	where Grade.grade >= 60 and Grade.grade <= 79
	group by AssignmentGroup.assignment_id
);

-- find # of grades that are between 50 and 59 for each assignment
CREATE VIEW NUM_50_59 AS (
	select count(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	where Grade.grade >= 50 and Grade.grade <= 59
	group by AssignmentGroup.assignment_id
);

-- find # of grades that are between 0 and 49 for each assignment
CREATE VIEW NUM_0_49 AS (
	select count(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	where Grade.grade >= 0 and Grade.grade <= 49
	group by AssignmentGroup.assignment_id
);

-- find # of grades that are between 50 and 59 for each assignment
CREATE VIEW AVG AS (
	select avg(Grade.grade)
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	group by AssignmentGroup.assignment_id
);

CREATE VIEW ID AS (
	select AssignmentGroup.assignment_id
	from Grade full join AssignmentGroup on AssignmentGroup.group_id = Grade.group_id
	group by AssignmentGroup.assignment_id
);


-- Final answer.
INSERT INTO q1 values
	-- put a final query here so that its results will go into the table.
	(select * from ID, 
		select * from AVG, 
		select * from NUM_80_100, 
		select * from NUM_60_79, 
		select * from NUM_50_59, 
		select * from NUM_0_49);

>>>>>>> origin/master
