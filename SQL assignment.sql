--  create database assignment;

USE assignment;

--QUESTION 1: Write a query that delivers the names of all employees who work in the same department as the employee with the highest salary.
create table employees(employee_id int identity(1,1) primary key, employee_name varchar(255), department_id int, salary int); 
insert into employees(employee_name, department_id, salary) values('John Doe', 1, 100000),('Jane Smith', 1, 95000),('Alice Brown', 2, 120000),('Bob Johnson', 2, 110000),('Charlie Black', 3, 80000);
select employee_name from employees where department_id = (select department_id from employees where salary = (select max(salary) from employees));
-- select * from employees;

--QUESTION 2: Write a query to calculate the 7-day moving average of sales for each product in a given range using SQL window functions.
create table sales(sale_id int identity(1,1) primary key, product_id int, sale_date date, sales_amount int);
insert into sales(product_id, sale_date, sales_amount) values(1, '2023-06-01', 100),(1, '2023-06-02', 150), (1, '2023-06-03', 200),(1, '2023-06-04', 250),(2, '2023-06-01', 300),(2, '2023-06-02', 350),(2, '2023-06-03', 400),(2, '2023-06-04', 450);
SELECT product_id, sale_date, sales_amount, AVG(sales_amount) OVER (PARTITION BY product_id ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS MovingAvg7Days FROM Sales ORDER BY product_id, sale_date;
-- select * from sales;

 --QUESTION 3: Write a query to find the names of any customers who have made a purchase in all categories.
--  create customers table
create table customers (customer_id int PRIMARY KEY,customer_name VARCHAR(50));
insert into customers (customer_id, customer_name) VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie');
create table categories (category_id int PRIMARY KEY, category_name VARCHAR(50));
insert into categories (category_id, category_name) VALUES (1, 'Electronics'), (2, 'Clothing'), (3, 'Groceries');
create table purchases (purchase_id int PRIMARY KEY,customer_id int,category_id int, FOREIGN KEY (customer_id) REFERENCES customers(customer_id), FOREIGN KEY (category_id) REFERENCES categories(category_id));
insert into purchases (purchase_id, customer_id, category_id) VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 1, 3),
    (4, 2, 1),
    (5, 2, 2);
select cus.customer_id, cus.customer_name from customers cus inner join purchases pur on cus.customer_id = pur.customer_id inner join categories cat on pur.category_id = cat.category_id group by cus.customer_id, cus.customer_name having count(distinct pur.category_id) = (select count(*) from categories);
-- select * from categories;

-- QUESTION 4: Write a query that retrieves products with the same name but different prices.
 create table products(product_id int identity(1,1) primary key, product_name varchar(255), price int);
insert into products (product_name, price) values('Laptop', 1000),('Laptop', 1200), ('Phone', 800), ('tablet' ,600), ('tablet',	650);
 
SELECT p1.product_id, p1.product_name, p1.price AS price1, p2.product_id AS product_id2, p2.price AS price2
FROM products p1
JOIN products p2 ON p1.product_name = p2.product_name
WHERE p1.product_id < p2.product_id
AND p1.price <> p2.price;
-- select * from products;

-- QUESTION 5: Write a query that delivers the second-highest salary in an "employees" table.
select emp.employee_name from employees emp order by emp.salary desc offset 1 row fetch next 1 row only;
-- select * from employees;

-- Question 6: Write a query that delivers the total sales for each customer in a database, including any with no sales.
 create table sales2(sale_id int identity(1,1) primary key, customer_id int, sale_amount int, FOREIGN KEY (customer_id) REFERENCES customers(customer_id));
insert into sales2(customer_id,sale_amount) values(1,500),(1,300),(2,400),(2,200);
select cus.customer_id, cus.customer_name, SUM(s.sale_amount) as total_sales from customers cus join sales2 s on cus.customer_id = s.customer_id group by cus.customer_id, cus.customer_name;
select * from sales2;

-- Question 7: Write a query that delivers the name of any department with more than five employees, along with the average salary of these employees.
 create table employees2(employee_id int identity(1,1) primary key, employee_name varchar(255), department_id int, salary int);
insert into employees2(employee_name, department_id, salary) values('John Doe',	1, 100000), ('Jane Smith', 1,95000),('Alice Brown',	1,90000),('Bob Johnson',1,85000),('Charlie Black',1,80000),('David Green',1,75000),('Eve White',2,110000);
SELECT d.department_id,
       COUNT(e.employee_id) AS num_employees,
       AVG(CONVERT(decimal(10,2), e.salary)) AS avg_salary
FROM employees2 e
JOIN (
    SELECT department_id
    FROM employees2
    GROUP BY department_id
    HAVING COUNT(employee_id) > 5
) d ON e.department_id = d.department_id
GROUP BY d.department_id;

select * from employees2;

--Question 8: Write a query that delivers a list of employees without an assigned manager.
 create table employees3(employee_id int identity(1,1) primary key, employee_name varchar(255), manager_id int);
insert into employees3(employee_name, manager_id) values('John Doe', NULL),('Jane Smith',1),('Alice Brown',1),('Bob Johnson',2),('Charlie Black', NULL);
select employee_name from employees3 where manager_id is null;
select * from employees3;

-- Question 9: You have a SQL database table named "orders", with columns "order_id", "customer_id", and "order_date". Write a query to update the order date for order number 2045 to "2023-07-23" and save the changes permanently to the database with the COMMIT function.
 create table orders(order_id int primary key, customer_id int, order_date date);
insert into orders(order_id,customer_id,order_date) values(2043,1,'2023-06-01'),(2044,2,'2023-06-02'),(2045,3,'2023-06-03'),(2046,1,'2023-06-04');
BEGIN TRANSACTION;
UPDATE orders SET order_date = '2023-07-23' WHERE order_id = 2045;
COMMIT TRANSACTION;
 select * from orders;