--	The ability to create recursive triggers is a new feature of SQL Server
--	starting with version 7.0. This article contains a Transact-SQL script that
--	demonstrates an example of using recursive triggers to create a parent/child
--	self-joining relationship to store a directory tree and maintain a full path.
--	This gives you the best of both worlds: great update capability of the
--	parent/child relationship and the query performance in getting the full path. 
--
sp_dboption 'pubs', 'recursive triggers', TRUE
GO

USE pubs
GO

DROP TABLE tree
GO
CREATE TABLE tree(id INT, pid INT NULL, name VARCHAR(40), fullname VARCHAR(512))
GO
INSERT INTO tree VALUES (1, null, 'root'    ,'root')
INSERT INTO tree VALUES (2, 1,    'x86'     ,'root\x86')
INSERT INTO tree VALUES (3, 2,    'retail'  ,'root\x86\retail')
INSERT INTO tree VALUES (4, 3,    'bin'     ,'root\x86\retail\bin')
INSERT INTO tree VALUES (5, 3,    'include' ,'root\x86\retail\include')
INSERT INTO tree VALUES (6, 3,    'lib'     ,'root\x86\retail\lib')
INSERT INTO tree VALUES (7, 5,    'mfc'     ,'root\x86\retail\include\mfc')
GO

CREATE TRIGGER tree_trg_upd
ON tree
FOR UPDATE
AS
IF (@@ROWCOUNT > 0) BEGIN
   IF (UPDATE (name)) BEGIN
      UPDATE TREE
      SET TREE.fullname = CASE  
            WHEN PARENT.fullname IS NOT NULL 
               THEN PARENT.fullname + '\'' 
            ELSE ''
         END
         + INSERTED.name
      FROM INSERTED, tree, TREE PARENT
      WHERE INSERTED.ID = tree.ID
      AND INSERTED.PID *= PARENT.ID
   END
   IF (UPDATE (fullname)) BEGIN
      UPDATE tree
      SET fullname = INSERTED.fullname + '\'' + tree.name
      FROM tree, INSERTED
      WHERE INSERTED.id = tree.pid
   END
END
GO

SELECT * FROM tree
GO

BEGIN TRANSACTION
GO
UPDATE tree
SET name = 'base_root'
WHERE name = 'root'
GO
SELECT * FROM tree
GO
ROLLBACK TRANSACTION
GO

BEGIN TRANSACTION
GO
UPDATE tree
SET name = 'i386'
WHERE name = 'x86'
GO
SELECT * FROM tree
GO
ROLLBACK TRANSACTION
GO

DROP TABLE tree
GO
