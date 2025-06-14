-- VIEWS
-- Número de empregados por departamento e localidade
CREATE VIEW vw_empregados_por_departamento_localidade AS
SELECT d.nome AS departamento, d.localidade, COUNT(e.id_empregado) AS total_empregados
FROM departamentos d
JOIN empregados e ON d.id_departamento = e.id_departamento
GROUP BY d.nome, d.localidade;

--Lista de departamentos e seus gerentes

CREATE VIEW vw_departamentos_gerentes AS
SELECT d.nome AS departamento, e.nome AS gerente
FROM departamentos d
JOIN empregados e ON d.id_gerente = e.id_empregado;

--Projetos com maior número de empregados

CREATE VIEW vw_projetos_com_mais_empregados AS
SELECT p.nome AS projeto, COUNT(ep.id_empregado) AS total_empregados
FROM projetos p
JOIN empregado_projeto ep ON p.id_projeto = ep.id_projeto
GROUP BY p.nome
ORDER BY total_empregados DESC;

--Lista de projetos, departamentos e gerentes

CREATE VIEW vw_projetos_departamentos_gerentes AS
SELECT p.nome AS projeto, d.nome AS departamento, e.nome AS gerente
FROM projetos p
JOIN departamentos d ON p.id_departamento = d.id_departamento
JOIN empregados e ON d.id_gerente = e.id_empregado;

--Empregados que possuem dependentes e se são gerentes

CREATE VIEW vw_empregados_dependentes_gerentes AS
SELECT e.nome AS empregado, e.is_gerente, COUNT(d.id_dependente) AS total_dependentes
FROM empregados e
JOIN dependentes d ON e.id_empregado = d.id_empregado
GROUP BY e.nome, e.is_gerente;

--PERMISSÕES

-- Usuário GERENTE pode acessar informações sensíveis:
GRANT SELECT ON vw_empregados_por_departamento_localidade TO 'gerente'@'%';
GRANT SELECT ON vw_departamentos_gerentes TO 'gerente'@'%';
GRANT SELECT ON vw_projetos_departamentos_gerentes TO 'gerente'@'%';
GRANT SELECT ON vw_empregados_dependentes_gerentes TO 'gerente'@'%';

-- Usuário EMPLOYEE tem visão limitada:
GRANT SELECT ON vw_projetos_com_mais_empregados TO 'employee'@'%';

--TRIGGERS PARA E-COMMERCE
--Trigger BEFORE DELETE - manter histórico ao excluir conta

DELIMITER $$

CREATE TRIGGER trg_before_delete_usuario
BEFORE DELETE ON usuarios
FOR EACH ROW
BEGIN
    INSERT INTO log_exclusao_usuarios (id_usuario, nome)
    VALUES (OLD.id_usuario, OLD.nome);
END$$

DELIMITER ;

--Trigger BEFORE UPDATE - log de atualização de salário

DELIMITER $$

CREATE TRIGGER trg_before_update_salario
BEFORE UPDATE ON colaboradores
FOR EACH ROW
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO log_salario (id_colaborador, salario_anterior, novo_salario)
        VALUES (OLD.id_colaborador, OLD.salario, NEW.salario);
    END IF;
END$$

DELIMITER ;
