create database HR_ANALYTICS; 

use hr_analytics;
select * from hr_analytics.hr_1;
select * from hr_analytics.hr_2;

create table HR_3 as
select * from hr_1 
join hr_2 
on hr_1.EmployeeNumber = hr_2.`Employee ID`;

Select * From HR_3;
----------------------------#Total Employee --------------------------------------
select sum(EmployeeCount) from HR_3;
----------------------------# Attrition ------------------------------------------
select count(Attrition) from HR_3
where Attrition = 'Yes';
----------------------------#Attrition Rate --------------------------------------
select round(((select count(Attrition) from hr_3 where Attrition = 'Yes')/
sum(EmployeeCount))* 100,2) from hr_3; 

----------------------------#Attrition Rate by Department--------------------------
select Department,
round((sum(case when Attrition = 'Yes' then 1 else 0 end)/sum(EmployeeCount))*100,2) as Attrition_Rate
From hr_3
group by Department
order by Attrition_Rate asc;

----------------------------#Average Hourly rate of Job Roles-----------------------
select JobRole,
avg(case when Gender = 'Male' then HourlyRate else null end) as Average_Hourly_Rate_Male,
avg(case when Gender = 'Female' then HourlyRate else null end) as Average_Hourly_Rate_Female
from hr_3
group by JobRole;

----------------------------#Attrition Rate Vs Monthly Income------------------------

select concat(GroupStart, ' to ', GroupEnd) as IncomeGroup,
round((sum(case when Attrition = 'Yes' then 1 else 0 end)/Sum(EmployeeCount))*100,2) as Attrition_Rate
from (
select*,
 floor((MonthlyIncome-1)/10000)*10000 + 1 as GroupStart,
 floor((MonthlyIncome-1)/10000)*10000 + 10000 as GroupEnd
from hr_3) as Income_Groups
group by IncomeGroup;

----------------------------------#Average Working Years in Each Department--------------------------------

select Department,
round(sum(TotalWorkingYears)/count(TotalWorkingYears),2) as Average_Working_Years
from hr_3
group by Department
order by Average_Working_Years asc;


---------------------------------#Job Role Vs Work Life Balance--------------------------------------------
select JobRole,
sum(case when WorkLifeBalance = 1 then 1 else 0 end) as Poor, 
sum(case when WorkLifeBalance = 2 then 1 else 0 end) as Average,
sum(case when WorkLifeBalance = 3 then 1 else 0 end) as Good,
sum(case when WorkLifeBalance = 4 then 1 else 0 end) as Excellent
from hr_3
group by JobRole;

----------------------------#Attrition Vs Years Since Last Promotion------------------------------------
select CONCAT(GroupStart, '-', GroupEnd) as YearsSinceLastPromotionGroup,
       round((SUM(case when Attrition = 'Yes' then 1 else 0 end) / COUNT(*)) * 100,2) as Attrition_Rate
from (
    select *,
           (floor((YearsSinceLastPromotion - 1) / 10) * 10) + 1 as GroupStart,
           (floor((YearsSinceLastPromotion - 1) / 10) * 10) + 10 as GroupEnd
    from hr_3
) as PromotionGroups
group by YearsSinceLastPromotionGroup;



