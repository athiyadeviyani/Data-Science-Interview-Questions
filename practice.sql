-- 1> Write a SQL query to find the nth highest salary from employee table. 
-- Example: finding 3rd highest salary from employee table
select * from employee 
order by salary desc limit 2, 1;

-- 2> Write a SQL query to find top n records?
-- Example: finding top 5 records from employee table by salary 
select * from employee 
order by salary desc limit 5;

-- 3> Write a SQL query to find the count of employees working in department 'Admin'
select count(employee_id)
from employee
where department = 'Admin';

-- 4> Write a SQL query to fetch department wise count employees sorted by department count in desc order.
select department, count(*)
from employee
group by department
order by count(*) desc;

-- 5>  Write a query to fetch only the first name(string before space) from the FullName column of user_name table.
select distinct(substring_index(full_names, ' ', 1)) as first_name 
from user_name;

-- 6> Write a SQL query to find all the employees from employee table who are also managers
select * from employee
where employee_id in (select manager_id from employee);

-- alternative
select e1.first_name, e2.last_name from employee e1
join employee e2
on e1.employee_id = e2.manager_id;

-- 7> Write a SQL query to find all employees who have bonus record in bonus table
select * 
from employee e 
where e.employee_id in (
    select employee_ref_id from bonus);

-- alternative
select * from employee where employee_id in (select employee_ref_id from bonus where employee.employee_id = bonus.employee_ref_id);

-- 8> Write a SQL query to find only odd rows from employee
select * 
from employee
where mod(employee_id, 2) = 1;  -- also ok: mod(employee_id, 2) <> 0

-- 9> Write a SQL query to fetch first_name from employee table in upper case
select upper(first_name)
from employee;

-- 10> Write a SQL query to get combine name (first name and last name) of employees from employee table
select concat(first_name, ' ', last_name) 
from employee;

-- 11> Write a SQL query to print details of employee of employee 'Jennifer' and 'James'.
select * 
from employee
where first_name = 'Jennifer' or first_name = 'James';

-- alternative
select * from employee where first_name in ('Jennifer', 'James');

-- 12> Write a SQL query to fetch records of employee whose salary lies between 100000 and 500000
select * 
from employee 
where salary > 100000 and salary < 500000;

-- alternative
select first_name, last_name, salary 
from employee 
where salary between 100000 and 500000;

-- 13> Write a SQL query to get records of employee who have joined in Jan 2017
select * 
from employee
where month(joining_date) = 1 and year(joining_date) = 2017;

-- 14> Write a SQL query to get the list of employees with the same salary
select e1.first_name, e2.last_name
from employee e1, employee e2
where e1.salary = e2.salary and e1.employee_id <> e2.employee_id;

-- 15> Write a SQL query to show all departments along with the number of people working there. 
select department, count(employee_id) as number_of_employees
from employee
group by department
order by number_of_employees;

-- 16> Write a SQL query to show the last record from a table.
select * from employee
where employee_id = (
  select max(employee_id)
  from employee);

-- 17> Write a SQL query to show the first record from a table.
select * from employee
where employee_id = (
  select min(employee_id)
  from employee);

-- 18> Write a SQL query to get last five records from a employee table.
select * from employee
order by employee_id desc limit 5;

-- alternative (asc order)
(select * from employee order by employee_id desc limit 5) order by employee_id;

-- 19> Write a SQL query to find employees having the highest salary in each department. 
select first_name, last_name, department, max(salary) as max_salary
from employee
group by department
order by max_salary;

-- 20> Write a SQL query to fetch three max salaries from employee table.
select distinct salary
from employee
order by salary desc limit 3;

-- 21> Write a SQL query to fetch departments along with the total salaries paid for each of them.
select department, sum(salary) as total_salary
from employee
group by department
order by total_salary;

-- 22> Write a SQL query to find employee with highest salary in an organization from employee table.
select * 
from employee
where salary = (
  select max(salary)
  from employee);

