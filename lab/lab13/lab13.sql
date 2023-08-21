.read data.sql


CREATE TABLE bluedog AS
  SELECT color, pet from students where color = "blue" and pet = "dog";

CREATE TABLE bluedog_songs AS
  SELECT color, pet ,song from students where color = "blue" and pet = "dog";


CREATE TABLE smallest_int_having AS
  SELECT time, smallest from students group by smallest having count(*) <= 1;


CREATE TABLE matchmaker AS
  SELECT a.pet, a.song, a.color, b.color from students as a, students as b
    where a.pet = b.pet and a.song = b.song and a.time < b.time;


CREATE TABLE sevens AS
  SELECT stu.seven from numbers as n, students as stu where stu.time = n.time and n."7" = "True"
and stu.number = 7;


CREATE TABLE average_prices AS
  SELECT category, avg(MSRP) as average_price from products group by category;


CREATE TABLE lowest_prices AS
  SELECT store, item, min(price) from inventory group by item;


    create table what_to_buy as
        select name, min(p.MSRP / p.rating) from products as p group by p.category;

CREATE TABLE shopping_list AS
  SELECT lp.item, lp.store from what_to_buy as w, lowest_prices as lp where lp.item = w.name;


CREATE TABLE total_bandwidth AS
  SELECT sum(s.Mbs) from shopping_list as sl, stores as s where s.store = sl.store;

