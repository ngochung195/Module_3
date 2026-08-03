use quanlysinhvien;

select * from student where StudentName like 'h%';

select * from class where month(StartDate) = 12;

select * from `subject` where Credit between 3 and 5;

update student set ClassID = 2 where StudentName = 'Hung';

select s.StudentName, sub.SubName, m.Mark
from mark m
join student s on m.StudentID = m.StudentID
join `subject` sub on m.SubID = sub.SubID
order by m.Mark desc, s.StudentName asc;