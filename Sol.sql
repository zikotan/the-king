				--SQL:
--1) 
select * from Items
where itemname like '%O%' or itemname like '%M%';

--2)
SELECT c.*
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.custno = c.custno
    AND EXISTS (
        SELECT 1
        FROM Lineitems l
        WHERE l.ordno = o.ordno
        GROUP BY l.ordno
        HAVING SUM(l.qty * l.price) > 30000
    )
);

--3)
select l.* 
from Lineitems l
join Items i on i.itemno = l.itemno 
and i.rate > ( select AVG(rate) from Items )



				--PL/SQL:
--1)
DECLARE
  v_avg_price NUMBER;
  v_new_price NUMBER;
  
  CURSOR item_cursor IS
    SELECT i.itemno, i.rate, SUM(l.qty) AS somme_qty
    FROM items i
    JOIN lineitems l on l.itemno = i.itemno
    GROUP BY i.itemno, i.rate
    ORDER BY i.itemno;
  
BEGIN
  -- Calculate the average selling price
  SELECT AVG(price)
  INTO v_avg_price
  FROM lineitems;
  
  -- Loop through each item
  FOR i IN item_cursor LOOP   
    -- Calculate the new price based on conditions
    IF i.somme_qty > 5 THEN
      v_new_price := i.rate * 1.1; -- Increase price by 10%
    ELSIF v_avg_price > i.rate THEN
      v_new_price := i.rate * 1.02; -- Increase price by 2%
    ELSE
      v_new_price := i.rate * 0.97; -- Decrease price by 3%
    END IF;
    
    -- Update the price of the item
    UPDATE items
    SET rate = v_new_price
    WHERE itemno = i.itemno;
    
    -- Display the changes
    DBMS_OUTPUT.PUT_LINE('Item ' || i.itemno || ': Price(rate) changed to ' || v_new_price);
  END LOOP;
END;
/

--2)
DECLARE
  v_min_orderno NUMBER := NULL;
  v_max_missing_orderno NUMBER := NULL;
  v_max_orderno NUMBER := NULL;  -- Variable to store the maximum order number
  v_exists NUMBER;
BEGIN
  -- Retrieve the minimum and maximum order numbers before entering the loop
  SELECT MIN(ordno), MAX(ordno) INTO v_min_orderno, v_max_orderno FROM orders;

  WHILE v_min_orderno <= v_max_orderno AND v_max_missing_orderno IS NULL LOOP
      -- Check if the min order number exists
      SELECT COUNT(*) INTO v_exists FROM orders 
      WHERE ordno = v_max_orderno;

        -- If the min order number is missing, update the largest missing order number
      IF v_exists = 0 THEN
        v_max_missing_orderno := v_max_orderno;
        DBMS_OUTPUT.PUT_LINE('The largest missing OrderNo is: ' || v_max_missing_orderno);
      END IF;

    -- Decrement the min order number for the next iteration
    v_max_orderno := v_max_orderno - 1;
  END LOOP;

  -- If no missing order number is found, output a message
  IF v_max_missing_orderno IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('No OrderNo is missing.');
  END IF;
END;
/

--3)
DECLARE
  v_first_orderno NUMBER;
  i NUMBER := 1;

  CURSOR curs_tot IS 
    SELECT o.ordno, c.custname, SUM(l.qty * l.price) AS t_price
    FROM Lineitems l 
    JOIN orders o ON o.ordno = l.ordno
    JOIN customers c ON c.custno = o.custno
    GROUP BY o.ordno, c.custname
    ORDER BY o.ordno;

BEGIN
  -- Retrieve the minimum order number before entering the loop
  SELECT MIN(ordno) INTO v_first_orderno FROM orders;

  FOR j IN curs_tot LOOP
    DBMS_OUTPUT.PUT_LINE(i || ') Ordno: ' || j.ordno || ', Costumer: ' || j.custname || ' ==> Total: ' || j.t_price);
    i := i + 1;
    IF i > 5 THEN
    EXIT;
    END IF;
  END LOOP;
END;
/


--4)
CREATE OR REPLACE TRIGGER prevent_price_decrease
BEFORE UPDATE OF price ON LINEITEMS
FOR EACH ROW
BEGIN
    IF :NEW.price < :OLD.price THEN
        RAISE_APPLICATION_ERROR(-20001, 'Price decrease is not allowed.');
    END IF;
END;
/

--5)
CREATE OR REPLACE PROCEDURE find_first_missing_orderno
IS
  v_min_orderno NUMBER := NULL;
  v_first_missing_orderno NUMBER := NULL;
  v_max_orderno NUMBER;  -- Variable to store the maximum order number
  v_exists NUMBER;
BEGIN
  -- Retrieve the minimum and maximum order numbers before entering the loop
  SELECT MIN(ordno), MAX(ordno) INTO v_min_orderno, v_max_orderno FROM orders;

  WHILE v_min_orderno <= v_max_orderno AND v_first_missing_orderno IS NULL LOOP
    -- Check if the min order number exists
      SELECT COUNT(*) INTO v_exists FROM orders WHERE ordno = v_min_orderno;
        -- If the min order number is missing, update the largest missing order number
      IF v_exists = 0 THEN
        v_first_missing_orderno := v_min_orderno;
        DBMS_OUTPUT.PUT_LINE('The first missing OrderNo is: ' || v_first_missing_orderno);
      END IF;

    -- Increment the min order number for the next iteration
    v_min_orderno := v_min_orderno + 1;
  END LOOP;

  -- If no missing order number is found, output a message
  IF v_first_missing_orderno IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('No OrderNo is missing.');
  END IF;
END;
/

-- this is just how we call the function to be executed not a part of the fuction
BEGIN
  find_first_missing_orderno;
END;
/

--6)
CREATE OR REPLACE TRIGGER prevent_excessive_items
BEFORE INSERT OR UPDATE ON lineitems
FOR EACH ROW
DECLARE
    v_item_count NUMBER;
BEGIN
    -- Count the number of items for the order being inserted or updated
    SELECT COUNT(*)
    INTO v_item_count
    FROM lineitems
    WHERE ordno = :NEW.ordno;

    -- If the number of items exceeds 5, raise an exception
    IF v_item_count >= 5 THEN
        RAISE_APPLICATION_ERROR(-20001, 'An order cannot contain more than 5 items.');
    END IF;
END;
/

--7)
CREATE OR REPLACE TRIGGER prevent_price_change
BEFORE UPDATE OF rate ON items
FOR EACH ROW
BEGIN
    -- Check if the change exceeds 25% of the old price
    IF ABS(:NEW.rate - :OLD.rate) > (0.25 * :OLD.rate) THEN
        -- Raise an exception if the change exceeds the threshold
        RAISE_APPLICATION_ERROR(-20001, 'Price change exceeds 25% of the old price.');
    END IF;
END;
/
