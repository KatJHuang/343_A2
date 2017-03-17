-- Steady work

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q6;

-- You must not change this table definition.
CREATE TABLE q6 (
	group_id integer,
	first_file varchar(25),
	first_time timestamp,
	first_submitter varchar(25),
	last_file varchar(25),
	last_time timestamp, 
	last_submitter varchar(25),
	elapsed_time interval
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS A1Submissions CASCADE;
DROP VIEW IF EXISTS firstSubmission CASCADE;
DROP VIEW IF EXISTS first CASCADE;
DROP VIEW IF EXISTS last CASCADE;
DROP VIEW IF EXISTS lastSubmission CASCADE;

-- Define views for your intermediate steps here.
-- get all submissions in A1 
-- find which groups are for A1,
-- who's in it,
-- and when something version of A1 is submitted
create view A1Submissions as
	select assignment_id, group_id, username, file_name, submission_date
	from (Assignment natural join AssignmentGroup) natural full join Submissions
	where description = 'A1';

-- for each group, find the earliest A1 submission time
create view first as
	select group_id, min(submission_date) as submission_date
	from A1Submissions
	group by group_id;

-- join back to find who's the submitter and file name
create view firstSubmission as 
	select group_id, file_name as f_file, username as f_person, submission_date as first_sub
	from A1Submissions natural join first;

-- same as above but for the last submission
create view last as
	select group_id, max(submission_date) as submission_date
	from A1Submissions
	group by group_id;

create view lastSubmission as
	select group_id, file_name as l_file, username as l_person, submission_date as last_sub
	from A1Submissions natural join last;

-- Final answer.
INSERT INTO q6 
	-- put a final query here so that its results will go into the table.
select distinct A1Submissions.group_id as group_id, f_file as first_file, first_sub as first_time,
f_person as first_submitter, l_file as last_file, last_sub as last_time, l_person as last_submitter,
last_sub-first_sub as elapsed_time
from A1Submissions natural full join (firstSubmission natural join lastSubmission);
	