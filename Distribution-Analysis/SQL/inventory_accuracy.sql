-- Inventory Accuracy Calculation
-- Placeholder SQL to be replaced with real queries once dataset is loaded

SELECT 
    sku_id,
    warehouse_id,
    expected_quantity,
    actual_quantity,
    (actual_quantity - expected_quantity) AS variance,
    ROUND((actual_quantity / NULLIF(expected_quantity,0)) * 100, 2) AS accuracy_percentage
FROM inventory_table;

