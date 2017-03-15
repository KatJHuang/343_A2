-- A1 report

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q10;

-- You must not change this table definition.
CREATE TABLE q10 (
	group_id integer,
	mark real,
	compared_to_average real,
	status varchar(5)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS A1Groups CASCADE;

-- Define views for your intermediate steps here.
-- ======================================================================
-- concerning the assignment percentages for <group, assignment>
DROP VIEW IF EXISTS assignment_outof CASCADE;
DROP VIEW IF EXISTS real_grade CASCADE;

create view assignment_outof as
	select assignment_id, sum(out_of * weight) as assignment_outof
	from RubricItem group by assignment_id;

create view real_grade as 
	select assignment_id, group_id, mark * 100/assignment_outof as r_grade
	from AssignmentGroup natural join assignment_outof natural join Result;

-- ======================================================================

create view A1Groups as
	select group_id, r_grade
	from AssignmentGroup natural join Assignment natural full join real_grade
	where description = 'A1';

create view A1Avg as
	select avg(r_grade) as average
	from A1Groups;

-- Final answer.
INSERT INTO q10
	select group_id, r_grade, 
		r_grade - (select average from A1Avg) as diff, 
		case when diff > 0 then 'above' when diff = 0 then 'at' when diff < 0 then 'below' end
	from A1Groups;
	-- put a final query here so that its results will go into the table.
