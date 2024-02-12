-- Active: 1707395589683@@127.0.0.1@5432@online_store

CREATE TABLE "Clients"(
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100),
    "address" VARCHAR(255),
    "email" VARCHAR(100),
    "phone" VARCHAR(20)
);
CREATE TABLE "Products" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255),
    "description" TEXT,
    "price" NUMERIC(10, 2),
    "category" VARCHAR(100)
);

CREATE TABLE "Orders" (
    "id" SERIAL PRIMARY KEY,
    "client_id" INTEGER REFERENCES "Clients"("id"),
    "status" VARCHAR(50),
    "order_date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "Order_Details" (
    "order_id" INTEGER REFERENCES "Orders"("id"),
    "product_id" INTEGER REFERENCES "Products"("id"),
    "quantity" INTEGER,
    PRIMARY KEY ("order_id", "product_id")
);

CREATE TABLE "Payments" (
    "id" SERIAL PRIMARY KEY,
    "order_id" INTEGER REFERENCES "Orders"("id"),
    "amount" NUMERIC(10, 2),
    "payment_date" TIMESTAMP
);

CREATE USER yurii WITH PASSWORD 'qwerty';

CREATE ROLE buyer;
GRANT SELECT ("name", "address", "email", "phone") ON "Clients" TO buyer;
GRANT UPDATE ("name", "address", "email", "phone") ON "Clients" TO buyer;
GRANT SELECT ("name", "description", "price", "category") ON "Products" TO buyer;
GRANT SELECT ("status", "order_date") ON "Orders" TO buyer;
GRANT SELECT ("order_id", "product_id", "quantity") ON "Order_Details" TO buyer;
GRANT INSERT ON "Orders" TO buyer;
GRANT SELECT ("amount", "payment_date") ON "Payments" TO buyer;

GRANT buyer TO yurii;
