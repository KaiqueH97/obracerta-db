-- ============================================================================
-- PROJETO INTEGRADOR: SISTEMA DE GERENCIAMENTO DE OBRAS - OBRACERTA
-- OBJETIVO: Criação, Automação, Auditoria e Otimização do Banco de Dados
-- ============================================================================

-- Criação do banco de dados utilizando charset e collate adequados para caracteres latinos e emojis
CREATE DATABASE IF NOT EXISTS obracerta_db CHARACTER SET utf8mb4 COLLATE UTF8MB4_UNICODE_CI;
USE obracerta_db;

-- ============================================================================
-- 1. CRIAÇÃO DAS TABELAS (DDL) E RESTRIÇÕES
-- ============================================================================

-- Tabela de Usuários (Gestores das obras)
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,                               -- Chave Primária Auto-incremento
    nome VARCHAR(100) NOT NULL,                                      -- Nome obrigatório
    email VARCHAR(100) UNIQUE NOT NULL,                              -- Email único (chave candidata) obrigatório
    senha VARCHAR(255) NOT NULL,                                     -- Senha com espaço para criptografia hash
    ativo BOOLEAN DEFAULT TRUE                                       -- Estado do usuário no sistema
);

-- Tabela de Clientes contratantes dos projetos
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,                               -- Chave Primária
    nome VARCHAR(100) NOT NULL,                                      -- Razão Social ou Nome do cliente
    telefone VARCHAR(20) NOT NULL,                                   -- Telefone comercial/pessoal
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL                             -- CPF ou CNPJ único obrigatório
);

-- Tabela de Projetos (Obras) gerenciados por Usuários para Clientes
CREATE TABLE projetos (
    id INT AUTO_INCREMENT PRIMARY KEY,                               -- Chave Primária
    titulo VARCHAR(150) NOT NULL,                                    -- Título descritivo da obra
    descricao TEXT,                                                  -- Detalhamento do escopo do projeto
    progresso INT CHECK (progresso >= 0 AND progresso <= 100),       -- Restrição CHECK: Garante valores de 0 a 100%
    usuario_id INT NOT NULL,                                         -- Chave Estrangeira para Usuários
    cliente_id INT NOT NULL,                                         -- Chave Estrangeira para Clientes
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT, -- Impede deleção de usuário com obra ativa
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT  -- Impede deleção de cliente com obra ativa
);

-- Tabela de Tarefas operacionais vinculadas aos projetos
CREATE TABLE tarefas (
    id INT AUTO_INCREMENT PRIMARY KEY,                               -- Chave Primária
    descricao VARCHAR(200) NOT NULL,                                 -- O que precisa ser feito
    status VARCHAR(50) DEFAULT 'PENDENTE',                           -- Estado atual da tarefa
    projeto_id INT NOT NULL,                                         -- Chave Estrangeira para Projetos
    CONSTRAINT fk_projeto_tarefa FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE -- Se o projeto sumir, limpa as tarefas
);

-- Tabela de Despesas financeiras de insumos ou mão de obra
CREATE TABLE despesas (
    id INT AUTO_INCREMENT PRIMARY KEY,                               -- Chave Primária
    item VARCHAR(100) NOT NULL,                                      -- Nome do insumo comprado
    valor DECIMAL(10, 2) NOT NULL,                                   -- Valor monetário com precisão decimal
    data_compra DATE NOT NULL,                                       -- Data do registro fiscal
    projeto_id INT NOT NULL,                                         -- Chave Estrangeira para Projetos
    CONSTRAINT fk_projeto_despesa FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE -- Cascata para exclusão lógica uniforme
);

-- ============================================================================
-- 2. INSERÇÃO DE DADOS (DML) - MINÍMO 10 REGISTROS POR TABELA
-- ============================================================================

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

-- ============================================================================
-- 3. EXEMPLOS OBRIGATÓRIOS DE INSERÇÕES COM SUBQUERIES (SUBSELECT)
-- ============================================================================

