Task 2:

Table: Supplier
Columns:

Supplier_ID (Primary Key)
Supplier_Name
Supplier_Contact_Name
Supplier_Address
Supplier_Contact_Number
Supplier_Email
Table: Order
Columns:

Order_ID (Primary Key)
Order_Ref
Order_Date
Supplier_ID (Foreign Key to Supplier table)
Order_Total_Amount
Order_Description
Order_Status
Table: Invoice
Columns:

Invoice_ID (Primary Key)
Invoice_Ref
Invoice_Date
Invoice_Status
Invoice_Hold_Reason
Invoice_Amount
Invoice_Description
Order_ID (Foreign Key to Order table)