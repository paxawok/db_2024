/*SET search_path TO online_store;

/*ПРОЦЕДУРИ*/


-- оновлення продукту
CREATE OR REPLACE PROCEDURE update_product(
    IN v_product_id INTEGER,
    IN v_name VARCHAR(255),
    IN v_description TEXT,
    IN v_price NUMERIC(10, 2),
    IN v_category_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Products 
    SET 
        name = v_name,
        description = v_description,
        price = v_price,
        category_id = v_category_id
    WHERE id = v_product_id;
END;
$$;

--створити продукт
CREATE OR REPLACE PROCEDURE create_product(
    IN v_name VARCHAR(255),
    IN v_description TEXT,
    IN v_price NUMERIC(10, 2),
    IN v_category_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Products (name, description, price, category_id)
    VALUES (v_name, v_description, v_price, v_category_id);
END;
$$;


-- видалення продукту
CREATE OR REPLACE PROCEDURE delete_product(v_product_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Order_Details WHERE product_id = v_product_id) THEN
        DELETE FROM Products WHERE id = v_product_id;
    ELSE
        RAISE EXCEPTION 'Product cannot be deleted because it is included in one or more orders.';
    END IF;
END;
$$;


/*ФУНКЦІЇ*/
-- отримання продуктів 
CREATE OR REPLACE FUNCTION get_all_products()
RETURNS TABLE (
    product_id INTEGER,
    product_name VARCHAR(255),
    product_description TEXT,
    product_price NUMERIC(10, 2),
    product_category_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT id AS product_id, name AS product_name, description AS product_description, price AS product_price, category_id AS product_category_id FROM Products;
END;
$$;


/*ТРИГЕР*/
-- при зміні таблиці продукти виведе на консоль інфу про це
CREATE OR REPLACE FUNCTION log_new_product()
RETURNS TRIGGER AS $$
BEGIN
    -- Тут може бути код, що логує новий продукт або робить інші дії
    RAISE NOTICE 'New product added: %', NEW.name;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Створення тригера для логування нових продуктів
CREATE TRIGGER trigger_log_new_product_4
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION log_new_product();
*/