-- Subselect 1: Tarefa inserida buscando id pelo título do projeto
INSERT INTO tarefas (descricao, status, projeto_id)
VALUES ('Instalar tomadas', 'PENDENTE', (SELECT id FROM projetos WHERE titulo = 'Instalação Elétrica'));

-- Subselect 2: Despesa vinculada através do nome do cliente final
INSERT INTO despesas (item, valor, data_compra, projeto_id)
VALUES ('Pia de mármore', 850.00, CURDATE(), (SELECT id FROM projetos WHERE cliente_id = (SELECT id FROM clientes WHERE nome = 'Roberto Almeida')));

-- Subselect 3: Tarefa inserida no projeto ativo com menor progresso remanescente
INSERT INTO tarefas (descricao, status, projeto_id)
VALUES ('Revisão final', 'PENDENTE', (SELECT id FROM projetos WHERE progresso < 100 ORDER BY progresso DESC LIMIT 1));

-- Subselect 4: Cria um novo projeto copiando os responsáveis de uma obra existente
INSERT INTO projetos (titulo, descricao, progresso, usuario_id, cliente_id)
SELECT 'Manutenção Muro', 'Reparo pós chuva', 0, usuario_id, cliente_id 
FROM projetos WHERE titulo = 'Construção Muro' LIMIT 1;

-- Subselect 5: Insere despesa buscando o último projeto do gestor filtrado por e-mail
INSERT INTO despesas (item, valor, data_compra, projeto_id)
VALUES ('Equipamento EPI', 120.00, CURDATE(), (SELECT id FROM projetos WHERE usuario_id = (SELECT id FROM usuarios WHERE email = 'kaique@obracerta.com') ORDER BY id DESC LIMIT 1));

-- ============================================================================
-- 4. ATUALIZAÇÕES DE DADOS (UPDATE) COM DIFERENTES CONDIÇÕES
-- ============================================================================

-- Update 1: Condição direta por título
UPDATE projetos SET progresso = 45 WHERE titulo = 'Reforma Cozinha';

-- Update 2: Condição com subquery IN baseada no progresso global
UPDATE tarefas SET status = 'CONCLUIDO' WHERE projeto_id IN (SELECT id FROM projetos WHERE progresso = 100);

-- Update 3: Condição por identificador único de pessoa jurídica
UPDATE clientes SET telefone = '11988887777' WHERE cpf_cnpj = '11111111000100';

-- Update 4: Concessão de desconto financeiro usando subquery para encontrar o cliente
UPDATE despesas SET valor = valor * 0.90 WHERE projeto_id = (SELECT id FROM projetos WHERE cliente_id = (SELECT id FROM clientes WHERE nome = 'Empresa Beta'));

-- Update 5: Desativação de usuários sem obras sob sua responsabilidade
UPDATE usuarios SET ativo = FALSE WHERE id NOT IN (SELECT DISTINCT usuario_id FROM projetos);

-- ============================================================================
-- 5. REMOÇÃO DE DADOS (DELETE) RESPEITANDO A INTEGRIDADE
-- ============================================================================

-- Delete 1: Remoção de despesas de valores irrisórios
DELETE FROM despesas WHERE valor < 50.00;

-- Delete 2: Remoção de tarefa pendente específica por texto e status
DELETE FROM tarefas WHERE descricao = 'Passar conduítes' AND status = 'PENDENTE';

-- Delete 3: Limpeza de pendências de projetos integralmente finalizados
DELETE FROM tarefas WHERE projeto_id IN (SELECT id FROM projetos WHERE progresso = 100);

-- Delete 4: Exclusão de projetos travados em 0% sem tarefas listadas
DELETE FROM projetos WHERE progresso = 0 AND id NOT IN (SELECT projeto_id FROM tarefas);

-- Delete 5: Remoção de cliente inativo específico sem dependências de chaves
DELETE FROM clientes WHERE id NOT IN (SELECT DISTINCT cliente_id FROM projetos) AND nome = 'Escola Futuro';

-- ============================================================================
-- 6. CONSULTAS AVANÇADAS COM INNER JOIN
-- ============================================================================

