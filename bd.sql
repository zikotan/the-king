-----les tables de pl/sql

create table ITEMS
(
 itemno   number(5)   constraint items_pk  primary key,
 itemname varchar2(20),
 rate     number(8,2) constraint items_rate_chk check( rate >= 0),
 taxrate  number(4,2) default 0
);

insert into items values(1,'Samsung 14" monitor',7000,10.5);
insert into items values(2,'TVS Gold Keyboard',1000,10);
insert into items values(3,'Segate HDD 20GB',6500,12.5);
insert into items values(4,'PIII processor',8000,8);
insert into items values(5,'Logitech Mouse',500,5);
insert into items values(6,'Creative MMK',4500,11.5);


---------------------------------------------------------------------------------------------------
create table CUSTOMERS
(
 custno    number(5)    constraint customers_pk  primary key,
 custname  varchar2(20) constraint customers_custname_nn not null,
 address1  varchar2(50),
 address2  varchar2(50),
 city      varchar2(30),
 state     varchar2(30),
 pin       varchar2(10),
 phone     varchar2(30)
);



insert into customers values(101,'Raul','12-22-29','Dwarakanagar', 'Vizag','AP','530016','453343,634333');
insert into customers values(102,'Denilson','43-22-22','CBM Compound', 'Vizag','AP','530012','744545');
insert into customers values(103,'Mendiator','45-45-52','Abid Nagar', 'Vizag','AP','530016','567434');
insert into customers values(104,'Figo','33-34-56','Muralinagar', 'Vizag','AP','530021','875655,876563,872222');
insert into customers values(105,'Zidane','23-22-56','LB Colony', 'Vizag','AP','530013','765533');
--Plus
insert into customers values(106,'cust1','45-45-52','Abid Nagar', 'Vizag','AP','530016','567434');
insert into customers values(107,'cust2','33-34-56','Muralinagar', 'Vizag','AP','530021','875655,876563,872222');
insert into customers values(108,'cust3','23-22-56','LB Colony', 'Vizag','AP','530013','765533');



----------------------------------------------------------------------------------------------------
create table ORDERS
(
 ordno     number(5)  constraint orders_pk  primary key,
 orddate   date,
 shipdate  date,
 custno    number(5) constraint orders_custno_pk references customers,
 address1  varchar2(50),
 address2  varchar2(50),
 city      varchar2(30),
 state     varchar2(30),
 pin       varchar2(10),
 phone     varchar2(30),
 constraint order_dates_chk  check( orddate <= shipdate)
);


insert into orders values(1001,to_date('15-05-2001','DD-MM-YYYY'),to_date('10-6-2001','DD-MM-YYYY'),102,'43-22-22','CBM Compound','Vizag','AP','530012','744545');

insert into orders values(1002,to_date('15-05-2001','DD-MM-YYYY'),to_date('5-6-2001','DD-MM-YYYY'),101, '12-22-29','Dwarakanagar','Vizag','AP','530016','453343,634333');

insert into orders values(1003,to_date('17-05-2001','DD-MM-YYYY'),to_date('7-6-2001','DD-MM-YYYY'),101, '12-22-29','Dwarakanagar','Vizag','AP','530016','453343,634333');

insert into orders values(1004,to_date('18-05-2001','DD-MM-YYYY'),to_date('17-6-2001','DD-MM-YYYY'),103,'45-45-52','Abid Nagar', 'Vizag','AP','530016','567434');

insert into orders values(1005,to_date('20-05-2001','DD-MM-YYYY'),to_date('3-6-2001','DD-MM-YYYY'),104,'33-34-56','Muralinagar','Vizag','AP','530021','875655,876563,872222');

insert into orders values(1006,to_date('23-05-2001','DD-MM-YYYY'),to_date('11-6-2001','DD-MM-YYYY'),104,'54-22-12','MVP Colony','Vizag','AP','530024',null);
--Plus
insert into orders values(1008,to_date('23-05-2001','DD-MM-YYYY'),to_date('11-6-2001','DD-MM-YYYY'),105,'54-22-12','MVP Colony','Vizag','AP','530024',null);
insert into orders values(1010,to_date('23-05-2001','DD-MM-YYYY'),to_date('11-6-2001','DD-MM-YYYY'),106,'54-22-12','MVP Colony','Vizag','AP','530024',null);

----------------------------------------------------------------------------------------------------------
create table LINEITEMS
(
 ordno   number(5)   constraint LINEITEMS_ORDNO_FK references ORDERS,
 itemno  number(5)   constraint LINEITEMS_itemno_FK references ITEMS,
 qty     number(3)   constraint LINEITEMS_qty_CHK CHECK( qty >= 1),
 price   number(8,2),
 disrate number(4,2) default 0  constraint LINEITEMS_DISRATE_CHK CHECK( disrate >= 0),
 constraint lineitems_pk primary key (ordno,itemno)
);


insert into lineitems values(1001,2,3,1000,10.0);
insert into lineitems values(1001,1,3,7000,15.0);
insert into lineitems values(1001,4,2,8000,10.0);
insert into lineitems values(1001,6,1,4500,10.0);

insert into lineitems values(1002,6,4,4500,20.0);
insert into lineitems values(1002,4,2,8000,15.0);
insert into lineitems values(1002,5,2,600,10.0);

insert into lineitems values(1003,5,10,500,0.0);
insert into lineitems values(1003,6,2,4750,5.0);

insert into lineitems values(1004,1,1,7000,10.0);

insert into lineitems values(1004,3,2,6500,10.0);
insert into lineitems values(1004,4,1,8000,20.0);

insert into lineitems values(1005,6,1,4600,10.0);
insert into lineitems values(1005,2,2,900,10.0);

insert into lineitems values(1006,2,10,950,20.0);
insert into lineitems values(1006,4,5,7800,10.0);
insert into lineitems values(1006,3,5,6600,15.0);
--Plus
insert into lineitems values(1008,3,5,6600,15.0);
insert into lineitems values(1010,3,5,6600,15.0);

