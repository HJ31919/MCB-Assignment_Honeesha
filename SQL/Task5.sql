CREATE OR REPLACE PROCEDURE get_third_highest_order IS
    v_order_ref VARCHAR2(20);
    v_order_date DATE;
    v_supplier_name VARCHAR2(200);
    v_order_total_amount NUMBER(15,2);
    v_order_status VARCHAR2(20);
    v_invoice_references VARCHAR2(4000);
BEGIN
    SELECT ORDER_REF, TO_DATE(ORDER_DATE, 'DD-MON-YYYY'), INITCAP(SUPPLIER_NAME),
           TO_NUMBER(REGEXP_REPLACE(ORDER_TOTAL_AMOUNT, '[^0-9.]', '')),
           ORDER_STATUS,
           LISTAGG(INVOICE_REFERENCE, ', ') WITHIN GROUP (ORDER BY INVOICE_REFERENCE) INTO
           v_order_ref, v_order_date, v_supplier_name, v_order_total_amount,
           v_order_status, v_invoice_references
    FROM XXBCM_ORDER_MGT
    WHERE ORDER_TOTAL_AMOUNT < (SELECT DISTINCT ORDER_TOTAL_AMOUNT
                                 FROM (SELECT DISTINCT ORDER_TOTAL_AMOUNT FROM XXBCM_ORDER_MGT ORDER BY ORDER_TOTAL_AMOUNT DESC) WHERE ROWNUM <= 3 MINUS
                                 SELECT DISTINCT ORDER_TOTAL_AMOUNT FROM (SELECT DISTINCT ORDER_TOTAL_AMOUNT FROM XXBCM_ORDER_MGT ORDER BY ORDER_TOTAL_AMOUNT DESC) WHERE ROWNUM <= 2)
    GROUP BY ORDER_REF, ORDER_DATE, SUPPLIER_NAME, ORDER_TOTAL_AMOUNT, ORDER_STATUS
    ORDER BY ORDER_TOTAL_AMOUNT DESC
    FETCH FIRST 1 ROW ONLY;
    
    DBMS_OUTPUT.PUT_LINE('Order Reference: ' || SUBSTR(v_order_ref, 3));
    DBMS_OUTPUT.PUT_LINE('Order Date: ' || TO_CHAR(v_order_date, 'Month DD, YYYY'));
    DBMS_OUTPUT.PUT_LINE('Supplier Name: ' || UPPER(v_supplier_name));
    DBMS_OUTPUT.PUT_LINE('Order Total Amount: ' || TO_CHAR(v_order_total_amount, '99,999,990.00'));
    DBMS_OUTPUT.PUT_LINE('Order Status: ' || v_order_status);
    DBMS_OUTPUT.PUT_LINE('Invoice References: ' || v_invoice_references);
END;
/

The results are printed using the 'DBMS_OUTPUT' package.