-- Join 1: Relatório global de obras mapeando Gestores e Clientes correspondentes
SELECT p.titulo, u.nome AS gestor, c.nome AS cliente, p.progresso 
FROM projetos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN clientes c ON p.cliente_id = c.id;

-- Join 2: Consolidação financeira agrupando gastos agregados por obra
SELECT p.titulo, SUM(d.valor) AS total_gasto 
FROM proyectos p
INNER JOIN despesas d ON p.id = d.projeto_id
GROUP BY p.titulo;

-- Join 3: Listagem de tarefas ativas de um cliente físico específico
SELECT t.descricao, t.status, p.titulo 
FROM tarefas t
INNER JOIN projetos p ON t.projeto_id = p.id
INNER JOIN clientes c ON p.cliente_id = c.id
WHERE c.nome = 'Roberto Almeida';

-- Join 4: Linha do tempo reversa de fluxo de caixa com identificação de pagadores
SELECT d.data_compra, d.item, d.valor, c.nome AS pagador
FROM despesas d
INNER JOIN projetos p ON d.projeto_id = p.id
INNER JOIN clientes c ON p.cliente_id = c.id
ORDER BY d.data_compra DESC;

-- Join 5: Quantificação de gargalos operacionais (tarefas pendentes) por colaborador
SELECT u.nome, COUNT(t.id) AS tarefas_pendentes
FROM usuarios u
INNER JOIN projetos p ON u.id = p.usuario_id
INNER JOIN tarefas t ON p.id = t.projeto_id
WHERE t.status = 'PENDENTE'
GROUP BY u.nome;

-- ============================================================================
-- 7. CRIAÇÃO DE VIEWS A PARTIR DAS JUNÇÕES (MÍNIMO 5)
-- ============================================================================

-- View 1: Painel resumido estrutural de acompanhamento de obras
CREATE VIEW vw_resumo_obras AS
SELECT p.id, p.titulo, p.progresso, u.nome AS gestor, c.nome AS cliente
FROM projetos p
INNER JOIN usuarios u ON p.usuario_id = u.id
INNER JOIN clientes c ON p.cliente_id = c.id;

-- View 2: Consolidação de contas a pagar/investimentos por cliente
CREATE VIEW vw_financeiro_cliente AS
SELECT c.nome, SUM(d.valor) AS total_investido
FROM clientes c
INNER JOIN projetos p ON c.id = p.cliente_id
INNER JOIN despesas d ON p.id = d.projeto_id
GROUP BY c.nome;

-- View 3: Monitoramento ativo de alertas de gargalos operacionais
CREATE VIEW vw_alertas_tarefas AS
SELECT t.descricao AS tarefa, p.titulo AS obra, u.nome AS responsavel
FROM tarefas t
INNER JOIN projetos p ON t.projeto_id = p.id
INNER JOIN usuarios u ON p.usuario_id = u.id
WHERE t.status = 'PENDENTE';

-- View 4: Auditoria de auditoria fiscal de saídas dos últimos 30 dias
CREATE VIEW vw_compras_recentes AS
SELECT d.item, d.valor, p.titulo, c.nome AS cliente
FROM despesas d
INNER JOIN projetos p ON d.projeto_id = p.id
INNER JOIN clientes c ON p.cliente_id = c.id
WHERE d.data_compra >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- View 5: Avaliação de desempenho e volumetria por gestor de contas
CREATE VIEW vw_desempenho_gestor AS
SELECT u.nome, AVG(p.progresso) AS progresso_medio, COUNT(p.id) AS total_projetos
FROM usuarios u
INNER JOIN projetos p ON u.id = p.usuario_id
GROUP BY u.nome;

-- ============================================================================
-- 8. CONSULTAS COMPLEXAS EXTRAÍDAS DAS VIEWS (COUNT, SUM, AVG, MIN, MAX, ETC.)
-- ============================================================================

-- Consulta View 1: Filtro categórico usando COUNT e IN
SELECT gestor, COUNT(id) AS qtd_projetos
FROM vw_resumo_obras
WHERE progresso IN (0, 10, 50, 100)
GROUP BY gestor;

