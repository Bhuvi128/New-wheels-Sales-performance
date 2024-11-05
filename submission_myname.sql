/*

-----------------------------------------------------------------------------------------------------------------------------------
													    Guidelines
-----------------------------------------------------------------------------------------------------------------------------------

The provided document is a guide for the project. Follow the instructions and take the necessary steps to finish
the project in the SQL file			

-----------------------------------------------------------------------------------------------------------------------------------
                                                         Queries
                                               
-----------------------------------------------------------------------------------------------------------------------------------*/
  
/*-- QUESTIONS RELATED TO CUSTOMERS
     [Q1] What is the distribution of customers across states?
     Hint: For each state, count the number of customers.*/

select * from customer_t;
select state, count(customer_id) dist_cust from customer_t
group by state;

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q2] What is the average rating in each quarter?
-- Very Bad is 1, Bad is 2, Okay is 3, Good is 4, Very Good is 5.
*/
use vehdb;

select * from order_t;
select quarter_number, avg(if(customer_feedback = 'very bad',1,if(customer_feedback = 'bad',2,if(customer_feedback = 'okay',3,
if(customer_feedback = 'good',4,5))))) as avg_rating from order_t
group by quarter_number
order by quarter_number;

-- (or)

select quarter_number, avg(
    case
    when customer_feedback = 'very bad' then 1
    when customer_feedback = 'bad' then 2
    when customer_feedback = 'okay' then 3
    when customer_feedback = 'good' then 4
    when customer_feedback = 'very good' then 5
    end
) as avg_rating
from order_t
group by quarter_number
order by quarter_number;





-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q3] Are customers getting more dissatisfied over time?

Hint: Need the percentage of different types of customer feedback in each quarter. 
	  determine the number of customer feedback in each category as well as the total number of customer feedback in each quarter.
	  And find out the percentage of different types of customer feedback in each quarter.
      Eg: (total number of very good feedback/total customer feedback)* 100 gives you the percentage of very good feedback.
 */     


select * from order_t;

select quarter_number,
count(case when customer_feedback = 'Very bad' then 1 end) as very_bad_count,
count(case when customer_feedback = 'bad' then 2 end) as bad_count,
count(case when customer_feedback = 'okay' then 3 end) as okay_count,
count(case when customer_feedback = 'good' then 4 end) as good_count,
count(case when customer_feedback = 'Very good' then 5 end) as very_good_count,
count(*) as total_feedback,
round((count(case when customer_feedback = 'Very bad' then 1 end)/count(*)) * 100,2) as very_bad_percentage,
round((count(case when customer_feedback = 'bad' then 2 end)/count(*)) * 100,2) as bad_percentage,
round((count(case when customer_feedback = 'okay' then 3 end)/count(*)) * 100,2) as okay_percentage,
round((count(case when customer_feedback = 'good' then 4 end)/count(*)) * 100,2) as good_percentage,
round((count(case when customer_feedback = 'very good' then 5 end)/count(*)) * 100,2) as very_good_percentage
from order_t
group by quarter_number
order by quarter_number;

/*Insights:
As per customer feedback and quarter, there is increase in both very bad and bad percentage for each quarter.
It seems customers getting more dissatisfied over time
*/






-- ---------------------------------------------------------------------------------------------------------------------------------

/*[Q4] Which are the top 5 vehicle makers preferred by the customer.

Hint: For each vehicle make what is the count of the customers.*/

select vehicle_maker,count(c.customer_id) cnt_cust from product_t p 
join order_t o on p.product_id = o.product_id
join customer_t c on o.customer_id = c.customer_id 
group by vehicle_maker
order by cnt_cust desc limit 5;



-- ---------------------------------------------------------------------------------------------------------------------------------

/*[Q5] What is the most preferred vehicle make in each state?*/

select c.state,vehicle_maker,count(c.customer_id) cnt_cust from product_t p 
join order_t o on p.product_id = o.product_id
join customer_t c on o.customer_id = c.customer_id 
group by c.state,vehicle_maker
order by cnt_cust desc;


-- ---------------------------------------------------------------------------------------------------------------------------------

/*QUESTIONS RELATED TO REVENUE and ORDERS 

-- [Q6] What is the trend of number of orders by quarters?

Hint: Count the number of orders for each quarter.*/

select quarter_number, count(order_id) order_count from order_t
group by quarter_number
order by quarter_number;


-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q7] What is the quarter over quarter % change in revenue? 

Hint: Quarter over Quarter percentage change in revenue means what is the change in revenue from the subsequent quarter to the previous quarter in percentage.
      
*/
      
select * from order_t;


with revenue_per_quarter as(
select quarter_number, sum(vehicle_price) as total_revenue
from order_t
group by quarter_number
order by quarter_number)
select quarter_number,total_revenue,
lag(total_revenue) over(order by quarter_number) as previous_quarter_revenue,
round(
   (total_revenue - lag(total_revenue) over(order by quarter_number)) / lag(total_revenue) over(order by quarter_number) *100,2
) as revenue_change_percentage
from revenue_per_quarter
order by quarter_number;


      

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q8] What is the trend of revenue and orders by quarters?

Hint: Find out the sum of revenue and count the number of orders for each quarter.*/

select quarter_number,sum(vehicle_price) total_revenue,count(order_id) order_count from order_t
group by quarter_number
order by quarter_number;




-- ---------------------------------------------------------------------------------------------------------------------------------

/* QUESTIONS RELATED TO SHIPPING 
    [Q9] What is the average discount offered for different types of credit cards?

Hint: Find out the average of discount for each credit card type.*/

select credit_card_type, avg(discount) avg_discount from customer_t c 
join order_t o using(customer_id)
group by credit_card_type;

-- ---------------------------------------------------------------------------------------------------------------------------------

/* [Q10] What is the average time taken to ship the placed orders for each quarters?
	Hint: Use the dateiff function to find the difference between the ship date and the order date.
*/

select quarter_number, avg(datediff(ship_date,order_date)) avg_ship_ordertime_taken from order_t
group by quarter_number
order by quarter_number;



-- --------------------------------------------------------Done----------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------



