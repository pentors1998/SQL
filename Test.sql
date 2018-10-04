--1.	Show the branch number of all branches that locate in Aberdeen city or on Main Street.
select branchno
from branch
where city='Aberdeen' or street like '%Main Street%';

--2.	List the branches that are not in London
select *
from branch
where city = 'London';

--3.	Show clients, whose preferred property type are Flat, can rent the property maximum 400.
select *
from propertyforrent
where lower(type) = 'flat' and rent <= 400;

--4.	Show clients with phone number ending in 77.
select *
from client
where telno like '%77';

--5.	Show property number and the rent cost of the flat properties in Glasgow city with at least 3 and up to 4 rooms.
select propertyno, rent,rooms
from propertyforrent
where lower(type) = 'flat' and lower(city) = 'glasgow' and rooms >= 3 and rooms <= 4; 

--6.	Display the property number of properties with owner number is CO87 or owner number is CO40.
select ownerno
from privateowner
where ownerno =  'CO87' or ownerno = 'CO40';

--7.	Show properties that do not have staff number provide. 
select *
from propertyforrent
where staffno is Null;

--8.	Show the staffs with the position Manager and sort the staffs’ information in descending order of salary. 
select fname ||' '|| lname as Name , position
from staff
where lower(position) = 'manager'
ORDER BY salary desc;

--9.	Show the staff number, position and date of birth of staffs who have birthdate in June. The result should be arranged by birthdate in descending order. 
select fname ||' '|| lname as Name , staffno , position , dob
from staff
where dob like '%JUN%'
ORDER BY dob desc;

SELECT CLIENTNO,FNAME||' '||LNAME AS NAME
FROM client
WHERE SUBSTR (CLIENTNO,3,1) = '7';

SELECT clientno , propertyno , comments
FROM viewing
WHERE viewdate = '01-JUL-04' AND comments IS NOT NULL;

--1.	How many clients are there?
select count(*)
from client;

--2.	How many clients whose preferred property type are Flat?
select preftype, count(*)
from client
where lower(preftype) = 'flat'
GROUP BY preftype;

--3.	What is average rent for three-room flat?
select type , rooms ,AVG(rent)
from propertyforrent
where lower(type) = 'flat' and rooms = 3
group by type , rooms;

--4.	What are the number of staff and the minimum, maximum and average staff salary in each staff position?
select position,count(staffno) as "Number of staff", min(salary) , max(salary) , avg(salary)
from staff
GROUP BY position;

--5.	Which clients have viewed the properties more than one time?
select clientno , count(clientno)
from viewing
GROUP BY clientno
HAVING count(clientno) > 1;

--6.	How many properties are owned by each property owner?
select ownerno , count(ownerno)
from propertyforrent
group by ownerno;

--7.	Count the number of properties by staff number and type of property
select staffno , type , count(*)
from propertyforrent
GROUP BY staffno , type;

--8.	How many customers have registered in each branch? Show the branch number and the number of customers.
select branchno , count(clientno)
from registration
group by branchno;


--9.	Find out the total number of properties for rent by type of property.
select type , count(propertyno)
from propertyforrent
GROUP by type;

--10.	Find out the average rent of property for rent by city and by type of property.
select city , type , avg(rent) 
from propertyforrent
GROUP BY city , type;

--1.	List full details of all properties for rent along with owner’s name (first name and last name).
select po.fname ||' '|| po.lname as "Name"
from propertyforrent p join privateowner po on p.ownerno = po.ownerno;

--2.	List the staff number, first and last names and branch city of all staffs.
select s.staffno , s.fname ||' '|| s.lname as "Name", b.city
from staff s join branch b on s.branchno = b.branchno;

--3.	List the name of clients who have viewed the properties more than one time.
select c.fname ||' '|| c.lname as name , count(v.clientno) as "Viewed"
from client c join viewing v on c.clientno = v.clientno
group by c.fname ||' '|| c.lname 
having count(v.clientno) > 1;