-- Consulta View 2: Monitoramento de faixas financeiras via SUM e BETWEEN
SELECT nome AS cliente, SUM(total_investido) AS investimento_total
FROM vw_financeiro_cliente
WHERE total_investido BETWEEN 1000 AND 10000
GROUP BY nome
ORDER BY investimento_total DESC;

-- Consulta View 3: Métrica de performance individual utilizando AVG e WHERE
SELECT gestor, AVG(progresso) AS media_conclusao
FROM vw_resumo_obras
WHERE gestor = 'Kaique H.'
GROUP BY gestor;

-- Consulta View 4: teto de despesas recentes via MAX e GROUP BY
SELECT titulo AS obra, MAX(valor) AS maior_despesa
FROM vw_compras_recentes
GROUP BY titulo;

-- Consulta View 5: Limiar inferior de progresso via função agregadora MIN
SELECT MIN(progresso_medio) AS pior_desempenho_medio
FROM vw_desempenho_gestor;

-- ============================================================================
-- 9. CONSULTAS COM SUBQUERIES AVANÇADAS (SELECT DENTRO DE SELECT)
-- ============================================================================

-- Subquery 1: Uso no WHERE com operador IN
SELECT nome FROM clientes 
WHERE id IN (SELECT cliente_id FROM projetos WHERE progresso = 100);

-- Subquery 2: Subquery Escalar diretamente na projeção do SELECT principal (Tratada com COALESCE)
SELECT titulo, 
       (SELECT COALESCE(SUM(valor), 0) FROM despesas WHERE projeto_id = projetos.id) AS custo_total 
FROM projetos;

-- Subquery 3: Uso no WHERE comparando valor com operador igual (=) dinâmico
SELECT descricao, status FROM tarefas 
WHERE projeto_id = (SELECT MAX(id) FROM projetos);

-- Subquery 4: Subquery estruturada na cláusula FROM agindo como tabela derivada
SELECT sub.projeto_id, sub.total_tarefas 
FROM (SELECT projeto_id, COUNT(*) AS total_tarefas FROM tarefas GROUP BY projeto_id) AS sub 
WHERE sub.total_tarefas > 1;

-- Subquery 5: Subquery totalmente aninhada em múltiplos níveis relacionais
SELECT item, valor FROM despesas 
WHERE projeto_id IN (SELECT id FROM projetos WHERE cliente_id = (SELECT id FROM clientes WHERE nome = 'Construtora Alfa'));

-- ============================================================================
-- 10. CRIAÇÃO DE ÍNDICES PARA OTIMIZAÇÃO (INDEX DDL)
-- ============================================================================
CREATE INDEX idx_clientes_nome ON clientes(nome);
CREATE INDEX idx_projetos_progresso ON projetos(progresso);
CREATE INDEX idx_tarefas_status ON tarefas(status);
CREATE INDEX idx_despesas_data ON despesas(data_compra);
CREATE INDEX idx_usuarios_ativo ON usuarios(ativo);

-- ============================================================================
-- 11. TABELA DE AUDITORIA E LOGS
-- ============================================================================
CREATE TABLE IF NOT EXISTS log_auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensagem VARCHAR(255) NOT NULL,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 12. PROCEDURES PARA AUTOMATAÇÃO (STORED PROCEDURES)
-- ============================================================================
DELIMITER //

-- Procedure 1: Cadastro padronizado de novos clientes
CREATE PROCEDURE sp_novo_cliente(IN p_nome VARCHAR(100), IN p_telefone VARCHAR(20), IN p_cpf_cnpj VARCHAR(20))
BEGIN
    INSERT INTO clientes (nome, telefone, cpf_cnpj) VALUES (p_nome, p_telefone, p_cpf_cnpj);
END //

-- Procedure 2: Atualização ágil de progresso de obras
CREATE PROCEDURE sp_atualizar_progresso(IN p_id INT, IN p_progresso INT)
BEGIN
    UPDATE projetos SET progresso = p_progresso WHERE id = p_id;
END //

-- Procedure 3: Centralização de escrituração de logs do sistema
CREATE PROCEDURE sp_registrar_log(IN p_mensagem VARCHAR(255))
BEGIN
    INSERT INTO log_auditoria (mensagem) VALUES (p_mensagem);
