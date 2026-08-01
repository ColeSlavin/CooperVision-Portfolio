-- Supplier Analytics

-- Supplier Reliability by Country
SELECT supplier_country,
       AVG(supplier_reliability_score) AS avg_reliability
FROM supply_chain_data
GROUP BY supplier_country
ORDER BY avg_reliability DESC;

-- Supplier Performance Scorecard
SELECT
    supplier_id,
    supplier_country,
    AVG(supplier_reliability_score)      AS avg_reliability,
    AVG(lead_time_days)                  AS avg_lead_time,
    AVG(delay_probability)               AS avg_delay_probability,
    AVG(disruption_likelihood_score)     AS avg_disruption_likelihood,
    AVG(shipping_costs)                  AS avg_shipping_cost
FROM supply_chain_data
GROUP BY supplier_id, supplier_country
ORDER BY avg_reliability DESC;

-- High-Risk Supplier Monitoring List
SELECT
    supplier_id,
    supplier_country,
    AVG(delay_probability)               AS avg_delay_probability,
    AVG(disruption_likelihood_score)     AS avg_disruption_likelihood,
    AVG(delivery_time_deviation)         AS avg_delivery_deviation
FROM supply_chain_data
WHERE risk_classification = 'High Risk'
GROUP BY supplier_id, supplier_country
ORDER BY avg_delay_probability DESC;

-- Supplier Ranking Within Country
SELECT
    supplier_country,
    supplier_id,
    AVG(supplier_reliability_score) AS avg_reliability,
    RANK() OVER (PARTITION BY supplier_country ORDER BY AVG(supplier_reliability_score) DESC) AS reliability_rank
FROM supply_chain_data
GROUP BY supplier_country, supplier_id
ORDER BY supplier_country, reliability_rank;

-- Risk Validation

-- Validate Risk Classification
SELECT
    risk_classification,
    COUNT(*)                              AS record_count,
    AVG(delay_probability)                AS avg_delay_probability,
    AVG(disruption_likelihood_score)      AS avg_disruption_likelihood,
    AVG(delivery_time_deviation)          AS avg_delivery_deviation
FROM supply_chain_data
GROUP BY risk_classification
ORDER BY avg_disruption_likelihood DESC;

-- Risk Classification Distribution by Country
SELECT
    supplier_country,
    risk_classification,
    COUNT(*) AS record_count
FROM supply_chain_data
GROUP BY supplier_country, risk_classification
ORDER BY supplier_country, risk_classification;

-- Top Disruption-Prone Suppliers
SELECT
    supplier_id,
    supplier_country,
    AVG(disruption_likelihood_score) AS avg_disruption_likelihood
FROM supply_chain_data
GROUP BY supplier_id, supplier_country
ORDER BY avg_disruption_likelihood DESC
LIMIT 20;

-- Inventory & Demand

-- Inventory-to-Demand Ratio (Stockout Risk)
SELECT
    product_id,
    AVG(warehouse_inventory_level) AS avg_inventory,
    AVG(historical_demand) AS avg_demand,
    AVG(warehouse_inventory_level / NULLIF(historical_demand, 0)) AS avg_inventory_demand_ratio
FROM supply_chain_data
GROUP BY product_id
ORDER BY avg_inventory_demand_ratio DESC;

-- Fill Rate By Product
SELECT 
    product_id,
    SUM(order_fulfillment_status) / NULLIF(SUM(historical_demand), 0) AS fill_rate
FROM supply_chain_data
GROUP BY product_id
ORDER BY fill_rate ASC;

-- Logistics & Cost

-- Countries with Slowest Lead Times
SELECT supplier_country,
       AVG(lead_time_days) AS avg_lead_time
FROM supply_chain_data
GROUP BY supplier_country
ORDER BY avg_lead_time DESC;

-- Most Expensive Shipping Lanes
SELECT
    product_id,
    supplier_id,
    supplier_country,
    shipping_costs
FROM supply_chain_data
ORDER BY shipping_costs DESC
LIMIT 20;

-- Cost vs Reliability
SELECT
    supplier_id,
    supplier_country,
    AVG(shipping_costs)             AS avg_cost,
    AVG(supplier_reliability_score) AS avg_reliability
FROM supply_chain_data
GROUP BY supplier_id, supplier_country
ORDER BY avg_cost DESC;

-- Volatility & External Drivers

-- Delivery Time Volatility
SELECT
    product_id,
    supplier_id,
    supplier_country,
    avg_delivery_deviation,
    ABS(avg_delivery_deviation) AS abs_avg_delivery_deviation
FROM (
    SELECT
        product_id,
        supplier_id,
        supplier_country,
        AVG(delivery_time_deviation) AS avg_delivery_deviation
    FROM supply_chain_data
    GROUP BY product_id, supplier_id, supplier_country
) AS lane_stats
ORDER BY abs_avg_delivery_deviation DESC
LIMIT 20;

-- Weather Severity Impact
SELECT
    weather_condition_severity,
    AVG(delay_probability) AS avg_delay_probability,
    AVG(delivery_time_deviation) AS avg_delivery_deviation
FROM supply_chain_data
GROUP BY weather_condition_severity
ORDER BY weather_condition_severity DESC;

-- Route Risk Level vs Performance
SELECT
    route_risk_level,
    AVG(delay_probability) AS avg_delay_probability,
    AVG(disruption_likelihood_score) AS avg_disruption_likelihood
FROM supply_chain_data
GROUP BY route_risk_level
ORDER BY route_risk_level DESC;

-- Product Stability & KPIs

-- Product-Level Supply Chain Stability
SELECT
    product_id,
    AVG(lead_time_days)              AS avg_lead_time,
    AVG(delay_probability)           AS avg_delay_probability,
    AVG(delivery_time_deviation)     AS avg_delivery_deviation
FROM supply_chain_data
GROUP BY product_id
ORDER BY avg_delay_probability DESC;

-- Service Level (On-Time Percent)
SELECT
    supplier_id,
    supplier_country,
    1 - AVG(delay_probability) AS on_time_rate
FROM supply_chain_data
GROUP BY supplier_id, supplier_country
ORDER BY on_time_rate DESC;
