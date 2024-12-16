## Emp_Dept Case study

CREATE DATABASE project1;

USE project1;

#Q1 Create table Employees
CREATE TABLE Employees (
    empno INT NOT NULL PRIMARY KEY,
    ename VARCHAR(30),
    job VARCHAR(30) DEFAULT 'Clerk',
    mgr INT,
    hiredate DATE,
    sal DECIMAL(10, 2) NOT NULL CHECK (sal > 0),
    comm DECIMAL(10,2),
    deptno INT
);

#DROP table Employees;

insert into Employees values (7369, "SMITH", "CLERK", 7902, "1890-12-17", 800, NULL, 20 ),
			(7499, "ALLEN","SALESMAN",7698,"1981-02-20",1600,300,30),
            (7521,"WARD","SALESMAN",7698,"1981-02-22",1250,500,30),
            (7566,"JONES","MANAGER",7839,"1981-04-02",2975,NULL,20); 
            
insert into Employees values (7654,"MARTIN","SALESMAN",7698,"1981-09-28",1250,1400,30),
			(7698,"BLAKE","MANAGER",7839,"1981-05-01",2850, NULL,30),
            (7782,"CLARK","MANAGER",7839,"1981-06-09",2450, NULL,10),
            (7788,"SCOTT","ANALYST",7566,"1987-04-19",3000, NULL,20);
            
insert into Employees values (7839,"KING","PRESIDENT",NULL,"1981-11-17",5000, NULL,10),
			(7844,"TURNER","SALESMAN",7698,"1981-09-08",1500,0,30),
            (7876,"ADAMS","CLERK",7788,"1987-05-23",1100, NULL, 20),
            (7900,"JAMES","CLERK",7698,"1981-12-03",950, NULL, 30);
            
insert into Employees values (7902,"FORD","ANALYST",7566,"1981-12-03",3000, NULL, 20),
			(7934,"MILLER","CLERK",7782,"1982-01-23",1300, NULL, 10);
            
SELECT * FROM Employees;

#Q2 Create table Dept
CREATE TABLE DEPT(
	deptno INT NOT NULL PRIMARY KEY,
    dname VARCHAR(30),
    loc VARCHAR(30)
);

INSERT INTO DEPT VALUES (10,"OPERATIONS","BOSTON"),
			(20,"RESEARCH","DALLAS"),
            (30,"SALES","CHICAGO"),
            (40,"ACCOUNTING","NEW YORK");

SELECT * FROM DEPT;

ALTER TABLE Employees
ADD CONSTRAINT fk_deptno
FOREIGN KEY (deptno) REFERENCES DEPT(deptno);

#Q3	List the Names and salary of the employee whose salary is greater than 1000
SELECT ename, sal FROM Employees WHERE sal > 1000;

#Q4	List the details of the employees who have joined before end of September 81.
SELECT * FROM Employees WHERE hiredate < "1981-09-01";

#Q5	List Employee Names having I as second character
SELECT ename FROM Employees WHERE ename LIKE '_i%';

#Q6 List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns
SELECT ename AS Employee_Name,
		sal AS Salary, 
		sal*0.4 AS Allowances, 
        sal*0.1 AS PF, 
        (sal + (sal*0.40) - (sal*0.10)) AS Net_Salary FROM Employees;
        
#Q7 List Employee Names with designations who does not report to anybody
SELECT ename FROM Employees WHERE mgr IS NULL;

#Q8 List Empno, Ename and Salary in the ascending order of salary
SELECT empno, ename, sal FROM Employees ORDER BY sal;

#Q9 How many jobs are available in the Organization ?
SELECT COUNT(DISTINCT job) AS NoOfJobs FROM Employees;

#Q10 Determine total payable salary of salesman category
SELECT SUM(sal) AS TotalSalary FROM Employees WHERE job = "SALESMAN";

#Q11 List average monthly salary for each job within each department
SELECT deptno, job, AVG(sal) AS average_sal FROM Employees GROUP BY deptno, job;
 
 #Q12 Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working
 SELECT e.ename AS EMPNAME, e.sal AS SALARY, d.dname AS DEPTNAME FROM Employees e
	JOIN DEPT d ON e.deptno = d.deptno;
    
