# Desafio Final de Data Engineering

Este repositório contém a resolução do desafio final da trilha de engenharia de dados do programa Lighthouse, que envolve a criação de uma pipeline no Databricks para extração, transformação e armazenamento de dados. O projeto utiliza **Terraform** para criação de catalogs, **Databricks CLI** para criação e deploy do **Databricks Asset Bundle** e **Spark** para processamento de dados.

O desafio foi realizado com o sistema operacional **Linux Mint** e tem suporte para execução em ambientes *dev* e *prod*.

## Requisitos

Antes de iniciar, certifique-se de ter as seguintes ferramentas instaladas:

- [Databricks CLI](https://docs.databricks.com/en/dev-tools/cli/install.html)
- [Terraform](https://developer.hashicorp.com/terraform/install)

## Visão Geral do Projeto

### Catalogs do Databricks

Foi utilizado o **Terraform** para criar dois **catalogs** no Databricks:

- `<nome_completo>_raw`: catalog onde os dados originais do banco **Adventure Works** são armazenados.
- `<nome_completo>_stg`: catalog com os dados transformados para serem utilizados posteriormente em advanced analytics.

### Pipeline de Dados

A pipeline de dados foi desenvolvida utilizando **Databricks Asset Bundle** e consiste em um job com duas tasks principais:

1. **Extração:** Conecta-se ao banco de dados **Adventure Works** via **JDBC** e extrai todas as tabelas do schema *sales* para o catalog `raw`.
2. **Transformação:** Lê os dados do catalog `raw`, aplica transformações com **Spark** (padronizando nomes de colunas para *snake_case*, realizando *casts* e manipulando colunas XML, como na tabela `store`) e salva os resultados no catalog `stg`.

O ambiente **dev** exige execução manual, enquanto no ambiente **prod** o job roda automaticamente a cada 24 horas.

## Configuração e Deploy

### Configuração do Terraform

1. Defina as variáveis de ambiente com as credenciais do Databricks:

   ```bash
   export TF_VAR_databricks_host="https://<host>"
   export TF_VAR_databricks_token="<token>"
   ```

2. Inicialize o Terraform e aplique as configurações para criar os catalogs:

   ```bash
   terraform init
   terraform apply
   ```

Após a execução, os catalogs `<nome_completo>_raw` e `<nome_completo>_stg` estarão disponíveis no Databricks.

### Autenticação no Databricks CLI

Antes de executar comandos via **Databricks CLI**, é necessário configurar a autenticação:

```bash
databricks configure --token
```

O CLI solicitará o **host** e o **token**. Após a autenticação, o ambiente estará pronto para execução de comandos.

### Configuração do Databricks Asset Bundle

O repositório já contém um bundle configurado. Ele inclui:

- **Job desafio_final** Executa os notebooks responsáveis pela extração e transformação dos dados do banco Adventure Works pela conexão 
- **Criação de Schemas:** Define os schemas dentro dos catalogs `raw` e `stg`.

#### Execução do Job

- **Ambiente de Desenvolvimento (dev):**
  - O job deve ser executado manualmente.
  - Para deploy, use:
    ```bash
    databricks bundle deploy
    ```

- **Ambiente de Produção (prod):**
  - O job é agendado para execução automática a cada 24 horas.
  - Para deploy, use:
    ```bash
    databricks bundle deploy --target prod
    ```

#### Ajustes para Produção

Para executar a pipeline em **produção**, altere os nomes dos schemas nos notebooks para remover o prefixo `dev_<nome_completo>_`.

## Conclusão

Este repositório implementa uma pipeline para extração e transformação de dados do banco Adventure Works. Utilizando **Terraform**, **Databricks Asset Bundle** e **Spark**. Seguindo todos os passos, se terá uma pipeline capaz de lidar com grandes volumes de dados por conta do **Spark** e com ambientes para desenvolvimento e testes e um ambiente de produção. 