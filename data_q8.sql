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
('s1', 'sln1', 'sfn1', 'student'), 
('s2', 'sln2', 'sfn2', 'student'),
('s3', 'sln3', 'sfn3', 'student'),
('s4', 'sln4', 'sfn4', 'student')
; -- even work in groups whenever possible 

INSERT INTO MarkusUser VALUES ('t1', 'tln1', 'tfn1', 'TA');
INSERT INTO MarkusUser VALUES ('t2', 'tln2', 'tln2', 'TA');
INSERT INTO MarkusUser VALUES ('t3', 'tln3', 'tln3', 'TA');
INSERT INTO MarkusUser VALUES ('t4', 'tln4', 'tln4', 'TA');

-- assn id, descp, due, min, max
INSERT INTO Assignment VALUES (1, 'A1', '2017-01-08 20:00', 1, 1); --
INSERT INTO Assignment VALUES (2, 'A2', '2017-02-08 20:00', 1, 2);
INSERT INTO Assignment VALUES (3, 'A3', '2017-03-08 20:00', 1, 1);
INSERT INTO Assignment VALUES (4, 'A4', '2017-04-08 20:00', 1, 2);

INSERT INTO Required VALUES (1, 'A1.pdf');
INSERT INTO Required VALUES (2, 'A2.pdf');
INSERT INTO Required VALUES (3, 'A3.pdf');
INSERT INTO Required VALUES (4, 'A4.pdf');

-- group id, assignment id
INSERT INTO AssignmentGroup VALUES
(11, 1, 'repo'),
(12, 1, 'repo'),
(13, 1, 'repo'),
(14, 1, 'repo'), -- assignment 1 must be done solo

(21, 2, 'repo'),
(23, 2, 'repo'),
(224, 2, 'repo'), -- assignment 2 can be done in pairs

(31, 3, 'repo'),
(32, 3, 'repo'),
(33, 3, 'repo'),
(34, 3, 'repo'),

(41, 4, 'repo'),
(43, 4, 'repo'),
(424, 4, 'repo')
;

-- student, group
INSERT INTO Membership VALUES 
('s1', 11),
('s2', 12),
('s3', 13),
('s4', 14), -- A1

('s1', 21),
('s2', 224),
('s3', 23),
('s4', 224), -- A2

('s1', 31),
('s2', 32),
('s3', 33),
('s4', 34), -- A3

('s1', 41),
('s2', 424),
('s3', 43),
('s4', 424) -- A4
;


-- sub id, group id
INSERT INTO Submissions VALUES 
(11, 'A1.pdf', 's1', 11, '2017-02-08 19:59'),
(12, 'A1.pdf', 's2', 12, '2017-02-08 19:59'),
(13, 'A1.pdf', 's3', 13, '2017-02-08 19:59'),
(14, 'A1.pdf', 's4', 14, '2017-02-08 19:59'), -- A1


(21, 'A2.pdf', 's1', 21, '2017-02-08 19:59'),
(23, 'A2.pdf', 's3', 23, '2017-02-08 19:59'),
(24, 'A2.pdf', 's4', 224, '2017-02-08 19:59'), -- A2

(31, 'A3.pdf', 's1', 31, '2017-02-08 19:59'),
(32, 'A3.pdf', 's2', 32, '2017-02-08 19:59'),
(33, 'A3.pdf', 's3', 33, '2017-02-08 19:59'),
(34, 'A3.pdf', 's4', 34, '2017-02-08 19:59'), -- A3


(41, 'A4.pdf', 's1', 41, '2017-02-08 19:59'),
(43, 'A4.pdf', 's3', 43, '2017-02-08 19:59'),
(44, 'A4.pdf', 's4', 424, '2017-02-08 19:59') -- A4
;

-- group id, username
INSERT INTO Grader VALUES 
(11, 't1'),
(12, 't1'),
(13, 't1'),
(14, 't1'), -- A1


(21, 't1'),
(23, 't1'),
(224, 't1'), -- A2

(31, 't1'),
(32, 't1'),
(33, 't1'),
(34, 't1'), -- A3


(41, 't1'),
(43, 't1'),
(424, 't1') -- A4
;

-- rub id, assg, name, out of, weight
INSERT INTO RubricItem VALUES (4010, 1, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4011, 1, 'tester', 12, 0.75);--

INSERT INTO RubricItem VALUES (4020, 2, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4021, 2, 'tester', 12, 0.75);

INSERT INTO RubricItem VALUES (4030, 3, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4031, 3, 'tester', 12, 0.75);

INSERT INTO RubricItem VALUES (4040, 4, 'style', 4, 0.25);
INSERT INTO RubricItem VALUES (4041, 4, 'tester', 12, 0.75);

-- group, rub id, grade
INSERT INTO Grade VALUES (11, 4010, 2);
INSERT INTO Grade VALUES (11, 4011, 4);
INSERT INTO Grade VALUES (12, 4010, 2);
INSERT INTO Grade VALUES (12, 4011, 4);
INSERT INTO Grade VALUES (13, 4010, 2);
INSERT INTO Grade VALUES (13, 4011, 4);
INSERT INTO Grade VALUES (14, 4010, 2);
INSERT INTO Grade VALUES (14, 4011, 4); -- A1


INSERT INTO Grade VALUES (21, 4020, 2);
INSERT INTO Grade VALUES (21, 4021, 4);
INSERT INTO Grade VALUES (23, 4020, 2);
INSERT INTO Grade VALUES (23, 4021, 4);
INSERT INTO Grade VALUES (224, 4020, 2);
INSERT INTO Grade VALUES (224, 4021, 4); -- A2


INSERT INTO Grade VALUES (31, 4030, 2);
INSERT INTO Grade VALUES (31, 4031, 4);
INSERT INTO Grade VALUES (32, 4030, 2);
INSERT INTO Grade VALUES (32, 4031, 4);
INSERT INTO Grade VALUES (33, 4030, 2);
INSERT INTO Grade VALUES (33, 4031, 4);
INSERT INTO Grade VALUES (34, 4030, 2);
INSERT INTO Grade VALUES (34, 4031, 4); -- A3


INSERT INTO Grade VALUES (41, 4040, 2);
INSERT INTO Grade VALUES (41, 4041, 4);
INSERT INTO Grade VALUES (43, 4040, 2);
INSERT INTO Grade VALUES (43, 4041, 4);
INSERT INTO Grade VALUES (424, 4040, 2);
INSERT INTO Grade VALUES (424, 4041, 4); -- A4


-- group id, mark, released?
INSERT INTO Result VALUES 
(11, 5, true),
(12, 5, true),
(13, 5, true),
(14, 5, true),

(21, 5, true),
(23, 5, true),
(224, 5, true),

(31, 5, true),
(32, 5, true),
(33, 5, true),
(34, 5, true),

(41, 5, true),
(43, 5, true),
(424, 5, true)
;
