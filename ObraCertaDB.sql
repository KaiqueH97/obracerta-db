CREATE DATABASE IF NOT EXISTS obracerta_db CHARACTER SET utf8mb4 COLLATE UTF8MB4_UNICODE_CI;
USE obracerta_db;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE projetos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    progresso INT CHECK (progresso >= 0 AND progresso <= 100),
    usuario_id INT NOT NULL,
    cliente_id INT NOT NULL,
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT,
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT
);

CREATE TABLE tarefas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDENTE',
    projeto_id INT NOT NULL,
    CONSTRAINT fk_projeto_tarefa FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE
);

CREATE TABLE despesas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item VARCHAR(100) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_compra DATE NOT NULL,
    projeto_id INT NOT NULL,
    CONSTRAINT fk_projeto_despesa FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE
);

INSERT INTO usuarios (nome, email, senha) VALUES
('Kaique H.', 'kaique@obracerta.com', 'hash123'), ('Fernanda S.', 'fernanda@obracerta.com', 'hash123'),
('Gabriel M.', 'gabriel@obracerta.com', 'hash123'), ('Lucas T.', 'lucas@k.com', 'hash123'),
('Mariana B.', 'mariana@k.com', 'hash123'), ('João P.', 'joao@k.com', 'hash123'),
('Carlos E.', 'carlos@k.com', 'hash123'), ('Ana C.', 'ana@k.com', 'hash123'),
('Pedro R.', 'pedro@k.com', 'hash123'), ('Juliana F.', 'juliana@k.com', 'hash123');

INSERT INTO clientes (nome, telefone, cpf_cnpj) VALUES
('Construtora Alfa', '11999990001', '11111111000100'), ('Condomínio Bela Vista', '11999990002', '22222222000100'),
('Roberto Almeida', '11999990003', '33333333333'), ('Sonia Marques', '11999990004', '44444444444'),
('Empresa Beta', '11999990005', '55555555000100'), ('Varejo Gama', '11999990006', '66666666000100'),
('Fernando Costa', '11999990007', '77777777777'), ('Clínica Saúde', '11999990008', '88888888000100'),
('Padaria Pão Quente', '11999990009', '99999999000100'), ('Escola Futuro', '11999990010', '10101010000100');

INSERT INTO projetos (titulo, descricao, progresso, usuario_id, cliente_id) VALUES
('Reforma Cozinha', 'Troca de piso e armários', 20, 1, 3), ('Construção Muro', 'Muro de arrimo', 100, 1, 1),
('Pintura Externa', 'Pintura fachada', 50, 2, 2), ('Instalação Elétrica', 'Fiação nova', 0, 3, 4),
('Galpão Industrial', 'Estrutura metálica', 80, 1, 5), ('Reforma Banheiro', 'Impermeabilização', 10, 2, 6),
('Piscina Condomínio', 'Escavação e alvenaria', 30, 3, 7), ('Telhado Clínica', 'Troca de telhas', 90, 1, 8),
('Fachada Padaria', 'Letreiro e vitrine', 100, 2, 9), ('Quadra Escola', 'Piso e alambrado', 60, 3, 10);

INSERT INTO tarefas (descricao, status, projeto_id) VALUES
('Comprar piso', 'CONCLUIDO', 1), ('Demolir parede', 'PENDENTE', 1),
('Fazer fundação', 'CONCLUIDO', 2), ('Levantar blocos', 'CONCLUIDO', 2),
('Lixar paredes', 'EM_ANDAMENTO', 3), ('Aplicar selador', 'PENDENTE', 3),
('Passar conduítes', 'PENDENTE', 4), ('Soldar estrutura', 'EM_ANDAMENTO', 5),
('Impermeabilizar chão', 'PENDENTE', 6), ('Escavar buraco', 'EM_ANDAMENTO', 7);

