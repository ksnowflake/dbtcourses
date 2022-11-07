WITH payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
),

pivoted AS (
    SELECT 
        order_id,
        {% for payment_methods in ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] -%}
        sum(case when payment_method = '{{ payment_methods }}' then amount else 0 end) AS {{ payment_methods }}_amount {{ ',' if not loop.last }}
        {% endfor -%}
    FROM
        payments
    WHERE status = 'success'
    GROUP BY 1
)

SELECT * FROM pivoted