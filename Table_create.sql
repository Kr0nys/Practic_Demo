CREATE TABLE customer (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	inn VARCHAR(20),
	addres VARCHAR(255),
	phone VARCHAR(20) NOT NULL,
	salesman BOOLEAN DEFAULT False,
	buyer BOOLEAN DEFAULT False,
	CONSTRAINT customer_inn_unique UNIQUE (inn)
);

CREATE TABLE executor (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	inn VARCHAR(20),
	addres VARCHAR(255),
	phone VARCHAR(20) NOT NULL,
	CONSTRAINT executor_inn_unique UNIQUE (inn)
);

CREATE TABLE material (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	code VARCHAR(50) NOT NULL UNIQUE,
	unit VARCHAR(20) NOT NULL
);

CREATE TABLE product (
	id SERIAL PRIMARY KEY,
	code VARCHAR(50) NOT NULL UNIQUE,
	name VARCHAR(255) NOT NULL,
	unit VARCHAR(20) NOT NULL
);

CREATE TABLE specification (
	id SERIAL PRIMARY KEY,
	name VARCHAR (255) NOT NULL,
	product_id INTEGER NOT NULL,
	CONSTRAINT fk_specification_product
		FOREIGN KEY (product_id)
		REFERENCES product(id)
		ON DELETE RESTRICT,
	CONSTRAINT unique_specification_product UNIQUE (product_id, name)
);

CREATE TABLE specification_composition (
	id SERIAL PRIMARY KEY,
	spec_id INTEGER NOT NULL,
	material_id INTEGER NOT NULL,
	quantity DECIMAL(10, 3) NOT NULL CHECK (quantity > 0),
	CONSTRAINT fk_spec_comp_spec
		FOREIGN KEY (spec_id)
		REFERENCES specification(id)
		ON DELETE CASCADE,
	CONSTRAINT fk_spec_comp_material
		FOREIGN KEY (material_id)
		REFERENCES material(id)
		ON DELETE RESTRICT,
	CONSTRAINT unique_spec_material UNIQUE (spec_id, material_id)
);

CREATE TABLE production (
	id SERIAL PRIMARY KEY,
	number VARCHAR(50) NOT NULL,
	date DATE NOT NULL,
	specification_id INTEGER NOT NULL,
	CONSTRAINT fk_production_spec
		FOREIGN KEY (specification_id)
		REFERENCES specification(id)
		ON DELETE RESTRICT,
	CONSTRAINT unique_product_number UNIQUE (number)
);

CREATE TABLE production_composition (
	id SERIAL PRIMARY KEY,
	production_id INTEGER NOT NULL,
	material_id INTEGER NOT NULL,
	quantity_used DECIMAL(10, 3) NOT NULL CHECK (quantity_used >= 0),
	CONSTRAINT fk_prod_comp_production
		FOREIGN KEY (production_id)
		REFERENCES production(id)
		ON DELETE CASCADE,
	CONSTRAINT fk_prod_comp_material
		FOREIGN KEY (material_id)
		REFERENCES material(id)
		ON DELETE RESTRICT
);

CREATE TABLE customer_order (
	id SERIAL PRIMARY KEY,
	order_number VARCHAR(50) NOT NULL,
	date DATE NOT NULL,
	executor_id INTEGER,
	customer_id INTEGER NOT NULL,
	CONSTRAINT fk_orders_executor
		FOREIGN KEY (executor_id)
		REFERENCES executor(id)
		ON DELETE SET NULL,
	CONSTRAINT fk_orders_customer
		FOREIGN KEY (customer_id)
		REFERENCES customer(id)
		ON DELETE RESTRICT,
	CONSTRAINT unique_order_number UNIQUE (order_number)
);

CREATE TABLE order_items (
	id SERIAL PRIMARY KEY,
	product_id INTEGER NOT NULL,
	quantity DECIMAL(10, 3) NOT NULL CHECK (quantity > 0),
	price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
	order_id INTEGER NOT NULL,
	CONSTRAINT fk_order_items_product
		FOREIGN KEY (product_id)
		REFERENCES product(id)
		ON DELETE RESTRICT,
	CONSTRAINT fk_order_items_orders
		FOREIGN KEY (order_id)
		REFERENCES customer_order(id)
		ON DELETE CASCADE
);

CREATE TABLE price (
	id SERIAL PRIMARY KEY,
	product_id INTEGER,
	material_id INTEGER,
	cost DECIMAL(10, 2) NOT NULL CHECK (cost >= 0),
	CONSTRAINT fk_price_product
		FOREIGN KEY (product_id)
		REFERENCES product(id)
		ON DELETE CASCADE,
	CONSTRAINT fk_price_material
		FOREIGN KEY (material_id)
		REFERENCES material(id)
		ON DELETE CASCADE,
	CONSTRAINT check_prices_item CHECK (
        (product_id IS NOT NULL AND material_id IS NULL) OR
        (product_id IS NULL AND material_id IS NOT NULL)
    )
);