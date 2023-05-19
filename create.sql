CREATE TABLE KURZANOVARTYANDEXRU__STAGING.transactions (
	operation_id varchar(60) NULL,
	account_number_from int4 NULL,
	account_number_to int4 NULL,
	currency_code int4 NULL,
	country varchar(30) NULL,
	status varchar(30) NULL,
	transaction_type varchar(30) NULL,
	amount int4 NULL,
	transaction_dt timestamp NULL
);
CREATE INDEX transactions_operation_id_idx ON public.transactions USING btree (operation_id);


CREATE TABLE public.currencies (
	date_update timestamp NULL,
	currency_code int4 NULL,
	currency_code_with int4 NULL,
	currency_with_div numeric(5, 3) NULL
);
CREATE INDEX currencies_currency_code_idx ON public.currencies USING btree (currency_code);


WITH raw AS (
	SELECT *
	FROM public.transactions t 
	WHERE 
		t.status = 'done' AND 
		t.account_number_from > 0 AND
		t.account_number_to > 0 AND 
		t.transaction_type IN (
			'c2a_incoming',
	        'c2b_partner_incoming',
	        'sbp_incoming',
	        'sbp_outgoing',
	        'transfer_incoming',
	        'transfer_outgoing'
	     )
)
SELECT * 
FROM raw


------------------------------------------------------------------

WITH raw AS (
	SELECT *
	FROM public.transactions t 
	WHERE 
		t.status = 'done' AND 
		t.account_number_from > 0 AND
		t.account_number_to > 0 AND 
		t.transaction_type IN (
			'c2a_incoming',
	        'c2b_partner_incoming',
	        'sbp_incoming',
	        'sbp_outgoing',
	        'transfer_incoming',
	        'transfer_outgoing'
	     )
), pay_to AS (
	SELECT 
		account_number_from,
		currency_code,
		country 
	FROM raw
)
SELECT
	raw.operation_id,
	raw.transaction_dt,
	raw.account_number_from,
	raw.account_number_to,
	raw.currency_code AS currency_code_from,
	pay_to.currency_code AS currency_code_to,
	raw.country AS country_from,
	pay_to.country AS country_to,
	raw.status,
	raw.transaction_type,
	raw.amount
FROM raw  
LEFT JOIN pay_to 
	ON raw.account_number_to = pay_to.account_number_from