#Q13 Create table Job Grades
CREATE TABLE JobGrades (
	grade CHAR,
    lowest_sal INT,
    highest_sal INT
);

INSERT INTO JobGrades VALUES ("A",0,999),
			("B",1000,1999),
            ("C",2000,2999),
            ("D",3000,3999),
            ("E",4000,5000);
            
SELECT * FROM JobGrades;

#Q14 Display the last name, salary and  Corresponding Grade
SELECT e.ename AS last_name, e.sal AS salary, j.grade AS Grade FROM Employees e
	JOIN JobGrades j ON e.sal BETWEEN j.lowest_sal AND j.highest_sal;
    
#Q15 Display the Emp name and the Manager name under whom the Employee works in the below format.
# Emp Report to Mgr

SELECT e.ename AS EMPNAME, m.ename AS MANAGERNAME, 
	CONCAT(e.ename, " Report to ", m.ename) as REPORT
    FROM Employees e
    JOIN Employees m ON e.mgr = m.empno;
    
#Q16 Display Empname and Total sal where Total Sal (sal + Comm)
SELECT ename AS Empname, (sal+ COALESCE(comm,0) ) AS TotalSal FROM Employees;

#Q17 Display Empname and Sal whose empno is a odd number
SELECT ename AS Empname, sal FROM Employees WHERE MOD(empno, 2) = 1;

#Q18 Display Empname , Rank of sal in Organisation , Rank of Sal in their department
SELECT ename, sal,
    RANK() OVER (ORDER BY sal DESC) AS org_rank,
    RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS dept_rank
	FROM Employees;
    
#Q19 Display Top 3 Empnames based on their Salary
SELECT ename AS EMPNAME, sal FROM Employees 
	ORDER BY sal DESC LIMIT 3;
    
#Q20 Display Empname who has highest Salary in Each Department.
SELECT e.ename AS EMPNAME, e.sal, e.deptno FROM Employees e
	WHERE  e.sal = (
        SELECT MAX(sal) FROM Employees
        WHERE deptno = e.deptno
    );
    
    
## ORDERS,CUST,SALESPEOPLE

#Q1 Create table Salespeople
CREATE TABLE Salespeople (
	snum INT PRIMARY KEY,
    sname VARCHAR(30),
    city VARCHAR(30),
    comm DECIMAL(5,2)
);

INSERT INTO Salespeople VALUES (1001, "Peel","London",0.12),
		(1002,"Serres","San Jose",0.13),
        (1003,"Axelrod","New york",0.10),
        (1004,"Motika","London",0.11),
        (1007,"Rafkin","Barcelona",0.15);
	
SELECT * FROM Salespeople;

#Q2 Create table Cust
CREATE TABLE CUST(
	cnum INT PRIMARY KEY,
    cname VARCHAR(30),
    city VARCHAR(30),
    rating INT,
    snum INT,
    FOREIGN KEY (snum) REFERENCES Salespeople(snum)
);

INSERT INTO Cust VALUES (2001,"Hoffman","London",100,1001),
		(2002,"Giovanne","Rome",200,1003),
        (2003, "Liu","San Jose",300,1002),
        (2004,"Grass","Berlin",100,1002),
        (2006,"Clemens","London",300,1007),
        (2007,"Pereira","Rome",100,1004),
        (2008,"James","London",200,1007);

SELECT * FROM Cust;

#Q3 Create table Orders
CREATE TABLE ORDERS(
	onum INT PRIMARY KEY,
    amt DECIMAL(8,2),
    odate DATE,
    cnum INT,
    snum INT,
    FOREIGN KEY (snum) REFERENCES Salespeople(snum),
    FOREIGN KEY (cnum) REFERENCES Cust(cnum)
);

INSERT INTO ORDERS VALUES (3001,18.69,"1994-10-03",2008,1007),
		(3002,1900.10,"1994-10-03",2007,1004),
		(3003,767.19,"1994-10-03",2001,1001),
        (3005,5160.45,"1994-10-03",2003,1002),
        (3006,1098.16,"1994-10-04",2008,1007);
        
INSERT INTO ORDERS VALUES (3007,75.75,"1994-10-05",2004,1002),
		(3008,4723.00,"1994-10-05",2006,1001),
        (3009,1713.23,"1994-10-04",2002,1003),
        (3010,1309.95,"1994-10-06",2004,1002),
        (3011,9891.88,"1994-10-06",2006,1001);
        
