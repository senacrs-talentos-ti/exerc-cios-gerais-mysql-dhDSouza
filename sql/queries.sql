
-- Criação do banco de dados Store
CREATE DATABASE Store;
USE Store;

-- Exercício 1 - Criação da tabela CLIENTS
CREATE TABLE CLIENTS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Exercício 2 - Criação da tabela PRODUCTS
CREATE TABLE PRODUCTS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Exercício 3 - Criação da tabela ORDERS
CREATE TABLE ORDERS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    order_date DATE NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES CLIENTS(id)
);

-- Exercício 4 - Criação da tabela ORDER_ITEMS
CREATE TABLE ORDER_ITEMS (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(id),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(id)
);

-- Exercício 5 - Inserção de dados nas tabelas CLIENTS e PRODUCTS
-- Inserção de dados na tabela CLIENTS
INSERT INTO CLIENTS (name, email) VALUES
('Cliente 1', 'cliente1@example.com'),
('Cliente 2', 'cliente2@example.com');

-- Inserção de dados na tabela PRODUCTS
INSERT INTO PRODUCTS (name, price) VALUES
('Produto 1', 10.00),
('Produto 2', 20.00),
('Produto 3', 30.00);

-- Exercício 6 - Inserção de dados na tabela ORDERS
-- Inserção de dados na tabela ORDERS
INSERT INTO ORDERS (client_id, order_date, total) VALUES
(1, '2024-01-01', 60.00),
(2, '2024-01-02', 30.00);

-- Exercício 7 - Inserção de dados na tabela ORDER_ITEMS
-- Inserção de dados na tabela ORDER_ITEMS
INSERT INTO ORDER_ITEMS (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 10.00),  -- 2x Produto 1
(1, 3, 1, 30.00),  -- 1x Produto 3
(2, 2, 1, 20.00);  -- 1x Produto 2

-- Exercício 8 - Atualização do preço de um produto e dos registros relacionados
-- Atualizando o preço do Produto 1
UPDATE PRODUCTS SET price = 15.00 WHERE id = 1;

-- Atualizando os registros relacionados na tabela ORDER_ITEMS
UPDATE ORDER_ITEMS SET price = 15.00 WHERE product_id = 1;

-- Exercício 9 - Deleção de um cliente e todos os pedidos relacionados
-- Deletando os pedidos relacionados ao Cliente 1
DELETE FROM ORDER_ITEMS WHERE order_id IN (SELECT id FROM ORDERS WHERE client_id = 1);
DELETE FROM ORDERS WHERE client_id = 1;

-- Deletando o Cliente 1
DELETE FROM CLIENTS WHERE id = 1;

-- Exercício 10 - Alteração da tabela CLIENTS para adicionar coluna birthdate
ALTER TABLE CLIENTS ADD birthdate DATE;

-- Exercício 11 - Consulta usando JOIN para listar pedidos com nomes dos clientes e produtos
SELECT
    ORDERS.id AS order_id,
    CLIENTS.name AS client_name,
    PRODUCTS.name AS product_name,
    ORDER_ITEMS.quantity,
    ORDER_ITEMS.price
FROM
    ORDERS
JOIN
    CLIENTS ON ORDERS.client_id = CLIENTS.id
JOIN
    ORDER_ITEMS ON ORDERS.id = ORDER_ITEMS.order_id
JOIN
    PRODUCTS ON ORDER_ITEMS.product_id = PRODUCTS.id;

-- Exercício 12 - Consulta usando LEFT JOIN para listar clientes e seus pedidos, incluindo clientes sem pedidos
SELECT
    CLIENTS.name AS client_name,
    ORDERS.id AS order_id,
    ORDERS.order_date,
    ORDERS.total
FROM
    CLIENTS
LEFT JOIN
    ORDERS ON CLIENTS.id = ORDERS.client_id;

-- Exercício 13 - Consulta usando RIGHT JOIN para listar produtos e os pedidos que os contêm, incluindo produtos não pedidos
SELECT
    PRODUCTS.name AS product_name,
    ORDER_ITEMS.order_id,
    ORDER_ITEMS.quantity,
    ORDER_ITEMS.price
FROM
    PRODUCTS
RIGHT JOIN
    ORDER_ITEMS ON PRODUCTS.id = ORDER_ITEMS.product_id;

-- Exercício 14 - Funções de agregação para obter total de vendas e quantidade de itens vendidos
SELECT
    SUM(total) AS total_sales,
    SUM(quantity) AS total_items_sold
