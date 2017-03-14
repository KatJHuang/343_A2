-- If there is already any data in these tables, empty it out.

TRUNCATE TABLE Result CASCADE;
TRUNCATE TABLE Grade CASCADE;
TRUNCATE TABLE RubricItem CASCADE;
TRUNCATE TABLE Grader CASCADE;
TRUNCATE TABLE Submissions CASCADE;
TRUNCATE TABLE Membership CASCADE;
TRUNCATE TABLE AssignmentGroup CASCADE;
TRUNCATE TABLE Required CASCADE;
TRUNCATE TABLE Assignment CASCADE;
TRUNCATE TABLE MarkusUser CASCADE;


-- Now insert data from scratch.

INSERT INTO MarkusUser VALUES ('i1', 'iln1', 'ifn1', 'instructor');

INSERT INTO MarkusUser VALUES 
('A', 'sln1', 'sfn1', 'student'), 
('B', 'sln2', 'sfn2', 'student'),
('C', 'sln3', 'sfn3', 'student'),
('D', 'sln4', 'sfn4', 'student'), 
('E', 'sln4', 'sfn4', 'student'),
('F', 'sln4', 'sfn4', 'student'),

INSERT INTO MarkusUser VALUES ('t1', 'tln1', 'tfn1', 'TA');
INSERT INTO MarkusUser VALUES ('t2', 'tln2', 'tln2', 'TA');
INSERT INTO MarkusUser VALUES ('t3', 'tln3', 'tln3', 'TA');
INSERT INTO MarkusUser VALUES ('t4', 'tln4', 'tln4', 'TA');

-- assn id, descp, due, min, max
INSERT INTO Assignment VALUES (1, 'A1', '2017-01-08 20:00', 1, 2); --
INSERT INTO Assignment VALUES (2, 'A2', '2017-02-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (3, 'A3', '2017-03-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (4, 'A4', '2017-04-08 20:00', 1, 2);
--INSERT INTO Assignment VALUES (5, 'a5', '2017-05-08 20:00', 1, 2);
--INSERT INTO Assignment VALUES (6, 'a6', '2017-05-08 20:00', 1, 2);

INSERT INTO Required VALUES (1, 'A1.pdf');

-- group id, assignment id
select setval('AssignmentGroup_group_id_seq', 1,false);
INSERT INTO AssignmentGroup (assignment_id,repo) VALUES 
(1, 'repo_url'),--1
(1, 'repo_url'),--2
(1, 'repo_url'),--3
(1, 'repo_url'),--4
(1, 'repo_url'),--5
(1, 'repo_url'),--6
(1, 'repo_url'),--7
(1, 'repo_url'),--8
(1, 'repo_url'),--9
(1, 'repo_url'),--10
(2, 'repo_url'),--11
(2, 'repo_url'),--12
(2, 'repo_url'),--13
(2, 'repo_url'),--14
(2, 'repo_url'),--15
(2, 'repo_url'),--16
(2, 'repo_url'),--17
(2, 'repo_url'),--18
(2, 'repo_url'),--19
(2, 'repo_url'),--20
(2, 'repo_url'),--21
(2, 'repo_url'),--22
(2, 'repo_url'),--23
(2, 'repo_url'),--24
(2, 'repo_url'),--25
(2, 'repo_url'),--26
(1, 'repo_url'),--27
(2, 'repo_url'),--28
(3, 'repo_url'),--29
(1, 'repo_url'),--30
(2, 'repo_url'),--31
(1, 'repo_url'),--32
(2, 'repo_url'),--33
(1, 'repo_url'),--34
(2, 'repo_url'),--35
(3, 'repo_url'),--36
(3, 'repo_url'),--37
(3, 'repo_url'),--38
(3, 'repo_url'),--39
(3, 'repo_url'),--40

(4, 'repo_url')
;

-- student, group
INSERT INTO Membership VALUES 
('A',1),
('B',1),
('C',2),
('D',3),
('E',4),
('F',5)
;

-- sub id, group id
INSERT INTO Submissions VALUES 
(11, 'A1.pdf', 'A', 1, '2017-02-08 19:59'),
(21, 'A1.pdf', 'B', 1, '2017-02-06 19:59'),
(31, 'A1.pdf', 'A', 1, '2017-02-05 19:59'),
(41, 'A1.pdf', 'B', 1, '2017-02-04 19:59'),
(51, 'A1.pdf', 'B', 1, '2017-02-03 19:59'),
(61, 'A1.pdf', 'E', 4, '2017-02-04 19:59'),
(71, 'A1.pdf', 'E', 4, '2017-02-03 19:59'),
(81, 'A1.pdf', 'C', 2, '2017-02-04 19:59'),
(91, 'A1.pdf', 'C', 2, '2017-02-04 20:59'),
(101, 'A1.pdf', 'D', 3, '2017-02-04 19:59'),
(111, 'A1x.pdf', 'D', 3, '2017-02-04 19:59'),
(121, 'A1.pdf', 'F', 5, '2017-02-04 19:59'),
(131, 'A1c.pdf', 'F', 5, '2017-02-04 19:59'),
;

-- group id, username
INSERT INTO Grader VALUES 
(1, 't1'),
(2, 't1'),
(3, 't1'),
(4, 't1'),
(5, 't1')
;

INSERT INTO RubricItem VALUES (4010, 1, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4011, 1, 'tester', 12, 0.75);--
INSERT INTO RubricItem VALUES (4020, 2, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4021, 2, 'tester', 12, 0.75);
--INSERT INTO RubricItem VALUES (4030, 3, 'style', 4, 0.25);
--INSERT INTO RubricItem VALUES (4031, 3, 'tester', 12, 0.75);

INSERT INTO Grade VALUES (1, 4010, 2);
INSERT INTO Grade VALUES (1, 4011, 4);
INSERT INTO Grade VALUES (4, 4010, 4);
INSERT INTO Grade VALUES (4, 4011, 12);--
INSERT INTO Grade VALUES (2, 4020, 2);
INSERT INTO Grade VALUES (2, 4021, 8);
--INSERT INTO Grade VALUES (3, 4030, 3);
--INSERT INTO Grade VALUES (3, 4031, 7);

INSERT INTO Result VALUES 
(1, 5, true),
(2, 6, true),
(3, 6, true), 
(4, 5, true),
(5, 5, true)
;