INSERT INTO despesas (item, valor, data_compra, projeto_id) VALUES
('Porcelanato', 1500.00, '2026-03-01', 1), ('Argamassa', 200.00, '2026-03-02', 1),
('Cimento', 800.00, '2026-02-15', 2), ('Tijolos', 1200.00, '2026-02-16', 2),
('Tinta Acrílica', 950.00, '2026-03-10', 3), ('Fios 2.5mm', 400.00, '2026-04-01', 4),
('Vigas Metálicas', 5000.00, '2026-01-20', 5), ('Impermeabilizante', 350.00, '2026-04-05', 6),
('Concreto Usinado', 3000.00, '2026-03-20', 7), ('Telhas', 1800.00, '2026-02-28', 8);

INSERT INTO tarefas (descricao, status, projeto_id)
VALUES ('Instalar tomadas', 'PENDENTE', (SELECT id FROM projetos WHERE titulo = 'Instalação Elétrica'));

INSERT INTO despesas (item, valor, data_compra, projeto_id)
VALUES ('Pia de mármore', 850.00, CURDATE(), (SELECT id FROM projetos WHERE cliente_id = (SELECT id FROM clientes WHERE nome = 'Roberto Almeida')));

INSERT INTO tarefas (descricao, status, projeto_id)
VALUES ('Revisão final', 'PENDENTE', (SELECT id FROM projetos WHERE progresso < 100 ORDER BY progresso DESC LIMIT 1));

INSERT INTO projetos (titulo, descricao, progresso, usuario_id, cliente_id)
SELECT 'Manutenção Muro', 'Reparo pós chuva', 0, usuario_id, cliente_id 
FROM projetos WHERE titulo = 'Construção Muro' LIMIT 1;

INSERT INTO despesas (item, valor, data_compra, projeto_id)
VALUES ('Equipamento EPI', 120.00, CURDATE(), (SELECT id FROM projetos WHERE usuario_id = (SELECT id FROM usuarios WHERE email = 'kaique@obracerta.com') ORDER BY id DESC LIMIT 1));

UPDATE projetos SET progresso = 45 WHERE titulo = 'Reforma Cozinha';

UPDATE tarefas SET status = 'CONCLUIDO' WHERE projeto_id IN (SELECT id FROM projetos WHERE progresso = 100);

UPDATE clientes SET telefone = '11988887777' WHERE cpf_cnpj = '11111111000100';

UPDATE despesas SET valor = valor * 0.90 WHERE projeto_id = (SELECT id FROM projetos WHERE cliente_id = (SELECT id FROM clientes WHERE nome = 'Empresa Beta'));

UPDATE usuarios SET ativo = FALSE WHERE id NOT IN (SELECT DISTINCT usuario_id FROM projetos);

DELETE FROM despesas WHERE valor < 50.00;

DELETE FROM tarefas WHERE descricao = 'Passar conduítes' AND status = 'PENDENTE';

DELETE FROM tarefas WHERE projeto_id IN (SELECT id FROM projetos WHERE progresso = 100);

DELETE FROM projetos WHERE progresso = 0 AND id NOT IN (SELECT projeto_id FROM tarefas);

DELETE FROM clientes WHERE id NOT IN (SELECT DISTINCT cliente_id FROM projetos) AND nome = 'Escola Futuro';

SELECT p.titulo, u.nome AS gestor, c.nome AS cliente, p.progresso 
FROM projetos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN clientes c ON p.cliente_id = c.id;

SELECT p.titulo, SUM(d.valor) AS total_gasto 
FROM projetos p
INNER JOIN despesas d ON p.id = d.projeto_id
GROUP BY p.titulo;

SELECT t.descricao, t.status, p.titulo 
FROM tarefas t
INNER JOIN projetos p ON t.projeto_id = p.id
INNER JOIN clientes c ON p.cliente_id = c.id
WHERE c.nome = 'Roberto Almeida';