FROM
    ORDER_ITEMS;

-- Exercício 15 - Listar todos os clientes e a quantidade total de pedidos realizados por cada um
SELECT
    CLIENTS.name AS client_name,
    COUNT(ORDERS.id) AS total_orders
FROM
    CLIENTS
LEFT JOIN
    ORDERS ON CLIENTS.id = ORDERS.client_id
GROUP BY
    CLIENTS.id
ORDER BY
    total_orders DESC;

-- Exercício 16 - Listar todos os produtos e a quantidade total de cada produto vendido
SELECT
    PRODUCTS.name AS product_name,
    SUM(ORDER_ITEMS.quantity) AS total_quantity_sold
FROM
    PRODUCTS
LEFT JOIN
    ORDER_ITEMS ON PRODUCTS.id = ORDER_ITEMS.product_id
GROUP BY
    PRODUCTS.id
ORDER BY
    total_quantity_sold DESC;

-- Exercício 17 - Listar todos os clientes e o valor total gasto por cada um
SELECT
    CLIENTS.name AS client_name,
    SUM(ORDERS.total) AS total_spent
FROM
    CLIENTS
LEFT JOIN
    ORDERS ON CLIENTS.id = ORDERS.client_id
GROUP BY
    CLIENTS.id
ORDER BY
    total_spent DESC;

-- Exercício 18 - Listar os 3 produtos mais vendidos e o total de vendas de cada um
SELECT
    PRODUCTS.name AS product_name,
    SUM(ORDER_ITEMS.quantity) AS total_quantity_sold,
    SUM(ORDER_ITEMS.price * ORDER_ITEMS.quantity) AS total_sales
FROM
    PRODUCTS
JOIN
    ORDER_ITEMS ON PRODUCTS.id = ORDER_ITEMS.product_id
GROUP BY
    PRODUCTS.id
ORDER BY
    total_quantity_sold DESC
LIMIT 3;

-- Exercício 19 - Listar os 3 clientes que mais gastaram e o total gasto por cada um
SELECT
    CLIENTS.name AS client_name,
    SUM(ORDERS.total) AS total_spent
FROM
    CLIENTS
JOIN
    ORDERS ON CLIENTS.id = ORDERS.client_id
GROUP BY
    CLIENTS.id
ORDER BY
    total_spent DESC
LIMIT 3;

-- Exercício 20 - Listar a média de quantidade de produtos por pedido para cada cliente
SELECT
    CLIENTS.name AS client_name,
    AVG(ORDER_ITEMS.quantity) AS average_quantity_per_order
FROM
    CLIENTS
JOIN
    ORDERS ON CLIENTS.id = ORDERS.client_id
JOIN
    ORDER_ITEMS ON ORDERS.id = ORDER_ITEMS.order_id
GROUP BY
    CLIENTS.id;

-- Exercício 21 - Listar o total de pedidos e o total de clientes por mês
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(DISTINCT ORDERS.id) AS total_orders,
    COUNT(DISTINCT ORDERS.client_id) AS total_clients
FROM
    ORDERS
GROUP BY
    month;

-- Exercício 22 - Listar os produtos que nunca foram vendidos
SELECT
    PRODUCTS.name AS product_name
FROM
    PRODUCTS
LEFT JOIN
    ORDER_ITEMS ON PRODUCTS.id = ORDER_ITEMS.product_id
WHERE
    ORDER_ITEMS.product_id IS NULL;

-- Exercício 23 - Listar os pedidos que contêm mais de 2 itens diferentes
SELECT
    ORDER_ITEMS.order_id
FROM
    ORDER_ITEMS
GROUP BY
    ORDER_ITEMS.order_id
HAVING
    COUNT(DISTINCT ORDER_ITEMS.product_id) > 2;

-- Exercício 24 - Listar os clientes que fizeram pedidos no último mês
SELECT
    DISTINCT CLIENTS.name AS client_name
FROM
    CLIENTS
JOIN
    ORDERS ON CLIENTS.id = ORDERS.client_id
WHERE
    ORDERS.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Exercício 25 - Listar os clientes com o maior valor médio por pedido
SELECT
    CLIENTS.name AS client_name,
    AVG(ORDERS.total) AS average_order_value
FROM
    CLIENTS
JOIN
    ORDERS ON CLIENTS.id = ORDERS.client_id
GROUP BY
    CLIENTS.id
ORDER BY
    average_order_value DESC;
