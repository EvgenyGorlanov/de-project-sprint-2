CREATE OR REPLACE VIEW public.shipping_datamart AS
SELECT 
	t1.shippingid as shippingid,
	t1.vendorid as vendorid,
	t2.transfer_type as transfer_type,
	date_part('day',COALESCE(t3.shipping_end_fact_datetime, now()) -
						t3.shipping_start_fact_datetime) as full_day_at_shipping,
	CASE 
		WHEN COALESCE(t3.shipping_end_fact_datetime, now()) > t1.shipping_plan_datetime THEN 1
		ELSE 0
	END as is_delay,
	CASE 
		WHEN t3.status = 'finished' THEN 1
		ELSE 0
	END as is_shipping_finish,
	CASE 
		WHEN COALESCE(t3.shipping_end_fact_datetime, now()) > t1.shipping_plan_datetime 
			THEN date_part('day',COALESCE(t3.shipping_end_fact_datetime, now()) -
						t1.shipping_plan_datetime)
		ELSE 0
	END as delay_day_at_shipping,
	t1.payment_amount as payment_amount,
	t1.payment_amount::NUMERIC(14,3) * 
		(t4.shipping_country_base_rate + t5.agreement_rate::NUMERIC(14,3) + 
		t2.shipping_transfer_rate::NUMERIC(14,3)) as vat,
	t1.payment_amount::NUMERIC(14,3) * t5.agreement_commission::NUMERIC(14,3) as profit
FROM public.shipping_info t1
LEFT JOIN public.shipping_transfer t2 ON t1.transfer_type_id = t2.id
LEFT JOIN public.shipping_status t3 ON t1.shippingid = t3.shippingid
LEFT JOIN public.shipping_country_rates t4 ON t1.shipping_country_id = t4.id
LEFT JOIN public.shipping_agreement t5 ON t1.agreementid = t5.agreementid