SELECT d.data_compra, d.item, d.valor, c.nome AS pagador
FROM despesas d
INNER JOIN projetos p ON d.projeto_id = p.id
INNER JOIN clientes c ON p.cliente_id = c.id
ORDER BY d.data_compra DESC;

SELECT u.nome, COUNT(t.id) AS tarefas_pendentes
FROM usuarios u
INNER JOIN projetos p ON u.id = p.usuario_id
INNER JOIN tarefas t ON p.id = t.projeto_id
WHERE t.status = 'PENDENTE'
GROUP BY u.nome;

CREATE VIEW vw_resumo_obras AS
SELECT p.id, p.titulo, p.progresso, u.nome AS gestor, c.nome AS cliente
FROM projetos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN clientes c ON p.cliente_id = c.id;

CREATE VIEW vw_financeiro_cliente AS
SELECT c.nome, SUM(d.valor) AS total_investido
FROM clientes c
INNER JOIN projetos p ON c.id = p.cliente_id
INNER JOIN despesas d ON p.id = d.projeto_id
GROUP BY c.nome;

CREATE VIEW vw_alertas_tarefas AS
SELECT t.descricao AS tarefa, p.titulo AS obra, u.nome AS responsavel
FROM tarefas t
INNER JOIN projetos p ON t.projeto_id = p.id
INNER JOIN usuarios u ON p.usuario_id = u.id
WHERE t.status = 'PENDENTE';

CREATE VIEW vw_compras_recentes AS
SELECT d.item, d.valor, p.titulo, c.nome AS cliente
FROM despesas d
INNER JOIN projetos p ON d.projeto_id = p.id
INNER JOIN clientes c ON p.cliente_id = c.id
WHERE d.data_compra >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

CREATE VIEW vw_desempenho_gestor AS
SELECT u.nome, AVG(p.progresso) AS progresso_medio, COUNT(p.id) AS total_projetos
FROM usuarios u
INNER JOIN projetos p ON u.id = p.usuario_id
GROUP BY u.nome;

-- 1. Uso de COUNT e IN: Conta quantos projetos cada gestor tem com progressos específicos.
SELECT gestor, COUNT(id) AS qtd_projetos
FROM vw_resumo_obras
WHERE progresso IN (0, 10, 50, 100)
GROUP BY gestor;

-- 2. Uso de SUM e BETWEEN: Soma o total investido por cliente dentro de uma faixa de valor.
SELECT nome AS cliente, SUM(total_investido) AS investimento_total
FROM vw_financeiro_cliente
WHERE total_investido BETWEEN 1000 AND 10000
GROUP BY nome
ORDER BY investimento_total DESC;

-- 3. Uso de AVG e WHERE: Média de progresso das obras gerenciadas por um usuário específico.
SELECT gestor, AVG(progresso) AS media_conclusao
FROM vw_resumo_obras
WHERE gestor = 'Kaique H.'
GROUP BY gestor;

-- 4. Uso de MAX e GROUP BY: Qual foi a compra de maior valor feita nos últimos 30 dias por projeto.
SELECT titulo AS obra, MAX(valor) AS maior_despesa
FROM vw_compras_recentes
GROUP BY titulo;

-- 5. Uso de MIN: Verifica qual é o menor progresso médio entre os gestores.
SELECT MIN(progresso_medio) AS pior_desempenho_medio
FROM vw_desempenho_gestor;

-- 1. Subquery no WHERE (IN): Busca o nome dos clientes que possuem projetos 100% concluídos.
SELECT nome FROM clientes 
WHERE id IN (SELECT cliente_id FROM projetos WHERE progresso = 100);

-- 2. Subquery Escalar no SELECT: Lista os projetos e traz o custo total de cada um direto na mesma linha.
SELECT titulo, 
       (SELECT COALESCE(SUM(valor), 0) FROM despesas WHERE projeto_id = projetos.id) AS custo_total 
FROM projetos;

-- 3. Subquery no WHERE (=): Busca todas as tarefas do projeto mais recente inserido no banco.
SELECT descricao, status FROM tarefas 
WHERE projeto_id = (SELECT MAX(id) FROM projetos);

