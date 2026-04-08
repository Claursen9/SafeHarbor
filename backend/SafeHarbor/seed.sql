--Note: Core entity data (Residents, Safehouses, Metrics) is imported via CSV files to optimize performance


-- 1. LOOKUP DATA (Required for dropdowns/logic)
INSERT INTO "roles" ("role_name") VALUES 
('Administrator'), ('Social Worker'), ('Case Manager'), ('Safehouse Staff'), ('Partner Representative');

INSERT INTO "status_states" ("status_name") VALUES 
('Active'), ('Inactive'), ('Pending'), ('Closed'), ('On Hold');

INSERT INTO "locations" ("location_name", "address") VALUES 
('Luzon Head Office', 'Quezon City, Metro Manila'),
('Visayas Regional Center', 'Cebu City, Cebu'),
('Mindanao Operations Hub', 'Davao City, Davao del Sur');

-- 2. USER & STAFF DATA (Your login accounts)
INSERT INTO "users" ("first_name", "last_name", "email", "password_hash", "role_id") VALUES 
('Kathryn', 'Admin', 'admin@safeharbor.int', '$2b$12$K8p5...', 1);

INSERT INTO "staff_members" ("first_name", "last_name", "email", "role_id", "location_id") VALUES 
('Maria', 'Concepcion', 'm.concepcion@safeharbor.int', 2, 1);