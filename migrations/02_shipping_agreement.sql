DROP TABLE IF EXISTS public.shipping_agreement;
CREATE TABLE public.shipping_agreement(
	agreementid int PRIMARY KEY,
	agreement_number varchar(10),
	agreement_rate NUMERIC(4,3),
	agreement_commission NUMERIC(4,3)
);
INSERT INTO public.shipping_agreement (agreementid, agreement_number, agreement_rate, agreement_commission)
SELECT 
	t.shipping_agreement[1]::int as agreementid,
	t.shipping_agreement[2]::varchar(10) as agreement_number,
	t.shipping_agreement[3]::NUMERIC(4,3) as agreement_rate,
	t.shipping_agreement[4]::NUMERIC(4,3) as agreement_commission	
FROM(
	SELECT DISTINCT
		regexp_split_to_array(vendor_agreement_description , ':+') AS shipping_agreement
	FROM public.shipping
) t
LIMIT 10;