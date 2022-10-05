DROP TABLE IF EXISTS public.shipping_status;
CREATE TABLE public.shipping_status (
	shippingid bigint PRIMARY KEY,
	status text,
	state text,
	shipping_start_fact_datetime TIMESTAMP,
	shipping_end_fact_datetime TIMESTAMP
);
INSERT INTO public.shipping_status(shippingid, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
WITH start_time as (
SELECT 
	shippingid as shippingid,
	state_datetime as shipping_start_fact_datetime
FROM 
	public.shipping
WHERE
	state = 'booked'
), 
end_time as(
SELECT 
	shippingid as shippingid,
	state_datetime as shipping_end_fact_datetime
FROM 
	public.shipping
WHERE
	state = 'recieved'
),
actual_status_datetime as(
SELECT 
	shippingid as shippingid,
	MAX(state_datetime) as actual_datetime
FROM 
	public.shipping
GROUP BY shippingid
)
SELECT 
	t1.shippingid,
	t1.status,
	t1.state,
	t2.shipping_start_fact_datetime,
	t3.shipping_end_fact_datetime	
FROM public.shipping t1
LEFT JOIN start_time t2 ON t1.shippingid = t2.shippingid
LEFT JOIN end_time t3 ON t1.shippingid = t3.shippingid
RIGHT JOIN actual_status_datetime t4 ON t1.shippingid = t4.shippingid AND t1.state_datetime = t4.actual_datetime
ORDER BY shippingid