# Desafio Final de Data Engineering

Neste texto relatarei o que foi feito para realizar o desafio final de Data Engineering, que abrange desde a criação de catalogs com Terraform até a extração e transformação dos dados. O desafio foi realizado na plataforma Databricks, utilizando Terraform, Databricks CLI, Databricks Asset Bundle e Spark. O sistema operacional utilizado foi o Linux Mint.

## Visão Geral

Realizei as seguintes etapas:

1. **Instalação dos Requisitos:**
   - **Terraform:** 
   - **Databricks CLI:** 

2. **Configuração do Terraform:**
   - Criei uma pasta chamada `terraform` e dentro dela um arquivo `main.tf` para configurar o provider do Databricks e criar dois catalogs:
     - `<nome_completo>_raw`
     - `<nome_completo>_stg`
   - Para a conexão com o Databricks, declarei as variáveis `databricks_host` e `databricks_token` e as exportei como variáveis de ambiente.

3. **Autenticação no Databricks CLI:**
   - Utilizei o comando `databricks configure --token` para autenticar o CLI com o host e token do Databricks.

4. **Configuração do Databricks Asset Bundle:**
   - Iniciei um bundle e configurei o arquivo `.yml` dentro da pasta resources para:
     - Criar um job com duas tasks:
       - **Extração:** Notebook que conecta ao banco Adventure Works via JDBC e extrai os dados.
       - **Transformação:** Notebook que transforma os dados e os salva no catalog `stg`.
     - Criar dois schemas:
       - Um para o catalog `raw`.
       - Outro para o catalog `stg`.

5. **Extração de Dados:**
   - No notebook de extração, fiz uma conexão via JDBC com o banco Adventure Works.
   - Para garantir a segurança, utilizei um `secrets scope` para armazenar as credenciais do banco de dados.
   - Extraí todas as tabelas "base" do schema `sales` e as salvei no catalog `raw`.

6. **Transformação de Dados:**
   - No notebook de transformação, utilizei Spark para ler as tabelas extraídas e salvas no catalog `raw` para realizar as seguintes transformações:
     - Padronização dos nomes das colunas para `snake_case`.
     - Conversão de tipos de dados usando `cast`.
     - Transformação da coluna XML da tabela `store` em múltiplas colunas.
   - As tabelas transformadas foram salvas no catalog `stg`.

7. **Deploy:**
   - Fiz o deploy para o ambiente de desenvolvimento (`dev`), onde os recursos são prefixados com `dev_<nome_do_usuário>`.
   - Para o ambiente de produção (`prod`), é necessário ajustar os nomes dos schemas nos notebooks.

8. **Execução do Job:**
   - No ambiente `dev`, o job precisa ser executado manualmente.
   - No ambiente `prod`, o job é executado automaticamente todos os dias.
