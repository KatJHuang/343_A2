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

INSERT INTO MarkusUser VALUES ('A', 'sln1', 'sfn1', 'student');
INSERT INTO MarkusUser VALUES ('B', 'sln2', 'sfn2', 'student'); --
INSERT INTO MarkusUser VALUES ('C', 'sln3', 'sfn3', 'student');
INSERT INTO MarkusUser VALUES ('D', 'sln4', 'sfn4', 'student'), ('E', 'sln4', 'sfn4', 'student'); --

INSERT INTO MarkusUser VALUES ('t1', 'tln1', 'tfn1', 'TA');
INSERT INTO MarkusUser VALUES ('t2', 'tln2', 'tln2', 'TA');
INSERT INTO MarkusUser VALUES ('t3', 'tln3', 'tln3', 'TA');
INSERT INTO MarkusUser VALUES ('t4', 'tln4', 'tln4', 'TA');

-- assn id, descp, due, min, max
INSERT INTO Assignment VALUES (1, 'a1', '2017-01-08 20:00', 1, 2); --
INSERT INTO Assignment VALUES (2, 'a2', '2017-02-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (3, 'a3', '2017-03-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (4, 'a4', '2017-04-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (5, 'a5', '2017-05-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (6, 'a6', '2017-05-08 20:00', 1, 2);

INSERT INTO Required VALUES (1, 'A1.pdf');

-- group id, assignment id
INSERT INTO AssignmentGroup VALUES (1, 1, 'repo_url');--
INSERT INTO AssignmentGroup VALUES (4, 1, 'repo_url');--
INSERT INTO AssignmentGroup VALUES (2, 2, 'repo_url');
INSERT INTO AssignmentGroup VALUES (3, 2, 'repo_url'),(5, 3, 'repo_url');

-- student, group
INSERT INTO Membership VALUES ('A', 1),('B',1),('C',2),('D',3),('E',4);

-- sub id, group id
INSERT INTO Submissions VALUES (11, 'A1.pdf', 'A', 1, '2017-02-08 19:59');
INSERT INTO Submissions VALUES (21, 'A1.pdf', 'B', 1, '2017-02-06 19:59');
INSERT INTO Submissions VALUES (31, 'A1.pdf', 'A', 1, '2017-02-05 19:59');
INSERT INTO Submissions VALUES (41, 'A1.pdf', 'B', 1, '2017-02-04 19:59');
INSERT INTO Submissions VALUES (51, 'A1.pdf', 'A', 1, '2017-02-03 19:59');
INSERT INTO Submissions VALUES (61, 'A1.pdf', 'C', 4, '2017-02-04 19:59');
INSERT INTO Submissions VALUES (71, 'A1.pdf', 'D', 4, '2017-02-03 19:59');

-- group id, username
INSERT INTO Grader VALUES (1, 't1');--
INSERT INTO Grader VALUES (2, 't2');--
INSERT INTO Grader VALUES (3, 't1');--
INSERT INTO Grader VALUES (4, 't4');

INSERT INTO RubricItem VALUES (4010, 1, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4011, 1, 'tester', 12, 0.75);--
INSERT INTO RubricItem VALUES (4020, 2, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4021, 2, 'tester', 12, 0.75);
INSERT INTO RubricItem VALUES (4030, 3, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4031, 3, 'tester', 12, 0.75);

INSERT INTO Grade VALUES (1, 4010, 3);
INSERT INTO Grade VALUES (1, 4011, 9);--
INSERT INTO Grade VALUES (2, 4020, 2);
INSERT INTO Grade VALUES (2, 4021, 8);
INSERT INTO Grade VALUES (3, 4030, 1);
INSERT INTO Grade VALUES (3, 4031, 7);

INSERT INTO Result VALUES (2, 8, true);
INSERT INTO Result VALUES (3, 12, true);
INSERT INTO Result VALUES (4, 7, true), (1, 5, true);
