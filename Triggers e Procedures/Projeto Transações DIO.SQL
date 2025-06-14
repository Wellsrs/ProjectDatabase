--TRANSAÇÕES (Manual com COMMIT/ROLLBACK)

-- Desativar autocommit
SET autocommit = 0;

START TRANSACTION;

-- Atualiza valor total do pedido
UPDATE pedidos SET valor_total = 450.00 WHERE id_pedido = 1;

-- Atualiza saldo do cliente
UPDATE clientes SET saldo = saldo - 450.00 WHERE id_cliente = 1;

-- Verificação (Exemplo: o saldo não pode ser negativo)
SELECT saldo FROM clientes WHERE id_cliente = 1;

-- COMMIT se tudo OK
COMMIT;

-- Se algum erro ocorrer:
-- ROLLBACK;

--TRANSAÇÕES COM PROCEDURE + TRATAMENTO DE ERROS

DELIMITER $$

CREATE PROCEDURE sp_transferir_credito (
    IN p_origem INT,
    IN p_destino INT,
    IN p_valor DECIMAL(10,2)
)
BEGIN
    DECLARE erro BOOLEAN DEFAULT FALSE;
    DECLARE saldo_origem DECIMAL(10,2);

    START TRANSACTION;

    -- Verifica saldo
    SELECT saldo INTO saldo_origem FROM clientes WHERE id_cliente = p_origem;

    IF saldo_origem < p_valor THEN
        SET erro = TRUE;
    ELSE
        UPDATE clientes SET saldo = saldo - p_valor WHERE id_cliente = p_origem;
        UPDATE clientes SET saldo = saldo + p_valor WHERE id_cliente = p_destino;
    END IF;

    IF erro THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END$$

DELIMITER ;

--BACKUP E RECOVERY
--Backup com mysqldump
# Backup do banco e-commerce com procedures, eventos, triggers
mysqldump -u root -p e_commerce --routines --triggers --events > e_commerce_backup.sql

--Recovery (Restaurar Backup)
mysql -u root -p e_commerce < e_commerce_backup.sql
