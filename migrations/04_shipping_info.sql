DROP TABLE IF EXISTS public.shipping_info;
CREATE TABLE public.shipping_info (
	shippingid bigint PRIMARY KEY,
	shipping_plan_datetime timestamp without time zone,
	payment_amount NUMERIC(14,2),
	vendorid bigint,
	transfer_type_id integer,
	shipping_country_id integer,
	agreementid integer,
	
	FOREIGN KEY (transfer_type_id) REFERENCES public.shipping_transfer(id) ON UPDATE cascade,
	FOREIGN KEY (shipping_country_id) REFERENCES public.shipping_country_rates(id) ON UPDATE cascade,
	FOREIGN KEY (agreementid) REFERENCES public.shipping_agreement(agreementid) ON UPDATE cascade
);

INSERT INTO public.shipping_info(shippingid, shipping_plan_datetime, payment_amount, 
								 vendorid, transfer_type_id, shipping_country_id, agreementid)

WITH agreement_id_shipping as (
	SELECT 
		t.shipping_agreement[1]::int as agreementid,
		t.shippingid as shippingid
	FROM(
		SELECT DISTINCT
			regexp_split_to_array(vendor_agreement_description , ':+') AS shipping_agreement,
			shippingid
		FROM public.shipping
		) t 
)
SELECT DISTINCT 
	sp.shippingid,
	sp.shipping_plan_datetime,
	sp.payment_amount,
	sp.vendorid,
	st.id,
	scr.id,
	sa.agreementid
FROM public.shipping sp
LEFT JOIN public.shipping_transfer st ON (st.transfer_type || ':' || st.transfer_model) = shipping_transfer_description
LEFT JOIN public.shipping_country_rates scr ON (scr.shipping_country = sp.shipping_country)
LEFT JOIN agreement_id_shipping sa ON sa.shippingid = sp.shippingid;