-- 4. Subquery no FROM: Calcula a quantidade de tarefas por projeto e filtra os que têm mais de 1 tarefa.
SELECT sub.projeto_id, sub.total_tarefas 
FROM (SELECT projeto_id, COUNT(*) AS total_tarefas FROM tarefas GROUP BY projeto_id) AS sub 
WHERE sub.total_tarefas > 1;

-- 5. Subquery Aninhada: Lista despesas do projeto que pertence a um cliente específico ('Construtora Alfa').
SELECT item, valor FROM despesas 
WHERE projeto_id IN (SELECT id FROM projetos WHERE cliente_id = (SELECT id FROM clientes WHERE nome = 'Construtora Alfa'));

CREATE INDEX idx_clientes_nome ON clientes(nome);
CREATE INDEX idx_projetos_progresso ON projetos(progresso);
CREATE INDEX idx_tarefas_status ON tarefas(status);
CREATE INDEX idx_despesas_data ON despesas(data_compra);
CREATE INDEX idx_usuarios_ativo ON usuarios(ativo);

CREATE TABLE log_auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensagem VARCHAR(255) NOT NULL,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

-- 1. Procedure para inserir um novo cliente rapidamente
CREATE PROCEDURE sp_novo_cliente(IN p_nome VARCHAR(100), IN p_telefone VARCHAR(20), IN p_cpf_cnpj VARCHAR(20))
BEGIN
    INSERT INTO clientes (nome, telefone, cpf_cnpj) VALUES (p_nome, p_telefone, p_cpf_cnpj);
END //

-- 2. Procedure para atualizar o progresso de um projeto
CREATE PROCEDURE sp_atualizar_progresso(IN p_id INT, IN p_progresso INT)
BEGIN
    UPDATE projetos SET progresso = p_progresso WHERE id = p_id;
END //

-- 3. Procedure para registrar ações na tabela de auditoria
CREATE PROCEDURE sp_registrar_log(IN p_mensagem VARCHAR(255))
BEGIN
    INSERT INTO log_auditoria (mensagem) VALUES (p_mensagem);
END //

-- 4. Procedure para inativar um usuário
CREATE PROCEDURE sp_inativar_usuario(IN p_id INT)
BEGIN
    UPDATE usuarios SET ativo = FALSE WHERE id = p_id;
END //

-- 5. Procedure para concluir todas as tarefas de um projeto
CREATE PROCEDURE sp_concluir_tarefas_projeto(IN p_projeto_id INT)
BEGIN
    UPDATE tarefas SET status = 'CONCLUIDO' WHERE projeto_id = p_projeto_id AND status != 'CONCLUIDO';
END //

DELIMITER ;

DELIMITER //

