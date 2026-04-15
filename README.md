# 🏗️ Obra Certa - Database

O **Obra Certa** é um projeto desenvolvido academicamente com o objetivo de otimizar o cálculo de materiais e reduzir o desperdício em canteiros de obras. Este repositório foca na camada de persistência, contendo toda a modelagem e lógica de banco de dados SQL.

## 📌 Contexto do Projeto
O sistema foi idealizado para auxiliar gestores de construção civil a manterem um controle rigoroso sobre o progresso físico das obras, as tarefas pendentes e o fluxo financeiro (despesas com materiais).

## 🛠️ Tecnologias e Ferramentas
* **Banco de Dados:** MySQL / MariaDB.
* **Linguagem:** SQL (DDL, DML, DQL).
* **Ambiente de Desenvolvimento:** VS Code e HeidiSQL.

## 🗄️ Estrutura do Banco de Dados
O banco `obracerta_db` é composto por 5 tabelas principais:
* **`usuarios`**: Gestores responsáveis pelo acompanhamento das obras.
* **`clientes`**: Dados de contato e identificação (CPF/CNPJ) dos contratantes.
* **`projetos`**: Entidade central que vincula o gestor ao cliente e monitora o progresso percentual da obra.
* **`tarefas`**: Detalhamento das atividades necessárias por projeto e seus respectivos status.
* **`despesas`**: Registro financeiro de insumos, valores e datas de aquisição.

## 📊 Inteligência e Relatórios (Views)
Para facilitar a gestão, o banco conta com Views prontas para consumo por uma camada de Backend ou Dashboard:
* **`vw_resumo_obras`**: Relatório executivo com título, progresso e nomes dos envolvidos.
* **`vw_financeiro_cliente`**: Consolidação de gastos totais por cliente.
* **`vw_alertas_tarefas`**: Filtro estratégico focado apenas em atividades com status 'PENDENTE'.
* **`vw_desempenho_gestor`**: Cálculo de progresso médio por gestor, útil para análise de produtividade.

## 🚀 Como Utilizar
1.  Clone este repositório.
2.  Importe o arquivo `ObraCertaDB.sql` em seu servidor MySQL.
3.  O script já contém dados de teste para validação das queries e views.
