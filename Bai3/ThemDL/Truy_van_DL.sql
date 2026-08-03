USE QuanLySinhVien;

select * from student;

select * from student where Status = true;

select * from subject where Credit < 10;

select s.StudentId, s.StudentName, C.ClassName 
from student s join class c on s.ClassID = c.ClassID
where c.ClassName = 'A1';

select s.StudentId, s.StudentName, sub.SubName, m.Mark
from Student s join mark m on s.StudentId = m.StudentID join subject sub on m.SubID = sub.SubID
where sub.SubName = 'CF'; 