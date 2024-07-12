use world;

-- Total meeting count for 2019 and 2020 
select count(global_attendees) as count_2019,(select count(global_attendees) from meeting where right(meeting_date,4) = "2020") as count_2020
from meeting where right(meeting_date,4) = "2019";
 
-- No of count by account executive 
 select Excute_name as Executive_name,count(global_attendees) as No_of_count_by_executive
 from meeting group by excute_name;
 
-- total opportunity count 
select count(opportunity_name) as Total_opportunity_count from opportunity ;
  
-- total open opportunity count 
select count(opportunity_name) as Total_open_opportunity_count from opportunity 
where stage in ("Propose Solution","Qualify Opportunity");

--  top 4 for opportunity
select opportunity_name,revenue_amount from opportunity
order by revenue_amount desc limit 4;
 
-- top 4 for open opportunity
select opportunity_name as open_opportunity_name,revenue_amount from opportunity
where stage in ("Propose Solution","Qualify Opportunity")
order by revenue_amount desc limit 4;

-- stage by revenue
select stage,sum(revenue_amount) as revenue_amount from opportunity 
group by stage order by sum(revenue_amount) desc;

-- No of count for product_group
select product_group,count(opportunity_id) as No_of_product_group_count from opportunity
group by product_group order by count(opportunity_id) desc;

/*select (sum(b.Amount) + sum(f.Amount)) as cross_achi from 
brokerage as b left join fees as f  on 
b.accountID = f.accountID
where b.income_class = "Cross Sell";*/

-- cross_sell
SELECT CONCAT(FORMAT((SUM(amount) + (SELECT SUM(amount) FROM fees WHERE income_class = 'Cross Sell')) / 1000000, 2), 'm') AS cross_achieved,
CONCAT(FORMAT((SELECT SUM(amount) FROM invoice WHERE income_class = 'Cross Sell') / 1000000, 2), 'm') AS Cross_invoice,
CONCAT(FORMAT((SELECT SUM(cross_target) FROM target) / 1000000, 2), 'm') AS Cross_target FROM brokerage WHERE income_class = 'Cross Sell';

-- NEW
SELECT CONCAT(FORMAT((SUM(amount) + (SELECT SUM(amount) FROM fees WHERE income_class = 'New')) / 1000000, 2), 'm') AS New_achieved,
CONCAT(FORMAT((SELECT SUM(amount) FROM invoice WHERE income_class = 'New') / 1000000, 2), 'm') AS New_invoice,
CONCAT(FORMAT((SELECT SUM(new_target) FROM target) / 1000000, 2), 'm') AS New_target FROM brokerage 
WHERE income_class = 'New'; 

-- RENEWAL
SELECT CONCAT(FORMAT((SUM(amount) + (SELECT SUM(amount) FROM fees WHERE income_class = 'Renewal')) / 1000000, 2), 'm') AS Renewal_achieved,
CONCAT(FORMAT((SELECT SUM(amount) FROM invoice WHERE income_class = 'Renewal') / 1000000, 2), 'm') AS renewal_invoice,
CONCAT(FORMAT((SELECT SUM(renewal_target) FROM target) / 1000000, 2), 'm') AS renewal_target FROM brokerage WHERE income_class = 'Renewal';

-- No of invoice count for executive_name 
SELECT
   executive_name,
    SUM(CASE WHEN income_class = 'Cross Sell' THEN 1 ELSE 0 END) AS cross_count,
    SUM(CASE WHEN income_class = 'New' THEN 1 ELSE 0 END) AS new_count,
    SUM(CASE WHEN income_class = 'Renewal' THEN 1 ELSE 0 END) AS renewal_count
FROM invoice
GROUP BY executive_name;
use world;

-- cross_sell_plcd_achieved
select concat(round((SUM(amount) + (SELECT SUM(amount) FROM fees WHERE income_class = 'Cross Sell'))/(select sum(cross_target) from target )*100,2),"%")
as cross_sell_plcd_achieved from brokerage where income_class = "Cross Sell";

-- cross_sell_invoice_achieved
select concat(round((SELECT SUM(amount) FROM invoice WHERE income_class = 'Cross Sell')/(select sum(cross_target) from target )*100,2),"%")
as  cross_sell_invoice_achieved;

-- new sell plcd achieved
select concat(round((SUM(amount) + (SELECT SUM(amount) FROM fees WHERE income_class = 'New'))/(select sum(new_target) from target )*100,2),"%")
as new_sell_plcd_achieved from brokerage where income_class = "New";

--  new sell invoice achieved
select concat(round((SELECT SUM(amount) FROM invoice WHERE income_class = 'New')/(select sum(new_target) from target )*100,3),"%")
as  new_sell_invoice_achieved;

-- renewal sell plcd achieved
select concat(round((SUM(amount) + (SELECT SUM(amount) FROM fees WHERE income_class = 'Renewal'))/(select sum(renewal_target) from target )*100,2),"%")
as renewal_sell_plcd_achieved from brokerage where income_class = "Renewal";

--  renewal sell invoice achieved
select concat(round((SELECT SUM(amount) FROM invoice WHERE income_class = 'Renewal')/(select sum(renewal_target) from target )*100,2),"%")
as  renewal_sell_invoice_achieved;