SELECT * FROM ORDERS;

#Q4	Write a query to match the salespeople to the customers according to the city they are living.
SELECT 
    c.cname AS "Customer Name",
    s.sname AS "Salesperson Name",
    s.city AS "City"
FROM Cust c
JOIN Salespeople s ON c.city = s.city;

#Q5 Write a query to select the names of customers and the salespersons who are providing service to them
SELECT 
    c.cname AS "Customer Name",
    s.sname AS "Salesperson Name"
FROM Cust c
JOIN Salespeople s ON c.snum = s.snum;

#Q6	Write a query to find out all orders by customers not located in the same cities as that of their salespeople
SELECT o.onum, c.cname, c.cnum, o.snum
FROM orders o
JOIN Cust c ON o.cnum = c.cnum
JOIN Salespeople s ON o.snum = s.snum
WHERE c.city <> s.city;

#Q7 Write a query that lists each order number followed by name of customer who made that order
SELECT 
    c.cnum AS CustomerNumber,
    c.cname AS CustomerName,
    o.onum AS OrderNumber
FROM Orders o
JOIN Cust c ON o.cnum = c.cnum;

#Q8 Write a query that finds all pairs of customers having the same rating
SELECT 
	a.cname AS Customer1,
	b.cname AS Customer2,
	a.rating
FROM Cust a
JOIN Cust b ON a.rating = b.rating
WHERE a.cnum < b.cnum 
ORDER BY a.rating, Customer1, Customer2;

#Q9	Write a query to find out all pairs of customers served by a single salesperson
SELECT 
	a.cname AS Customer1,
    b.cname AS Customer2,
    a.snum AS SalespersonId,
    s.sname AS SalespersonName
FROM Cust a
JOIN 
	Cust b ON a.snum = b.snum AND 
    a.cnum < b.cnum
JOIN Salespeople s ON a.snum = s.snum
ORDER BY SalespersonId, Customer1, Customer2;

#Q10 Write a query that produces all pairs of salespeople who are living in same city
SELECT 
	a.snum AS Salesperson1,
    a.sname AS SalespersonName1,
    b.snum AS Salesperson2,
    b.sname AS SalespersonName2,
    a.city AS City
FROM Salespeople a
JOIN Salespeople b ON a.city = b.city AND a.snum < b.snum
ORDER BY City, Salesperson1, Salesperson2;

#Q11 Write a Query to find all orders credited to the same salesperson who services Customer 2008
SELECT o.onum, o.amt, o.odate, o.cnum
FROM Orders o
JOIN Cust c ON o.cnum = c.cnum
WHERE o.snum = (SELECT snum FROM Cust WHERE cnum = 2008);


#Q12 Write a Query to find out all orders that are greater than the average for Oct 4th
SELECT * FROM Orders
WHERE amt > (SELECT AVG(amt) FROM Orders
				WHERE odate = "1994-10-04");

#Q13 Write a Query to find all orders attributed to salespeople in London.
SELECT 
	o.onum AS OrderNumber,
    o.amt AS Amount,
    o.odate AS Orderdate,
    o.cnum AS CustomerNumber,
    o.snum AS SalespersonNumber
FROM orders o
JOIN Salespeople s ON o.snum = s.snum
WHERE s.city = 'London';

#Q14 Write a query to find all the customers whose cnum is 1000 above the snum of Serres.
SELECT c.cnum, c.cname 
FROM Cust c 
WHERE c.cnum > (SELECT s.snum + 1000 FROM salespeople s 
				WHERE s.sname = 'Serres');
    
#Q15 Write a query to count customers with ratings above San Jose’s average rating
SELECT COUNT(*) AS CustomerCount
FROM cust
WHERE rating > (SELECT AVG(rating) FROM cust WHERE city = 'San Jose');

#Q16 Write a query to show each salesperson with multiple customers.
SELECT s.snum AS SalespersonID,
		s.sname AS SalespersonName, 
        s.city AS City, 
        COUNT(c.cnum) AS CustomerCount
FROM Salespeople s
JOIN Cust c ON s.snum = c.snum
GROUP BY s.snum, s.sname, s.city, s.comm
HAVING COUNT(c.cnum) > 1;