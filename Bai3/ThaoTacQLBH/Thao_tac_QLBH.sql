use quanlybanhang;

insert into customer(cId, cName, cAge) value
(1, 'Minh Quan', 10),
(2, 'Ngoc Anh', 20),
(3, 'Hong Ha', 50);

insert into `order`(oId, cId, oDate) value
(1, 1, '2006-03-21'),
(2, 2, '2006-01-23'),
(3, 1, '2006-03-16');

insert into product(pId, pName, pPrice) value
(1, 'May Giati', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

insert into orderdetail(oId, pId, odQTY) value
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

select oId, oDate, oTotalPrice from `order`;

select c.cName, p.pName
from customer c 
join `order` o on c.cId = o.cId
join orderdetail od on o.oId = od.oId
join product p on od.pId = p.pId;

select c.cName 
from customer c
left join `order` o on c.cId = o.cId
where o.oId is null;

select o.oId as MaHoaDon, o.oDate as NgayBan, sum(od.odQTY*p.pPrice) as GiaTien
from `order` o  
join orderdetail od on o.oId = od.oId
join product p on od.pId = p.pId
group by o.oId, o.oDate;
