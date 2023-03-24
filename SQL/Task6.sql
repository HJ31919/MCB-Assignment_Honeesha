CREATE OR REPLACE PROCEDURE GET_SUPPLIER_ORDER_SUMMARY 
IS
BEGIN
    SELECT 
        UPPER(SUPPLIER_NAME) AS SUPPLIER_NAME,
        SUPP_CONTACT_NAME,
        CASE 
            WHEN LENGTH(REPLACE(REPLACE(SUPP_CONTACT_NUMBER, '-', ''), ' ', '')) = 8 
                THEN SUBSTR(SUPP_CONTACT_NUMBER, 1, 4) || '-' || SUBSTR(SUPP_CONTACT_NUMBER, 5, 4)
            ELSE 
                SUBSTR(SUPP_CONTACT_NUMBER, 1, 5) || '-' || SUBSTR(SUPP_CONTACT_NUMBER, 6, 4)
        END AS SUPP_CONTACT_NO_1,
        CASE 
            WHEN LENGTH(REPLACE(REPLACE(SUPP_CONTACT_NUMBER, '-', ''), ' ', '')) > 8 
                THEN SUBSTR(SUPP_CONTACT_NUMBER, -8, 4) || '-' || SUBSTR(SUPP_CONTACT_NUMBER, -4, 4)
        END AS SUPP_CONTACT_NO_2,
        COUNT(DISTINCT REPLACE(ORDER_REF, 'PO', '')) AS TOTAL_ORDERS,
        TO_CHAR(SUM(TO_NUMBER(REPLACE(ORDER_TOTAL_AMOUNT, ',', ''))), 'FM99,999,990.00') AS ORDER_TOTAL_AMOUNT
    FROM 
        XXBCM_ORDER_MGT
    WHERE 
        TO_DATE(ORDER_DATE, 'DD-MON-YYYY') BETWEEN TO_DATE('01-JAN-2017', 'DD-MON-YYYY') AND TO_DATE('31-AUG-2017', 'DD-MON-YYYY')
    GROUP BY 
        SUPPLIER_NAME,
        SUPP_CONTACT_NAME,
        SUPP_CONTACT_NUMBER
    ORDER BY 
        SUPPLIER_NAME ASC;
END;
/


To execute the stored procedure, simply run the following command:

EXECUTE GET_SUPPLIER_ORDER_SUMMARY;