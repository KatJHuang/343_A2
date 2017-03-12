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
DROP VIEW IF EXISTS partialMarks CASCADE;
DROP VIEW IF EXISTS groupMark CASCADE;
DROP VIEW IF EXISTS gradeAssignment CASCADE;

-- for calculating marks
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

-- Final answer.
INSERT INTO q4
	-- put a final query here so that its results will go into the table.
	select assignment_id, username, count(mark), count(*) - count(mark), min(mark), max(mark)
	from gradeAssignment
	group by username, assignment_id;