-- 23>     Write an SQL query that makes recommendations using the  pages that your friends liked. 
-- Assume you have two tables: a two-column table of users and their friends, and a two-column table of 
-- users and the pages they liked. It should not recommend pages you already like.

-- user 1's friends
select user_2
from friendship
where user_1 = 1
union
select user_1
from friendship
where user_2 = 1;

-- get liked pages from user 1's friends
select distinct page_id
from likes
where user_id in (select user_2
from friendship
where user_1 = 1
union
select user_1
from friendship
where user_2 = 1);

-- get liked pages from friends where 1 hasn't liked
select friends_liked.page_id from (
    select distinct page_id
    from likes
    where user_id in (
        select user_2
        from friendship
        where user_1 = 1
        union
        select user_1
        from friendship
        where user_2 = 1) 
    ) as friends_liked
where friends_liked.page_id not in 
(select page_id from likes where
 user_id = 1);

-- 24> write a SQL query to find employee (first name, last name, department and bonus) with highest bonus.
select e.first_name, e.last_name, e.department, b.bonus_amount
from employee e
join bonus b 
on e.employee_id = b.employee_ref_id
where e.employee_id = (
  select employee_ref_id
  from bonus
  having bonus_amount = max(bonus_amount));

-- alternative
select first_name, last_name, department, max(bonus_amount) from employee e
join bonus b
on e.employee_id = b.employee_ref_id
group by department
order by max(bonus_amount) desc limit 1;

-- 25> write a SQL query to find employees with same salary (repeat Q14)
select e1.first_name, e2.last_name
from employee e1, employee e2
where e1.salary = e2.salary and e1.employee_id <> e2.employee_id;

-- 26> Write SQL to find out what percent of students attend school on their birthday from attendance_events and all_students tables?
select (count(attendance_events.student_id) * 100 / 
    (select count(student_id) from attendance_events)) as Percent
from attendance_events 
join all_students 
on all_students.student_id = attendance_events.student_id
where month(attendance_events.date_event) = month(all_students.date_of_birth)
and day(attendance_events.date_event) = day(all_students.date_of_birth);

-- 27> Given timestamps of logins, figure out how many people on Facebook were active all seven days of a week on a mobile phone from login info table?
select a.login_time, count(distinct a.user_id) from 
login_info a
Left join login_info b
on a.user_id = b.user_id
where to_days(a.login_time) - to_days(b.login_time) = 1
group by a.login_time;

-- alternative (correct one I think)
select count(b.user_id) number_of_active_all_week from (
select a.user_id, count(a.d)
from
(select distinct user_id, dayofweek(login_time) as d
 from login_info 
where dayofweek(login_time)>0 and dayofweek(login_time) <= 7) a
group by a.user_id
having count(a.d) >= 7) b;


-- 28> Write a SQL query to find out the overall friend acceptance rate for a given date from user_action table.
select count(a.user_id_who_sent) * 100 / (select count(user_id_who_sent) from user_action) as percent
from user_action a 
join user_action b
on a.user_id_who_sent = b.user_id_who_sent 
and a.user_id_to_whom = b.user_id_to_whom
where a.date_action = '2018-05-24' and b.action = "accepted";

-- people who accept within 24 hours
select * 
from user_action a, user_action b
where a.user_id_who_sent = b.user_id_to_whom 
and a.action = 'sent' and b.action = 'accepted'
and to_days(a.date_action) - to_days(b.date_action) < 1;

-- 29> How many total users follow sport accounts from tables all_users, sport_accounts, follow_relation?
select count(distinct(follower_id))
from follow_relation
where target_id in (
  select sport_player_id 
  from sport_accounts);

-- alternative
select count(distinct c.follower_id) as count_all_sports_followers 
from  sport_accounts a
join all_users b
on a.sport_player_id = b.user_id
join follow_relation c
on b.user_id = c.target_id;

