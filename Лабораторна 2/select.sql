-- Active: 1707395589683@@127.0.0.1@5432@online_store
SELECT "name", "id" FROM "Clients" WHERE "id" % 5 IN (1) AND "name" LIKE '%h';
SELECT * FROM "Clients" WHERE "name" = 'Brandyn Picken';
SELECT * FROM "Payments";
UPDATE "Clients" SET "address" = '123 Main Street' WHERE "id" = 4;
SELECT * FROM "Products" WHERE "category" = 'Casework';
SELECT * FROM "Orders" WHERE "id" % 7 IN (0);
INSERT INTO "Clients" ("id", "name", "address", "email", "phone")
SELECT 
    generate_series,
    'name' || generate_series,
    'address' || generate_series,
    'email' || generate_series || '@example.com',
    '1234567890'
FROM 
    generate_series(1001, 10000);

SELECT * FROM "Orders" WHERE "status" = 'pending';