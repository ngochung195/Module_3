use quanlysinhvien;

select * 
from `subject`
where Credit = (select max(Credit) from `subject`);

select sub.* 
from `subject` sub
join mark m on sub.SubID = m.SubID
where m.mark = (select max(Mark) from mark);

select s.*, avg(Mark) as DiemTB
from student s
join mark m on s.StudentID = m.StudentID
group by StudentID
order by DiemTB desc;