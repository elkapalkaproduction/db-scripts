-- This mySQL script for WooCommerce will list the following:
-- ID, Display Name, Login, Email, Registed Date, Total Orders and Total Revenue
-- For every order made through WooCommerce with a positive order total (> 0)
Select us.ID, us.display_name, us.user_login, us.user_email, us.user_registered, payers.orders, payers.total_spent
FROM (Select ou_final.user_id, sum(ou_final.order_total) as total_spent, count(distinct ou_final.order_id) as orders
FROM 
(Select ou.order_id, ou.user_id, ot.order_total
FROM 
(Select pm.post_id as order_id, pm.meta_value as user_id from avtoram.wp_postmeta pm
where pm.post_id in
(SELECT pm.post_id 
FROM avtoram.wp_postmeta pm WHERE pm.meta_key = '_order_total' and pm.meta_value > 0) 
and pm.meta_key = '_customer_user') as ou
INNER JOIN 
(SELECT pm.post_id AS order_id, pm.meta_value AS order_total 
FROM avtoram.wp_postmeta pm WHERE pm.meta_key = '_order_total' and pm.meta_value > 0) as ot
ON
ou.order_id = ot.order_id)  as ou_final
group by ou_final.user_id) as payers
inner join avtoram.wp_users us
ON payers.user_id = us.ID
order by payers.total_spent DESC