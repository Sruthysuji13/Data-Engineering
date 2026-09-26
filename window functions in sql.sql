-- 1. CREATE DATABASE hrdb
create database if not exists hrdb;
use hrdb;

-- 2. Show records
select * from hr_employee_data;

-- 4. Find all employee having monthly income greater than average employee income.
select * from hr_employee_data where `monthly income` > (SELECT AVG( `monthly income`) from hr_employee_data);

-- 5. Find all employee having monthly income equal to maximum monthly income
select * from hr_employee_data where  `monthly income` = (SELECT max( `monthly income`) from hr_employee_data);
-- 6.show summary of  hr employee dataset
SELECT 
    COUNT(*) AS total_employee,
    COUNT(DISTINCT department) AS total_department,
    COUNT(DISTINCT `job role`) AS total_jobrole,
    SUM( `monthly income`) AS overall_ctc,
    MIN( `monthly income`) AS min_salary,
    MAX( `monthly income`) AS max_salary
FROM hr_employee_data;

-- 7.cumulative sum of total working years by each department
select department,sum(`total working years` ) from hr_employee_data group by department;
 -- over()
 SELECT 
    employee number,
    department,
    `total working years`,
    SUM(`total working years`) OVER (
        PARTITION BY department 
        ORDER BY `employee number`
    ) AS cumulative_working_year
FROM hr_employee_data;

 
-- 8. Window Function - RANK()
-- Find Rank of Each Employee foreach Job
-- Role and ranked by Monthly Income.
SELECT Employee Number, Department,
`Total Working Years`, `Job Role`,
`Monthly Income`, `Marital Status`,
RANK()
OVER(partition by `Job Role` ORDER BY
`Monthly Income` DESC) AS Employee_RANK
from hr_employee_data;

-- 9. Window Function - DENSERANK()
SELECT Employee Number, Department,
`Total Working Years`, `Job Role`,
`Monthly Income`, `Marital Status`,
DENSE_RANK()
OVER(partition by `Job Role` ORDER BY
`Monthly Income` DESC) AS Employee_RANK
from hr_employee_data;

-- 10. WINDOW FN ROW_NUMBER()
-- Assign unique number to each employee for each job role.
-- based on employee number and years at the company
select `Employee Number`,`Job Role`,`Monthly Income`,`Years At Company`, ROW_NUMBER() OVER(partition by `Job Role` ORDER BY `Employee Number`ASC) AS Unique_Emp_no
	from hr_employee_data;
-- 11. based on years at company ,use row_number to categorise
select `Employee Number`,`Job Role`,`Monthly Income`,`Years At Company`, ROW_NUMBER() OVER(partition by `Job Role` ORDER BY `Years At Company`DESC) AS Unique_Emp_no_on_exp
	from hr_employee_data;
-- 12. WINDOW FUNCTION LEAD()
-- write an sql query to each employee monthly income with best monthly income
select `Employee Number`,`Job Role`,`Monthly Income`,`Years At Company`,LEAD(`Monthly Income`) OVER(ORDER BY `Employee Number`) AS next_employee_income
	from hr_employee_data;
-- 13 WINDOW FUNCTION LAG()
select `Employee Number`,`Job Role`,`Monthly Income`,`Years At Company`,LAG(`Monthly Income`) OVER(ORDER BY `Employee Number`) AS prev_employee_income
	from hr_employee_data;
-- 14. NTILE() WINDOW FUNCTION
-- divide employees into 4 equal buckets based on their years of experience within each job role.
select `Employee Number`,`Job Role`,`Monthly Income`,`Years At Company`,`Total Working Years`,NTILE(4) OVER(PARTITION BY `Job Role`ORDER BY `Total Working Years`) AS buckets_values
	from hr_employee_data;
-- 15. PERCENTILE_RANK()
-- Calculate percentile rank based on employees salary hike
select `Employee Number`,`Job Role`,`Monthly Income`,`Years At Company`,`Total Working Years`,`Percent salary hike`,percent_rank() OVER(ORDER BY `Percent salary hike`) AS salary_percent_rank
	from hr_employee_data;

-- 16. NTH_VALUE()
-- Get the second highest exprienced employee from each job role
select `Employee Number`,`Job Role`,`Monthly Income`,`Years At Company`,`Total Working Years`,`Percent salary hike`,nth_value(`Total Working Years`,2) OVER( partition by `Job Role` order BY `Total Working Years` DESC) AS second_highest_exp_emp
	from hr_employee_data;

-- 17. write a query to compare current employee income with nxt emp income in each job role. find the difference in incomes . check for rise or drop
select `Employee Number`,`Job Role`,`Monthly Income`,`Years At Company`,LEAD(`Monthly Income`) OVER(ORDER BY `Employee Number`) AS next_employee_income ,
(`monthly income` - Lead(`Monthly Income`) OVER(order by`Employee Number`)) AS differences
    from hr_employee_data; 
    
    