-- 30> How many active users follow each type of sport?
select s.sport_category, count(distinct(f.follower_id))
from sport_accounts s
join follow_relation f
on f.target_id = s.sport_player_id where f.follower_id in (
  select user_id 
  from all_users
  where active_last_month = 1)
group by s.sport_category;

-- alternative (not sure, sus)
select b.sport_category, count(a.user_id)
from all_users a
join sport_accounts b
on a.user_id = b.sport_player_id -- this means user = sport player?
join follow_relation c
on a.user_id = c.follower_id
where a.active_last_month =1
group by b.sport_category;

-- 31> What percent of active accounts are fraud from ad_accounts table?
select count(distinct(fraud.account_id)) * 100 / 
(select count(distinct(account_id)) 
      from ad_accounts 
      where account_status='active')
from (select 
      account_id 
      from ad_accounts 
      where account_status='fraud') as fraud
inner join (select 
      account_id 
      from ad_accounts 
      where account_status='active') as active 
on fraud.account_id = active.account_id;

-- alternative
select count(distinct a.account_id)/(select count(account_id) from ad_accounts where account_status= "active") as 'percent' 
from ad_accounts a
join ad_accounts b
on a.account_id = b.account_id
where a.account_status = 'fraud' and b.account_status='active';

-- 32> How many accounts became fraud today for the first time from ad_accounts table?
-- Let today = 2019-04-28 else curdate()
select count(account_id) 'first_time'
from (
  -- fraud today
  select distinct a.account_id, count(a.account_status)
  from ad_accounts a
  join ad_accounts b
  on a.account_id = b.account_id
  where b.date = '2019-04-28' and
  a.account_status = 'fraud'
  group by account_id 
  having count(a.account_status) = 1) ad_accnt;

-- 33> Write a SQL query to determine avg time spent per user per day from user_details and event_session_details
select total.user_id, (
  case when days.user_id = null then total.total_time else total.total_time / days.d end)
from (select e.user_id, sum(e.timespend_sec) as total_time
from event_session_details e
group by e.user_id) as total
left join (select u.user_id, count(u.date) as d
from user_details u
group by u.user_id) as days on
total.user_id = days.user_id;

-- alternative (correct)
select date, user_id, sum(timespend_sec)/count(*) as 'avg time spent per user per day'
from event_session_details
group by date, user_id
order by date;

-- alternative (correct, using avg)
select date, user_id, avg(timespend_sec)
from event_session_details
group by 1,2
order by 1;

-- 34> write a SQL query to find top 10 users that sent the most messages from messages_detail table.
select user_id, messages_sent 
from messages_detail
order by messages_sent desc 
limit 10;

-- 35> Write a SQL query to find disctinct first name from full user name from user_name table (repeat Q5)
select distinct(substring_index(full_names, ' ', 1)) as first_name 
from user_name;

-- 36> You have a table with userID, appID, type and timestamp. type is either 'click' or 'impression'. 
-- Calculate the click through rate from dialoglog table. Now do it in for each app.
-- click through rate is defined as (number of clicks)/(number of impressions)
select app_id,
    ifnull(sum(case when type='click' then 1 else 0 end)*1.0 / 
        sum(case when type='impression' then 1 else 0 end), 0) 
    as 'CTR'
from dialoglog
group by app_id;

-- 37> Given two tables Friend_request (requestor_id, sent_to_id, time),  
-- Request_accepted (acceptor_id, requestor_id, time). Find the overall acceptance rate of requests.
-- Overall acceptate rate of requests = total number of acceptance / total number of requests.
select count(*) / (select count(*) from friend_request)
from
(select distinct s.*
from (select f.requestor_id, f.sent_to_id
from friend_request f 
join request_accepted r
where f.requestor_id = r.requestor_id and 
f.sent_to_id = r.acceptor_id) s) a;