--4.	List the number of properties handled by each staff member, along with the branch number of the member of staff
select s.staffno, b.branchno , count(propertyno) 
from propertyforrent p join staff s on  p.staffno = s.staffno
                       join branch b on s.branchno = b.branchno
group by s.staffno, b.branchno;

--5.	List the branch cities that staffs manage the properties that are house type. Remove the duplicate records.
select DISTINCT b.city
from branch b join staff s on b.branchno = s.branchno
              join propertyforrent p on s.staffno = p.staffno
where lower(p.type) = 'house';

--6.	List the client name and view date of all viewings on properties that are managed by staffs’ branch office in Glasgow.
select c.fname ||' '|| c.lname as "Name" , v.viewdate
from client c join viewing v on c.clientno = v.clientno
              join propertyforrent p on v.propertyno = p.propertyno
              join staff s on p.staffno = s.staffno
              join branch b on s.branchno = b.branchno
where lower(b.city) = 'glasgow';

--7.	List the name of owners whose properties locate in Glasgow and clients have viewed the properties of the same owner more than two times.
select po.fname ||' '|| po.lname as "Name" , count(c.clientno)
from privateowner po join propertyforrent p on po.ownerno = p.ownerno
                     join viewing v on p.propertyno = v.propertyno
                     join client c on v.clientno = c.clientno
where lower(p.city) = 'glasgow'
group by po.fname ||' '|| po.lname
having count(v.viewdate) > 2;

--8.	List full details of all properties for rent along with owner’s name (first name and last name).  
--Show only the properties that are managed by staffs in Branch No B003.
select p.* , po.fname ||' '|| po.lname as "Name"
from propertyforrent p join staff s on p.staffno = s.staffno
                       join privateowner po on p.ownerno = po.ownerno
where s.branchno = 'B003';

--**9.	How many properties are managed in each branch city?
select b.city,count(p.propertyno) as "Properties are managed"
from propertyforrent p join staff s on p.staffno = s.staffno
                       join branch b on s.branchno = b.branchno
group by b.city;

select b.city, count(p.propertyno) as "Properties are managed"
from branch b join staff s on b.branchno = s.branchno
        join propertyforrent p on p.staffno = p.staffno
group by b.city;

--1.	List all clients who have viewed a property. 
--Include clients who haven’t viewed any property. 
--The result should show the client number, first name, property number and view date.
select c.clientno , c.fname , v.propertyno , v.viewdate
from client c full join viewing v on c.clientno = v.clientno;

--2.	List all staffs who are not responsible to any property.
select s.*
from  staff s left join propertyforrent p on s.staffno = p.staffno
where p.staffno is null;

--3.	List all properties that are not viewed by any client and 
--the properties are managed by staffs who work in the branch located at 22 Deer Road street.
select p.*
from propertyforrent p left join viewing v on p.propertyno = v.propertyno
                            join staff s on p.staffno = s.staffno
                            join branch b on s.branchno = b.branchno
where b.street like '22%';

--4.	List all people in the Dream Home database. The result should show the person number, 
--first name and last name from the Staff, PrivateOwner, and Client tables.
select staffno as "Person Number", fname ||' '|| lname as name
from staff
UNION
select ownerno , fname ||' '|| lname as name
from privateowner
UNION
select clientno , fname ||' '|| lname as name
from client;

--5.	List the property number of properties that were never viewed by any clients
select propertyno
from propertyforrent
minus
select propertyno
from viewing;

--6.	List all cities where there is either a branch office or a property for rent (but not both)
select city
from branch
minus
select city
from propertyforrent;

--7.	List the full details of all private owners whose property was never viewed by clients. 
--(Hint: Use a join and a set operator) 
select p.propertyno , po.* 
from privateowner po join propertyforrent p on po.ownerno = p.ownerno
minus
select p.propertyno , po.*
from privateowner po join propertyforrent p on po.ownerno = p.ownerno
                     join viewing v on p.propertyno = v.propertyno;
                     
