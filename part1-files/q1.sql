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
DROP VIEW IF EXISTS real_grade CASCADE;
DROP VIEW IF EXISTS real_sum_grade CASCADE;
DROP VIEW IF EXISTS group_count_per_assignment CASCADE;
DROP VIEW IF EXISTS assignment_avg_grade CASCADE;
DROP VIEW IF EXISTS real_grade_each_group CASCADE;
DROP VIEW IF EXISTS number_80to100 CASCADE;
DROP VIEW IF EXISTS number_60to79 CASCADE;
DROP VIEW IF EXISTS number_50to59 CASCADE;
DROP VIEW IF EXISTS number_0to49 CASCADE;
DROP VIEW IF EXISTS all_assignments CASCADE;
DROP VIEW IF EXISTS assignment_outof CASCADE;
-- Define views for your intermediate steps here.

create view all_assignments as
select assignment_id from Assignment;

create view assignment_outof as
select assignment_id, sum(out_of * weight) as assignment_outof
from RubricItem group by assignment_id;

-- Add a column for percentage total grade of each group in each assignment
create view real_grade as 
select assignment_id, group_id, mark * 100/assignment_outof as r_grade
from AssignmentGroup natural join assignment_outof natural join Result;

-- **************************************************
--find the sum grade of each assignment
create view real_sum_grade as
select assignment_id, sum(r_grade) as assignment_total 
from real_grade 
group by assignment_id;

-- find the number of groups for each assignment
create view group_count_per_assignment as 
select assignment_id, count(distinct group_id) as group_count 
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
select assignment_id, count(*) as number_80_100
from real_grade_each_group
where assignment_percent >=80
group by assignment_id;

create view number_60to79 as
select assignment_id, count(*) as number_60_79
from real_grade_each_group
where assignment_percent >=60 and assignment_percent <80
group by assignment_id;

create view number_50to59 as
select assignment_id, count(*) as number_50_59
from real_grade_each_group
where assignment_percent >=50 and assignment_percent < 60
group by assignment_id;

create view number_0to49 as
select assignment_id, count(*) as number_0_49
from real_grade_each_group
where assignment_percent < 50
group by assignment_id;

-- Final answer.
INSERT INTO q1 (
	select Assignment.assignment_id, COALESCE(average_mark_percent,0), COALESCE(number_80_100,0),
	COALESCE(number_60_79,0), COALESCE(number_50_59,0), COALESCE(number_0_49,0)
	from assignment_avg_grade natural full join (number_80to100 
			natural full join number_60to79 
			natural full join number_50to59 
			natural full join number_0to49 
			natural full join Assignment )
			natural full join all_assignments
);
	-- put a final query here so that its results will go into the table.