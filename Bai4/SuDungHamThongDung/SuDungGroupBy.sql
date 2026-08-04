use quanlysinhvien;

select Address, count(StudentId) as 'Số lượng học viên'
from student
group by Address;

select s.StudentName, avg(Mark)
from student s join Mark m on s.StudentId = m.StudentId
group by s.StudentId, s.studentName;

select s.StudentName, avg(Mark) as DiemTrungBinh
from student s join Mark m on s.StudentId = m.StudentId
group by s.StudentId, s.studentName
having avg(Mark) > 15;

select s.StudentName, avg(Mark) as DiemTrungBinh
from student s join Mark m on s.StudentId = m.StudentId
group by s.StudentId, s.studentName
having avg(Mark) >= all(select avg(Mark) from Mark group by Mark.StudentId);