--1.	List staffs who manage properties with three rooms. 
select *
from staff
where staffno in(select staffno from propertyforrent where rooms=3);

--2.	List properties that owner’s telephone number starts with 012.
select *
from propertyforrent
where ownerno in(select ownerno from privateowner where telno like '012%');

--3.	List branches that do not have any staff.
select *
from branch
where branchno not in(select branchno from staff);

--4.	List staffs whose salary is less than the average salary of all staffs and 
--staffs who work in the branch located in Glasgow city.
select *
from staff
where salary <(select avg(salary) from staff) and branchno in(select branchno from branch where lower(city) = 'glasgow');

--5.	List staffs whose salary is greater than the salaries of all staffs who work at branch number B003.
select *
from staff
where salary > (select max(salary) from staff where branchno = 'B003');

--6.	List properties that are viewed by clients more than two times.
select *
from propertyforrent
where propertyno in(select propertyno from viewing group by propertyno having count(clientno) > 2);

--7.	List clients who registered in the branch at 163 Main Street.
select *
from registration
where branchno in(select branchno from branch where street like '%163%');

--8.	In each branch, list staffs whose salary is greater than the average salary in their branch.
select s.fname, s.branchno, s.salary, sub.avgsala
from staff s join (select branchno, avg(salary) as avgsala from staff group by branchno) sub on s.branchno = sub.branchno
where s.salary > sub.avgsala;


select s2.fname, s2.salary
from staff s1 cross join staff s2
where s1.fname = 'David' and s1.salary > s2.salary;

select s2.fname, s2.salary
from staff s1 cross join staff s2
where s1.fname = 'Julie' and s1.salary = s2.salary;


select fname,salary
from staff
where salary < (
select salary
from staff
where fname = 'David');

select staffno , Min(salary), Max(salary) , avg(salary) 
from staff
group by staffno ;

select clientno , count(clientno)
from VIEWING
GROUP BY clientno
HAVING count(clientno) > 1 ;

select Ownerno,count(ownerno)
from PROPERTYFORRENT
GROUP by OWNERNO;
-- 7.
select count(staffno) , count(DISTINCT type)
from PROPERTYFORRENT;
-- 8.
select branchno , count(clientno) , clientno
from REGISTRATION
GROUP BY BRANCHNO , CLIENTNO;
-- 9.
select type , sum(rent)
from PROPERTYFORRENT
GROUP BY type;
-- 10.
select city,type ,cast (avg(rent) as decimal(5,0)) as AVG
from PROPERTYFORRENT
GROUP BY city,type;


-------------------------------------------------------------
select c.fname , v.comments
from client c join viewing v on c.clientno = v.clientno
where v.comments is NOT NULL;
-- 
select s.staffno , s.fname , p.propertyno
from staff s join PROPERTYforrent p on s.staffno = p.staffno;
--
select s.fname, b.city, p.propertyno
from staff s join branch b on s.branchno = b.branchno
            join propertyforrent p on s.staffno = p.staffno;
--
select s.staffno , s.fname , count(p.propertyno)
from staff s join propertyforrent p on s.staffno = p.staffno
group by s.fname , s.staffno
order by count(p.propertyno) asc;
--
select s.fname , s.position , st.fname , st.position
from staff s cross join staff st
where s.fname = 'Mary' and s.position = st.position;
--SQL simple join 1
select pri.fname, prop.*
from privateowner pri join propertyforrent prop on pri.ownerno = prop.ownerno;
-- 2
select s.staffno , b.*
from staff s join branch b on s.branchno = b.branchno;
-- 3
select c.fname , count(v.propertyno)
from client c join viewing v on c.clientno = v.clientno
group by c.fname
having count(v.propertyno) > 1;
-- 4
select s.staffno , s.fname , count(p.propertyno) , count(b.branchno)
from propertyforrent p join staff s on p.staffno = s.staffno 
                        join branch b on b.branchno = s.branchno
group by s.staffno , s.fname , b.branchno;

