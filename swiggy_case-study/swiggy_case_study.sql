
                                        --lets start the swiggy_case _study-- 

--these are all the tables here:

select * from dbo.users$
select * from orders$
select * from food$
select * from menu$
select * from restaurants$
select * from order_details$


--# find the name of customers who never ordered?

select name 
from dbo.users$
where user_id not in (select user_id from orders$);




--# find avg_price for each food?

select f.f_name,avg(price) as avg_price 
from menu$ as m inner join food$ as f 
on m.f_id = f.f_id 
group by f.f_name




--# find top restaurant in terms of number of orders for given  month?

select * from  orders$
select * , MONTH( date) AS month_num from orders$
  WHERE MONTH( date) = 6

  select  r.r_name ,count(*)as max_order 
  from orders$ as o
  inner join restaurants$ as r on 
  o.r_id = r.r_id
  WHERE MONTH( date) = 6
  group by o.r_id
  order by count(*) desc 
  limit 1
 



 --# restaurants with monthly sales >xvalues for particular month

 select * from  orders$
select * , MONTH( date) AS month_num from orders$
  
  select  r.r_name, sum(amount) as total_sale from orders$ as o
  join restaurants$ as r on 
  r.r_id = o.r_id
  WHERE MONTH( date) = 6
  group by r.r_name
  having sum(amount)>500




  --# show all the orders with orders detailes for particular customer for particular date range

  select  us.name, us.email, us.password,o.r_id, od.f_id, o.order_id, us.user_id, o.amount, o.date
  from order_details$ as od 
  join  orders$ as o
  on od.order_id = o.order_id
  join users$ as us
  on  us .user_id = o.user_id

  select * from order_details$
  select * from orders$




  --# lets find out all detailes for customer name Ankit for order between 10 june to 10 july

 select o.user_id, r.r_name , f.f_name ,  o.order_id ,o.date
 from orders$ as o 
 join restaurants$ as r on
 o.r_id = r.r_id
 join order_details$ as od on 
 o.order_id = od.order_id 
 join food$ as f on 
 f.f_id = od.f_id
where user_id= (select user_id  from users$ where name like 'ankit')
 and date  between '2022-06-10' and  '2022-07-10'




 --# find restaurants with max repeated customers 
 select r.r_name , count(*) as loyal_customer 
 from
 (select user_id , r_id , count(*) as visit 
 from orders$
 group by r_id , user_id 
 having count(*)>1)
 t
 join restaurants$  r 
 on r.r_id = t.r_id 
 group by t.r_id
 order by loyal_customer desc
 limit 1




 --# month over month revenue growth of swiggy

 

 SELECT month_num ,((revenue- previous)/previous)*100 as growth
(
        WITH sales as 
    (
      select MONTH( date) AS month_num ,sum(amount) as revenue
      from orders$
      group by  MONTH(date)
      order by MONTH(date)
     )
select  month_num , revenue , LAG(revenue,1) over(order by revenue) AS previous from sales;
)t