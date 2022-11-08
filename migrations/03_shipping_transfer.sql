DROP TABLE IF EXISTS public.shipping_transfer;
CREATE TABLE public.shipping_transfer (
	id serial PRIMARY KEY,
	transfer_type varchar(3),
	transfer_model text,
	shipping_transfer_rate NUMERIC(4,3)
);	
INSERT INTO public.shipping_transfer(transfer_type, transfer_model, shipping_transfer_rate)
SELECT 
	t.shipping_transfer[1]::varchar(3) as transfer_type,
	t.shipping_transfer[2]::text as transfer_model,
	t.shipping_transfer_rate::NUMERIC(4,3) as shipping_transfer_rate	
FROM(
	SELECT DISTINCT
		regexp_split_to_array(shipping_transfer_description  , ':+') AS shipping_transfer,
		shipping_transfer_rate
	FROM public.shipping
) t
LIMIT 10;