-- alternative (correct)
select ifnull(
  round(
    (select count(*) from (select distinct acceptor_id, requestor_id 
                           from request_accepted) as A) /
    (select count(*) from (select distinct requestor_id, sent_to_id from
                           friend_request) as B)
    , 2)
  , 0)
  as basic;

-- 38> from a table of new_request_accepted, find a user with the most friends.

-- users and number of friends
select id, count(*) as count
from (
select requestor_id as id from new_request_accepted
union all
select acceptor_id as id from new_request_accepted) as a
group by id
order by count desc;

-- get the highest
select t.id from
(
select id, count(*) as count
from (
select requestor_id as id from new_request_accepted
union all
select acceptor_id as id from new_request_accepted) as a
group by id
order by count desc
limit 1) as t;


-- 39> from the table count_request, find total count of requests sent and total count of requests sent failed 
-- per country
select country_code, sum(count_of_requests_sent) as total_requests_sent, sum(cast(replace(percent_of_request_sent_failed, '%', '') as decimal(2,1))*count_of_requests_sent/100) as failed
from count_request
group by country_code;

-- alternative (sus)
select country_code, Total_request_sent, Total_percent_of_request_sent_failed, 
cast((Total_request_sent*Total_percent_of_request_sent_failed)/100 as decimal) as Total_request_sent_failed
from
( 
select country_code, sum(count_of_requests_sent) as Total_request_sent,
cast(replace(ifnull(sum(percent_of_request_sent_failed),0), '%','') as decimal(2,1)) as Total_percent_of_request_sent_failed
from count_request
group by country_code
) as Table1;

-- 40> create a histogram of duration on x axis, no of users on y axis which is populated by volume in each bucket
-- from event_session_details
select floor(timespend_sec/500)*500 as duration, count(distinct user_id) as count_of_users
from event_session_details
group by duration;

-- 41> Write SQL query to calculate percentage of confirmed messages from two tables : 
-- confirmation_no (phone numbers that facebook sends the confirmation messages to) and 
-- confirmed_no (phone numbers that confirmed the verification)
select count(distinct a.phone_number)*100 / count(distinct b.phone_number)
from confirmation_no b, confirmed_no a;

-- alternative (left join preferable i think)
select round((count(confirmed_no.phone_number)/count(confirmation_no.phone_number))*100, 2)
from confirmation_no
left join confirmed_no
on confirmed_no.phone_number = confirmation_no.phone_number;

-- 42> Write SQL query to find number of users who had 4 or more than 4 interactions on 2013-03-23 date 
-- from user_interaction table (user_1, user_2, date). 
-- assume there is only one unique interaction between a pair of users per day
select user_1, count(user_2)
from user_interaction
where d ='2019-03-23'
group by user_1;

select user_2, count(user_1)
from user_interaction
where d ='2019-03-23'
group by user_2;

select un.u, sum(un.ct) as total
from (select user_1 as u, count(user_2) as ct
from user_interaction
where d ='2019-03-23'
group by user_1
union
select user_2 as u, count(user_1) as ct
from user_interaction
where d ='2019-03-23'
group by user_2) as un
group by un.u
having total >= 4;

-- alternative (more elegant maybe)
select table1.user_id, sum(number_of_interactions) as Number_of_interactions
from
(
select user_1 as user_id, count(user_1) as number_of_interactions from user_interaction
group by user_1
union all
select user_2 as user_id, count(user_2) as number_of_interactions from user_interaction
group by user_2) table1
group by table1.user_id
having sum(number_of_interactions) >= 4;

-- 43> write a sql query to find the names of all salesperson that have order with samsonic from 
-- the table: salesperson, customer, orders
-- customers who's name is Samsonic
select id 
from customer 
where name = 'Samsonic';

-- sales id to that customer
select salesperson_id
from orders
where cust_id in (select id 
from customer 
where name = 'Samsonic');