END //

-- Procedure 4: Revogação de acesso (Inativação) de usuários de forma lógica
CREATE PROCEDURE sp_inativar_usuario(IN p_id INT)
BEGIN
    UPDATE usuarios SET ativo = FALSE WHERE id = p_id;
END //

-- Procedure 5: Atualização massiva de encerramento de escopo de tarefas
CREATE PROCEDURE sp_concluir_tarefas_projeto(IN p_projeto_id INT)
BEGIN
    UPDATE tarefas SET status = 'CONCLUIDO' WHERE projeto_id = p_projeto_id AND status != 'CONCLUIDO';
END //

DELIMITER ;

-- ============================================================================
-- 13. FUNÇÕES DE REGRAS DE NEGÓCIO (UDF FUNCTIONS)
-- ============================================================================
DELIMITER //

-- Função 1: Retorna soma financeira de custos de um ID de projeto
CREATE FUNCTION fn_total_gasto(p_projeto_id INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT COALESCE(SUM(valor), 0) INTO v_total FROM despesas WHERE projeto_id = p_projeto_id;
    RETURN v_total;
END //

-- Função 2: Retorna rótulo de texto descritivo baseado no percentual da obra
CREATE FUNCTION fn_status_obra(p_progresso INT) RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    IF p_progresso = 100 THEN RETURN 'FINALIZADA';
    ELSEIF p_progresso = 0 THEN RETURN 'NÃO INICIADA';
    ELSE RETURN 'EM ANDAMENTO';
    END IF;
END //

-- Função 3: Retorna contagem de pendências ativas de um projeto
CREATE FUNCTION fn_tarefas_pendentes(p_projeto_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE v_qtd INT;
    SELECT COUNT(*) INTO v_qtd FROM tarefas WHERE projeto_id = p_projeto_id AND status = 'PENDENTE';
    RETURN v_qtd;
END //

-- Função 4: Normalização de strings para letras maiúsculas
CREATE FUNCTION fn_formata_status(p_status VARCHAR(50)) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    RETURN UPPER(TRIM(p_status));
END //

-- Função 5: Validador Booleano de integridade monetária
CREATE FUNCTION fn_valida_valor(p_valor DECIMAL(10,2)) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    RETURN p_valor > 0;
END //

DELIMITER ;

-- ============================================================================
-- 14. TRIGGERS SIMPLES DE VALIDAÇÃO E AUDITORIA
-- ============================================================================
DELIMITER //

-- Trigger Simple 1: Regra restritiva para impedir exclusão de projetos ativos
CREATE TRIGGER trg_impede_delete_projeto
BEFORE DELETE ON projetos
FOR EACH ROW
BEGIN
    IF OLD.progresso > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Projetos em andamento não podem ser excluídos!';
    END IF;
END //

-- Trigger Simple 2: Abortar inserções monetárias inválidas ou zeradas
CREATE TRIGGER trg_valida_despesa_negativa
BEFORE INSERT ON despesas
FOR EACH ROW
BEGIN
    IF NEW.valor <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valor da despesa deve ser maior que zero.';
    END IF;
END //

-- Trigger Simple 3: Preservar integridade dos documentos de identificação civil/jurídica
CREATE TRIGGER trg_protege_documento_cliente
BEFORE UPDATE ON clientes
FOR EACH ROW
BEGIN
    IF NEW.cpf_cnpj IS NULL OR NEW.cpf_cnpj = '' THEN
        SET NEW.cpf_cnpj = OLD.cpf_cnpj;
    END IF;
END //

-- Trigger Simple 4: Tratamento e coerência de datas futuras de lançamentos
CREATE TRIGGER trg_data_despesa_valida
BEFORE INSERT ON despesas
FOR EACH ROW
BEGIN
    IF NEW.data_compra > CURDATE() THEN
        SET NEW.data_compra = CURDATE();
    END IF;
END //

-- Trigger Simple 5: Salvaguarda física de dados de tarefas limpas do sistema
CREATE TRIGGER trg_backup_tarefa_excluida
BEFORE DELETE ON tarefas
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (mensagem) VALUES (CONCAT('Tarefa excluída: ', OLD.descricao));
END //

DELIMITER ;

-- ============================================================================
-- 15. TRIGGERS AVANÇADAS (CHAMAM PROCEDURES OU FUNCTIONS)
-- ============================================================================
DELIMITER //

-- Trigger Avançada 1: Dispara Procedure para logar novos projetos criados
CREATE TRIGGER trg_log_novo_projeto
AFTER INSERT ON projetos
FOR EACH ROW
BEGIN
    CALL sp_registrar_log(CONCAT('Novo projeto cadastrado. ID: ', NEW.id));
END //

-- Trigger Avançada 2: Dispara Procedure de fechamento massivo ao atingir 100%
CREATE TRIGGER trg_auto_conclui_tarefas
AFTER UPDATE ON projetos
FOR EACH ROW
BEGIN
    IF NEW.progresso = 100 AND OLD.progresso < 100 THEN
        CALL sp_concluir_tarefas_projeto(NEW.id);
    END IF;
END //

-- Trigger Avançada 3: Intercepta e normaliza texto usando a Function de formatação
CREATE TRIGGER trg_formata_status_tarefa
BEFORE INSERT ON tarefas
FOR EACH ROW
BEGIN
    SET NEW.status = fn_formata_status(NEW.status);
END //

-- Trigger Avançada 4: Executa validação lógica robusta invocando UDF booleana
CREATE TRIGGER trg_usa_fn_valida_valor
BEFORE INSERT ON despesas
FOR EACH ROW
BEGIN
    IF fn_valida_valor(NEW.valor) = FALSE THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro de Function: Valor inválido.';
    END IF;
END //

-- Trigger Avançada 5: Intercepta exclusões consultando pendências via Function externa
CREATE TRIGGER trg_verifica_pendencias_delete
BEFORE DELETE ON projetos
FOR EACH ROW
BEGIN
    IF fn_tarefas_pendentes(OLD.id) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir. Existem tarefas pendentes.';
    END IF;
END //

DELIMITER ;

-- ============================================================================
-- 16. TRANSAÇÕES DE TESTE (ACID - BEGIN, COMMIT, ROLLBACK)
-- ============================================================================

-- Transação 1: Fluxo Ideal de Sucesso (COMMIT completo das amarrações)
START TRANSACTION;
INSERT INTO clientes (nome, telefone, cpf_cnpj) VALUES ('Cliente Novo', '11999999999', '00000000001');
INSERT INTO projetos (titulo, descricao, progresso, usuario_id, cliente_id) VALUES ('Obra Rápida', 'Pequena reforma', 0, 1, LAST_INSERT_ID());
COMMIT;

-- Transação 2: Simulação de Cancelamento/Rollback usando Projeto com 0% (Evita o erro 1644 da Trigger)
START TRANSACTION;
DELETE FROM tarefas WHERE projeto_id = 4;
DELETE FROM proyectos WHERE id = 4;
ROLLBACK;

-- Transação 3: Atualizações financeiras e operacionais em lote seguro (COMMIT)
START TRANSACTION;
UPDATE despesas SET valor = valor * 1.05 WHERE data_compra < '2026-03-01';
UPDATE projetos SET progresso = 5 WHERE progresso = 0;
COMMIT;

-- Transação 4: Transferência de custódia de obra com rastro de auditoria (COMMIT)
START TRANSACTION;
UPDATE projetos SET usuario_id = 2 WHERE usuario_id = 1 AND id = 2;
INSERT INTO log_auditoria (mensagem) VALUES ('Projeto 2 transferido do usuario 1 para o 2');
COMMIT;

-- Transação 5: Lançamento de teste desconsiderado pelo operador (ROLLBACK voluntário)
START TRANSACTION;
INSERT INTO tarefas (descricao, status, projeto_id) VALUES ('Tarefa teste transação', 'PENDENTE', 3);
ROLLBACK;

-- ============================================================================
-- FIM DO SCRIPT DO PROJETO INTEGRADOR
-- ============================================================================