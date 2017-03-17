-- Uneven workloads

SET SEARCH_PATH TO markus;
DROP TABLE IF EXISTS q5;

-- You must not change this table definition.
CREATE TABLE q5 (
	assignment_id integer,
	username varchar(25), 
	num_assigned integer
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS num_groups_per_grader CASCADE;
DROP VIEW IF EXISTS uneven_assg CASCADE;

-- Define views for your intermediate steps here.
-- for each grader and assignments to which they've assigned, find number of groups they graded in those assignments
create view num_groups_per_grader as
select assignment_id, username, count(group_id) as num_assigned
from AssignmentGroup natural join Grader
group by assignment_id, username;

-- pick out those assignment for which TAs had uneven workload
create view uneven_assg as
select assignment_id
from num_groups_per_grader 
group by assignment_id 
having max(num_assigned) - min(num_assigned) > 10;

-- Final answer.
INSERT INTO q5 
	-- put a final query here so that its results will go into the table.
	select *
	from uneven_assg natural join num_groups_per_grader;