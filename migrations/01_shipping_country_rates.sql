DROP TABLE IF EXISTS public.shipping_country_rates;
CREATE TABLE public.shipping_country_rates(
	id serial PRIMARY KEY,
	shipping_country text,
	shipping_country_base_rate NUMERIC(14,3)
);
INSERT INTO public.shipping_country_rates (shipping_country, shipping_country_base_rate)

SELECT DISTINCT
	shipping_country,
	shipping_country_base_rate
FROM public.shipping
LIMIT 10;