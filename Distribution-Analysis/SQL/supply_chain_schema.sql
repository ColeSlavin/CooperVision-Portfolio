-- Create the table to hold the raw data
CREATE TABLE supply_chain_data (
    warehouse_inventory_level DECIMAL(12,4),       
    handling_equipment_availability DECIMAL(12,4), 
    order_fulfillment_status DECIMAL(12,4),       
    weather_condition_severity DECIMAL(12,4),      
    shipping_costs DECIMAL(12,4),                 
    supplier_reliability_score DECIMAL(6,4),       
    lead_time_days DECIMAL(6,4),                  
    historical_demand DECIMAL(12,4),             
    cargo_condition_status DECIMAL(12,4),         
    route_risk_level DECIMAL(12,4),           
    customs_clearance_time DECIMAL(6,4),       
    disruption_likelihood_score DECIMAL(6,4),    
    delay_probability DECIMAL(6,4),              
    risk_classification VARCHAR(50),               
    delivery_time_deviation DECIMAL(8,4),         
    product_id VARCHAR(20),                        
    supplier_id VARCHAR(30),                      
    supplier_country VARCHAR(50)                  
);

-- Test Table

-- Test the table creation
SELECT * FROM supply_chain_data LIMIT 10;
