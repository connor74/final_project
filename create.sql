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
