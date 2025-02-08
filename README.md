# Desafio Final de Data Engineering

Este repositório contém a solução para o desafio final, que abrange desde a criação de catalogs com terraform até a extração e transformação dos dados. O desafio foi realizado na plataforma Databricks, utilizando Terraform, Databricks CLI e Spark. O desafio foi realizado utilizando o sistema operacional Linux Mint. 

## Ferramentas para instalar 

Para realizar o desafio é necessário algumas ferramentas instaladas:

- [Databricks CLI](https://docs.databricks.com/en/dev-tools/cli/install.html)
- [Terraform](https://developer.hashicorp.com/terraform/install)


## Visão Geral

O projeto consiste em:

- **Infraestrutura:** Utilização do Terraform para criar dois catalogs no Databricks:
  - `<nome_completo>_raw`
  - `<nome_completo>_stg`
- **Pipeline de Dados:** 
  - **Extração:** Job que extrai os dados do banco ADW (Adventure Works), especificamente todas as tabelas do departamento de *sales*, via conexão JDBC.
  - **Transformação:** Job que processa os dados extraídos utilizando Spark, realizando ajustes como padronização de nomes (snake_case) e conversão de tipos de dados. Um caso específico é a tabela `store`, que possui uma coluna XML que foi transformada em múltiplas colunas.
- **Deploy:** Configurado inicialmente para ambiente de desenvolvimento (*dev*), com possibilidade de deploy para ambiente de produção.


## Terraform

Para criar os dois catalogs com o terraform é necessário instalar o provider do databricks, após a instalação é necessário passar as variáveis de ambiente que serão o valor do host e token do databricks da seguinte maneira:

```bash
export TF_VAR_databricks_host="https://<host>"
export TF_VAR_databricks_token="<token>"
```
Depois de exportar as variáveis o terraform irá utilizar estas variáveis de ambiente. Portanto basta iniciar o Terraform e aplicar. 

```bash
terraform init
terraform apply
```

Após essas configurações e comandos os catalogs já terão sido criados no databricks. 

## Databricks CLI 

Primeira coisa para utilizar o databricks cli é necessário se autenticar, para assim conseguir conectar seu perfil do databricks com o databricks CLI, para isso é necessário ter um token válido. Utilize o seguinte comando:

```bash
databricks configure --token
```
O CLI vai pedir para adicionar um host e um token para conseguir se autenticar. Após essa etapa o ambiente já vai estar autenticado e pronto para usar os comandos do databricks CLI.

## Databricks Asset Bundle

O repositório já possui um bundle criado, portanto não é necessário criar outro, dentro da pasta "resources" existe um arquivo yml onde foi configurado um job com duas tasks, a primeira sendo da extração de dados e a segunda da transformação, as duas são notebooks tasks e apontam para o caminho de onde estão os notebooks que executam a task. Neste mesmo arquivo foi configurado a criação de dois schemas um para o catalog raw e outro para o catalog stg. O job criado possui um trigger que quando o bundle for deployado com a target de produção, executará todos os dias 24h após a execução do último job. 

Dentro da pasta src possui os dois notebooks que executam extração e transformação.

Notebook de extração, neste notebook é feita uma conexão com o banco de dados Adventure Works via jdbc, as credênciais estão sendo carregadas via dbutils, elas foram configuradas em um secret scope para a maior segurança de dados sensíveis. Após a conexão com o banco de dados é feita uma query que verifica todas as tabelas base do schema `sales`, depois é criado um array com o nome de todas as tabelas, por fim um laço é utilizado para passar pelo array e extrair os dados de todas as tabelas.

Notebook de transformação, neste notebook é utilizado spark para ler as tabelas já salvas no catalog raw e realizar transformações básicas para a padronização do dados. Cada célula do notebook equivale a uma tabela transformada e salva no catalog stg.

O arquivo databricks.yml é o arquivo onde tem as configurações de criação do bundle e das targets, o bundle possui duas targets, dev e prod. 

Importante: Os notebooks estão configurados para executar o job na target dev, já que ao rodar em dev é criado os schemas com o nome do desenvolvedor como prefixo, exemplo : dev_pietro_longui_nomedoschema. Portanto caso queira rodar em ambiente de produção é necessário alterar os nomes dos schemas nas células dos notebooks. 

Para subir o bundle para o databricks é necessário utilizar o comando:

```bash
databricks bundle deploy
```
Lembrando que este comando faz um deploy com a target dev como default, para fazer deploy com a target de produção, utilize o seguinte comando:

```bash
databricks bundle deploy --target prod
```
Para conferir o Job sendo executado basta entrar na aba "Workflows" do databricks, caso o deploy foi no ambiente default(dev), o job precisa ser rodado manualmente, caso o deploy foi no ambiente de produção(prod), existe um trigger que fará o job executar todos os dias no horário que o deploy foi feito e sempre 24h depois da última execução. 

## Conclusão

Seguindo todos os passos existirá uma pipeline capaz de extrair e transformar os dados do banco Adventure Works. 

