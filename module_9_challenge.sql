--DATA ENGINEERING

/*DROP TABLE departments;
DROP TABLE dept_emp;
DROP TABLE employees;
DROP TABLE dept_manager;
DROP TABLE salaries;
DROP TABLE titles*/

CREATE TABLE departments (
    dept_no varchar NOT NULL,
    dept_name varchar NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (dept_no)
);

CREATE TABLE dept_emp (
    emp_no int NOT NULL,
    dept_no varchar NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE dept_manager (
    dept_no varchar NOT NULL,
    emp_no int NOT NULL,
    CONSTRAINT pk_dept_manager PRIMARY KEY (dept_no,emp_no)
);

CREATE TABLE salaries (
    emp_no int NOT NULL,
    salary int NOT NULL,
    CONSTRAINT pk_salaries PRIMARY KEY (emp_no)
);

CREATE TABLE employees (
    emp_no int NOT NULL,
    emp_title_id varchar NOT NULL,
    birth_date date NOT NULL,
    first_name varchar NOT NULL,
    last_name varchar NOT NULL,
    sex varchar NOT NULL,
    hire_date date NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
    title_id varchar NOT NULL,
    title varchar NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (title_id)
);


ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);


--DATA ANALYSIS

--Q1
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e 
	JOIN salaries AS s 
		ON e.emp_no = s.emp_no;

--Q2
SELECT e.first_name, e.last_name, e.hire_date
FROM employees AS e
WHERE EXTRACT(YEAR FROM e.hire_date) = 1986;

--Q3
SELECT dm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM dept_manager AS dm

JOIN employees AS e
ON e.emp_no = dm.emp_no

JOIN departments AS d
ON dm.dept_no = d.dept_no;

--Q4
SELECT d.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name 
FROM departments AS d

JOIN dept_emp AS de
ON d.dept_no = de.dept_no 

JOIN employees AS e
ON de.emp_no = e.emp_no;
				
--Q5
SELECT e.first_name, e.last_name, e.sex
FROM employees AS e
WHERE first_name = 'Hercules' 
AND last_name LIKE 'B%';

--Q6
SELECT e.emp_no, e.last_name, e.first_name
FROM employees AS e
WHERE e.emp_no IN
	
	(SELECT de.emp_no 
	FROM dept_emp AS de
	WHERE de.dept_no = 
		(SELECT d.dept_no
		FROM departments AS d
		WHERE d.dept_name = 'Sales'));

--Q7
SELECT de.emp_no, e.last_name, e.first_name, d.dept_name 
FROM employees AS e

JOIN dept_emp AS de
ON e.emp_no = de.emp_no 

JOIN departments AS d
ON de.dept_no = d.dept_no 

WHERE d.dept_name = 'Sales' 
OR d.dept_name = 'Development';

--Q8
SELECT e.last_name, COUNT(e.last_name) AS last_name_count
FROM employees AS e

GROUP BY e.last_name

ORDER BY last_name DESC;
