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
DROP VIEW IF EXISTS lastSubmission CASCADE;

-- Define views for your intermediate steps here.
create view A1Submissions as
	select assignment_id, group_id, username, file_name, submission_date
	from Assignment natural join AssignmentGroup natural join Submissions
	where description = 'a1';

create view first as
	select group_id, min(submission_date) as submission_date
	from A1Submissions
	group by group_id;

create view firstSubmission as 
	select group_id, file_name as f_file, username as f_person, submission_date as first_sub
	from A1Submissions natural join first;

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
	select A1Submissions.group_id, f_file, first_sub, f_person, l_file, last_sub, l_person, last_sub-first_sub 
	from A1Submissions join (firstSubmission natural join lastSubmission) on A1Submissions.submission_date = firstSubmission.first_sub 
		and A1Submissions.group_id = firstSubmission.group_id;
	