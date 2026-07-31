create database QuanLyBanHang;

use QuanLyBanHang;

create table Customer(
	cId int primary key,
    cName varchar(50),
    cAge int
);

create table `Order`(
	oId int primary key,
    cId int,
    oDate datetime,
    oTotalPrice int,
    foreign key (cId) references Customer(cId)
);

create table Product(
	pId int primary key,
    pName varchar(50),
    pPrice int
);

create table OrderDetail(
	oId int,
    pId int,
    odQTY int,
    primary key (oId, pId),
    foreign key (oId) references `Order`(oId),
    foreign key (pId) references Product(pId)
);

