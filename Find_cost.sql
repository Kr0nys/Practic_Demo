-- Расчет итоговой себестоимости заказа
WITH product_material_cost AS (
    SELECT 
        p.id AS product_id,
        COALESCE(SUM(sc.quantity * pr.cost), 0) AS unit_production_cost
    FROM product p
    LEFT JOIN specification s ON p.id = s.product_id
    LEFT JOIN specification_composition sc ON s.id = sc.spec_id
    LEFT JOIN prices pr ON sc.material_id = pr.material_id
    GROUP BY p.id
)
SELECT 
    co.id AS order_id,
    co.order_number AS "Номер заказа",
    co.date AS "Дата",
    c.name AS "Заказчик",
    COUNT(oi.id) AS "Позиций в заказе",
    ROUND(SUM(oi.quantity * pmc.unit_production_cost), 2) AS "Общая себестоимость заказа"
    
FROM customer_order co
JOIN order_items oi ON co.id = oi.order_id
JOIN product p ON oi.product_id = p.id
JOIN customer c ON co.customer_id = c.id
JOIN product_material_cost pmc ON p.id = pmc.product_id

GROUP BY co.id, co.order_number, co.date, c.name
ORDER BY co.order_number;