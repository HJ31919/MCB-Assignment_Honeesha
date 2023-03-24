CREATE OR REPLACE PROCEDURE ORDER_INVOICE_SUMMARY_REPORT AS
  CURSOR c_orders IS
    SELECT SUBSTR(ORDER_REF, 3) AS ORDER_REFERENCE,
           TO_CHAR(TO_DATE(ORDER_DATE, 'DD-MON-YYYY'), 'MON-YY') AS ORDER_PERIOD,
           INITCAP(SUPPLIER_NAME) AS SUPPLIER_NAME,
           TO_CHAR(TO_NUMBER(REPLACE(ORDER_TOTAL_AMOUNT, ',', '')), '999,999,990.00') AS ORDER_TOTAL_AMOUNT,
           ORDER_STATUS,
           INVOICE_REFERENCE,
           TO_CHAR(TO_NUMBER(REPLACE(INVOICE_AMOUNT, ',', '')), '999,999,990.00') AS INVOICE_TOTAL_AMOUNT,
           CASE
             WHEN COUNT(DISTINCT INVOICE_STATUS) = 1 AND MIN(INVOICE_STATUS) = 'Paid' THEN 'OK'
             WHEN COUNT(DISTINCT INVOICE_STATUS) = 1 AND MIN(INVOICE_STATUS) = 'Pending' THEN 'To follow up'
             ELSE 'To verify'
           END AS ACTION
    FROM XXBCM_ORDER_MGT
    GROUP BY SUBSTR(ORDER_REF, 3),
             TO_CHAR(TO_DATE(ORDER_DATE, 'DD-MON-YYYY'), 'MON-YY'),
             INITCAP(SUPPLIER_NAME),
             TO_CHAR(TO_NUMBER(REPLACE(ORDER_TOTAL_AMOUNT, ',', '')), '999,999,990.00'),
             ORDER_STATUS,
             INVOICE_REFERENCE,
             TO_CHAR(TO_NUMBER(REPLACE(INVOICE_AMOUNT, ',', '')), '999,999,990.00')
    ORDER BY TO_DATE(ORDER_DATE, 'DD-MON-YYYY') DESC;

  v_order_reference      VARCHAR2(2000);
  v_order_period         VARCHAR2(2000);
  v_supplier_name        VARCHAR2(2000);
  v_order_total_amount   VARCHAR2(2000);
  v_order_status         VARCHAR2(2000);
  v_invoice_reference    VARCHAR2(2000);
  v_invoice_total_amount VARCHAR2(2000);
  v_action               VARCHAR2(2000);

BEGIN
  DBMS_OUTPUT.PUT_LINE('Order Reference | Order Period | Supplier Name | Order Total Amount | Order Status | Invoice Reference | Invoice Total Amount | Action');
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------------------------');

  FOR r_order IN c_orders LOOP
    v_order_reference := r_order.ORDER_REFERENCE;
    v_order_period := r_order.ORDER_PERIOD;
    v_supplier_name := r_order.SUPPLIER_NAME;
    v_order_total_amount := r_order.ORDER_TOTAL_AMOUNT;
    v_order_status := r_order.ORDER_STATUS;
    v_invoice_reference := r_order.INVOICE_REFERENCE;
    v_invoice_total_amount := r_order.INVOICE_TOTAL_AMOUNT;
    v_action := r_order.ACTION;

    DBMS_OUTPUT.PUT_LINE(v_order_reference || ' | ' || v_order_period || ' | ' || v_supplier_name || ' | ' || v_order_total_amount || ' | ' || v_order_status || ' | ' || v_invoice_reference || ' | ' || v_invoice_total_amount || ' | ' || v_action);
  END LOOP;
END;
/


Execution of the stored procedure is done by calling 'EXEC ORDER_INVOICE_SUMMARY_REPORT;'