-- 1. Função para calcular o total gasto de um projeto
CREATE FUNCTION fn_total_gasto(p_projeto_id INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT COALESCE(SUM(valor), 0) INTO v_total FROM despesas WHERE projeto_id = p_projeto_id;
    RETURN v_total;
END //

-- 2. Função para verificar o status de um projeto com base no progresso
CREATE FUNCTION fn_status_obra(p_progresso INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    IF p_progresso = 100 THEN RETURN 'FINALIZADA';
    ELSEIF p_progresso = 0 THEN RETURN 'NÃO INICIADA';
    ELSE RETURN 'EM ANDAMENTO';
    END IF;
END //

-- 3. Função para contar quantas tarefas pendentes um projeto possui
CREATE FUNCTION fn_tarefas_pendentes(p_projeto_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE v_qtd INT;
    SELECT COUNT(*) INTO v_qtd FROM tarefas WHERE projeto_id = p_projeto_id AND status = 'PENDENTE';
    RETURN v_qtd;
END //

-- 4. Função para formatar o nome do status da tarefa (tudo maiúsculo)
CREATE FUNCTION fn_formata_status(p_status VARCHAR(50)) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    RETURN UPPER(TRIM(p_status));
END //

-- 5. Função de validação: retorna 1 (Verdadeiro) se a despesa for maior que 0
CREATE FUNCTION fn_valida_valor(p_valor DECIMAL(10,2)) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    RETURN p_valor > 0;
END //

DELIMITER ;

DELIMITER //

-- 1. Impede a exclusão de um projeto que já começou (progresso > 0)
CREATE TRIGGER trg_impede_delete_projeto
BEFORE DELETE ON projetos
FOR EACH ROW
BEGIN
    IF OLD.progresso > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Projetos em andamento não podem ser excluídos!';
    END IF;
END //

-- 2. Garante que despesas negativas não sejam inseridas
CREATE TRIGGER trg_valida_despesa_negativa
BEFORE INSERT ON despesas
FOR EACH ROW
BEGIN
    IF NEW.valor <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valor da despesa deve ser maior que zero.';
    END IF;
END //

-- 3. Validação ao atualizar clientes: não pode remover o CPF/CNPJ
CREATE TRIGGER trg_protege_documento_cliente
BEFORE UPDATE ON clientes
FOR EACH ROW
BEGIN
    IF NEW.cpf_cnpj IS NULL OR NEW.cpf_cnpj = '' THEN
        SET NEW.cpf_cnpj = OLD.cpf_cnpj;
    END IF;
END //

-- 4. Força que a data de uma nova despesa não seja no futuro
CREATE TRIGGER trg_data_despesa_valida
BEFORE INSERT ON despesas
FOR EACH ROW
BEGIN
    IF NEW.data_compra > CURDATE() THEN
        SET NEW.data_compra = CURDATE();
    END IF;
END //

-- 5. Ao excluir uma tarefa, joga o texto num log de backup manual de segurança
CREATE TRIGGER trg_backup_tarefa_excluida
BEFORE DELETE ON tarefas
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (mensagem) VALUES (CONCAT('Tarefa excluída: ', OLD.descricao));
END //

DELIMITER ;

DELIMITER //

-- 1. Usa Procedure: Após inserir um novo projeto, grava no log usando a Procedure.
CREATE TRIGGER trg_log_novo_projeto
AFTER INSERT ON projetos
FOR EACH ROW
BEGIN
    CALL sp_registrar_log(CONCAT('Novo projeto cadastrado. ID: ', NEW.id));
END //

-- 2. Usa Procedure: Se o projeto for atualizado para 100%, conclui as tarefas usando Procedure.
CREATE TRIGGER trg_auto_conclui_tarefas
AFTER UPDATE ON projetos
FOR EACH ROW
BEGIN
    IF NEW.progresso = 100 AND OLD.progresso < 100 THEN
        CALL sp_concluir_tarefas_projeto(NEW.id);
    END IF;
END //

-- 3. Usa Function: Antes de inserir tarefa, formata o status usando a Function.
CREATE TRIGGER trg_formata_status_tarefa
BEFORE INSERT ON tarefas
FOR EACH ROW
BEGIN
    SET NEW.status = fn_formata_status(NEW.status);
END //

-- 4. Usa Function: Antes de inserir despesa, valida se o valor é positivo usando a Function.
CREATE TRIGGER trg_usa_fn_valida_valor
BEFORE INSERT ON despesas
FOR EACH ROW
BEGIN
    IF fn_valida_valor(NEW.valor) = FALSE THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro de Function: Valor inválido.';
    END IF;
END //

-- 5. Usa Function: Se tentar deletar um projeto, verifica se tem tarefas pendentes usando Function.
CREATE TRIGGER trg_verifica_pendencias_delete
BEFORE DELETE ON projetos
FOR EACH ROW
BEGIN
    IF fn_tarefas_pendentes(OLD.id) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir. Existem tarefas pendentes.';
    END IF;
END //

DELIMITER ;