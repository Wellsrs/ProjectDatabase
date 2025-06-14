--Cenário: COMPANY

--Qual o departamento com maior número de pessoas?

-- Índice criado na coluna de junção
CREATE INDEX idx_funcionarios_departamento ON funcionarios(id_departamento);

-- Query
SELECT d.nome, COUNT(f.id_funcionario) AS total_funcionarios
FROM departamentos d
JOIN funcionarios f ON d.id_departamento = f.id_departamento
GROUP BY d.nome
ORDER BY total_funcionarios DESC
LIMIT 1;

-- Justificativa:
-- O índice `idx_funcionarios_departamento` é do tipo B-TREE (default),
-- ideal para otimizar joins e agrupamentos nesta coluna de chave estrangeira.

--Quais são os departamentos por cidade?

-- Índice na cidade, que é o campo de filtragem
CREATE INDEX idx_departamentos_cidade ON departamentos(cidade);

-- Query
SELECT cidade, GROUP_CONCAT(nome) AS departamentos
FROM departamentos
GROUP BY cidade;

-- Justificativa:
-- Esse índice otimiza agrupamentos e filtros por cidade, campo com alta cardinalidade.

--Relação de empregados por departamento
-- Já utilizamos o índice `idx_funcionarios_departamento`

-- Query
SELECT d.nome AS departamento, f.nome AS funcionario
FROM funcionarios f
JOIN departamentos d ON d.id_departamento = f.id_departamento;

-- Justificativa:
-- A junção com `id_departamento` já está otimizada pelo índice anterior.


--Cenário: E-COMMERCE

--PROCEDURE - Manipulação Company

DELIMITER $$

CREATE PROCEDURE sp_gerenciar_funcionario (
    IN p_opcao INT,
    IN p_id_funcionario INT,
    IN p_nome VARCHAR(100),
    IN p_id_departamento INT
)
BEGIN
    CASE
        WHEN p_opcao = 1 THEN
            INSERT INTO funcionarios (id_funcionario, nome, id_departamento)
            VALUES (p_id_funcionario, p_nome, p_id_departamento);
        WHEN p_opcao = 2 THEN
            UPDATE funcionarios
            SET nome = p_nome, id_departamento = p_id_departamento
            WHERE id_funcionario = p_id_funcionario;
        WHEN p_opcao = 3 THEN
            DELETE FROM funcionarios
            WHERE id_funcionario = p_id_funcionario;
        WHEN p_opcao = 4 THEN
            SELECT * FROM funcionarios WHERE id_funcionario = p_id_funcionario;
    END CASE;
END$$

DELIMITER ;

--PROCEDURE - Manipulação E-commerce

DELIMITER $$

CREATE PROCEDURE sp_gerenciar_pedido (
    IN p_opcao INT,
    IN p_id_pedido INT,
    IN p_id_cliente INT,
    IN p_data_pedido DATE,
    IN p_valor_total DECIMAL(10,2)
)
BEGIN
    CASE
        WHEN p_opcao = 1 THEN
            INSERT INTO pedidos (id_pedido, id_cliente, data_pedido, valor_total)
            VALUES (p_id_pedido, p_id_cliente, p_data_pedido, p_valor_total);
        WHEN p_opcao = 2 THEN
            UPDATE pedidos
            SET id_cliente = p_id_cliente, data_pedido = p_data_pedido, valor_total = p_valor_total
            WHERE id_pedido = p_id_pedido;
        WHEN p_opcao = 3 THEN
            DELETE FROM pedidos WHERE id_pedido = p_id_pedido;
        WHEN p_opcao = 4 THEN
            SELECT * FROM pedidos WHERE id_pedido = p_id_pedido;
    END CASE;
END$$

DELIMITER ;