-- name of sales id
select name 
from salesperson 
where id in (select salesperson_id
from orders
where cust_id in (select id 
from customer 
where name = 'Samsonic'));

-- alternative (lol, this one is short)
select s.name
from salesperson s
join orders o on s.id = o.salesperson_id
join customer c on o.cust_id = c.id
where c.name = 'Samsonic';

-- 44> write a sql query to find the names of all salesperson that do not have any order with Samsonic from the table: salesperson, customer, orders
select s.name 
from salesperson s 
where s.name not in (
select s.name
from salesperson s
join orders o on o.salesperson_id = s.id
join customer c on c.id = o.cust_id
where c.name = 'Samsonic');

-- alternative (ok maybe using ID is a better idea bc it's unique... lol)
select s.Name 
from Salesperson s
where s.ID NOT IN(
select o.salesperson_id from Orders o, Customer c
where o.cust_id = c.ID 
and c.Name = 'Samsonic');

-- 45> Wrie a sql query to find the names of salespeople that have 2  or more orders.
select s.name
from salesperson s
where s.id in (select o.salesperson_id
from orders o 
group by o.salesperson_id
having count(*) >= 2);

-- alternatives (adds no. of orders)
select s.name as 'salesperson', count(o.number) as 'number of orders'
from salesperson s
join orders o on s.id = o.salesperson_id
group by s.name  -- ah this is very risky, might have same name!
having count(o.number)>=2;

-- 46> Given two tables:  User(user_id, name, phone_num) and UserHistory(user_id, date, action), 
-- write a sql query that returns the name, phone number and most recent date for any user that has logged in 
-- over the last 30 days 
-- (you can tell a user has logged in if action field in UserHistory is set to 'logged_on')
select user.user_id, user.name, max(userhistory.date)
from user 
join userhistory 
on user.user_id = userhistory.user_id 
and userhistory.action = 'logged_on' 
and to_days(userhistory.date) - to_days(curdate()) <= 30 
group by user.user_id;

-- alternative
select user.name, user.phone_num, max(userhistory.date)
from user,userhistory
where user.user_id = userhistory.user_id
and userhistory.action = 'logged_on'
and userhistory.date >= date_sub(curdate(), interval 30 day)
group by user.name;

-- 47> Given two tables:  User(user_id, name, phone_num) and UserHistory(user_id, date, action), 
-- Write a SQL query to determine which user_ids in the User table are not contained in the UserHistory table 
-- (assume the UserHistory table has a subset of the user_ids in User table). Do not use the SQL MINUS statement. 
-- Note: the UserHistory table can have multiple entries for each user_id. 
select user.user_id 
from user 
where user.user_id not in (
    select userhistory.user_id
    from userhistory
);

-- alternative
select user.user_id
from user
left join userhistory
on user.user_id = userhistory.user_id
where userhistory.user_id is null;

-- 48> from a given table compare(numbers int(4)), write a sql query that will return the maximum value 
-- from the numbers without using 
-- sql aggregate like max or min
select numbers 
from compare 
order by numbers desc
limit 1;

-- 49> Write a SQL query to find out how many users inserted more than 1 but less than 3 images in their presentations from event_log table
-- There is a startup company that makes an online presentation software and they have event_log table that records every time a user inserted 
-- an image into a presentation. one user can insert multiple images.

-- image per user
select user_id, count(event_date_time) as image_per_user
from event_log
group by user_id;

-- users with 1 < no_of_images < 3
select count(*)
from (select user_id, count(event_date_time) as image_per_user
from event_log
group by user_id) as a
where a.image_per_user > 1 and a.image_per_user < 3;

-- 50> select the most recent login time by values from the login_info table
select user_id, max(login_time) as m
from login_info 
group by user_id
order by m desc
limit 1;

-- alternative (similar, maybe more elegant)
select * from login_info
where login_time in (select max(login_time) from login_info
group by user_id)
order by login_time desc limit 1;

