# Descrição do Projeto

## Requisitos técnicos

* O projeto deve ser desenvolvido em Ruby, Java ou .NET, a sua livre escolha;
* O banco de dados deve ser SQL Server ou MySQL;
* Desenvolvimento em camadas, com tratamento de erros eficiente;
* O Backend deve estar separado do FrontEnd;
* Crie os recursos necessários de banco de dados (tabelas, índices, etc). Leve em consideração a performance e escalabilidade;
* O Backend deve disponibilizar uma API Rest;
* O Frontend deve consumir as API´s Rest disponibilizadas pelo Backend;
* Deve ser possível efetuar todas as operações disponibilizadas pelo Backend; 

## Entrega esperada

A solução completa (scripts de banco de dados e qualquer outro artefato necessário para execução da solução) deve ser disponibilizada em um repositório público do GitHub (http://github.com/). 


##Avaliação

Serão avaliados sua lógica de programação, estruturação do projeto, qualidade de código e solução dada ao problema proposto. Do the best!

**Atenção as pesquisas feitas na web!** Por ser um teste a distância, você terá liberdade de pesquisa, porém explicações sobre o código poderão ser solicitadas por telefone ou pessoalmente.

## Necessidade a ser resolvida: Sistema para controle de contas

Você deve criar um CRUD para manutenção de Contas de saldo. Podemos ter 2 tipos de contas:

* Conta Matriz – É a conta principal, a qual pode ter (n) contas filhas e essas também podem possuir suas filhas, formando assim uma hierarquia. É a principal conta da estrutura.
* Contas Filiais – É uma conta idêntica a Conta Matriz, porém possui obrigatoriamente uma conta Pai (pode ser a Conta Matriz ou outra Conta Filial) e pode ou não ter uma Conta Filial abaixo.

##### Dados para o Cadastro de Contas

```
Nome
Data de Criação
```

Obs: Toda Conta deve possuir uma Pessoa e esta pode ser Jurídica ou Física

##### Dados para Pessoa Jurídica

```
CNPJ
Razão Social
Nome Fantasia
```

##### Dados para Pessoa Física

```
CPF
Nome Completo
Data Nascimento
```

##### Funcionalidade de Transferência

Toda Conta Filial pode efetuar transferências desde que a conta que receberá a transferência esteja debaixo da mesma árvore e não seja uma conta Matriz.

A Conta Matriz não pode receber transferências de outras contas, apenas Aportes que devem possuir um código alfanumérico único.

Toda transação pode ser estornada (no caso de um estorno de um Aporte é necessário informar o código alfanumérico para que a transação possa ser estornada).

Apenas as Contas Ativas podem receber Cargas ou Transferências

##### Situação da Conta

Toda Conta pode estar ativa, bloqueada ou cancelada;

Todo Histórico de transações deve ser armazenado e consultado.

## Glossário de termos

Aporte - Entrada de valores diretamente na Conta Matriz, através de uma transação qualquer.

Transferência – Valores movimentados entre contas, onde uma é debitada e a outra é creditada.


# Instalação do Projeto

### Configurações

1. Para este desafio foram utilizados: Ruby 2.3.1, Rails 5.0.0.1 e banco de dados MySQL.


2. Após o download do projeto, acesse o diretório do projeto e instale suas dependências com o comando:

```
$ bundle install
```

3. Cria o banco de dados para a aplicação com o comando:

```
$ rake db:setup
```

### Execução


1. Configuração do arquivo host:
    
    Acesse o arquivo /etc/hosts e adiciona a seguinte configuração: 
    
```
127.0.0.1    api.sistema-controle-contas.com
```
**Obs:** Essa configuração é necessária pois foi utilizado a estrutura padrão de nomenclatura de API.

2. Uma vez que as dependências estão instaladas, banco de dados criados e a configuração do host estão completas, execute o servidor instalado com o comando:
  
```
$ rails server
```

3. Acesse a URL da aplicação para o acesso aos pontos de acesso com métodos do tipo GET.

    http://api.sistema-controle-contas.com:3000


4. Para utilizar os pontos de acesso com os métodos POST, PUT, PATCH e DELETE, deve-se utilizar uma ferramenta que possa o auxiliar na chamada das requisições, como cURL ou extensão com "Postman - REST Client" do Google Chrome.

5. Deve-se adicionar o seguinte cabeçalho ao se fazer as requisições:

* "Content-Type" com o valor de "application/json"

Logo, o conteúdo para a criação e atualização dos registros deve ser enviado no formato JSON.


### Descrição das funcionalidades

#### Recursos disponíveis

Para o consumo da API estão disponíbilizadas os seguintes recursos:


##### Recurso Pessoa Física

###### Pontos de acesso

```
Métodos                URI
GET                    /v1/pessoas_fisicas
POST                   /v1/pessoas_fisicas
GET                    /v1/pessoas_fisicas/:id
PATCH                  /v1/pessoas_fisicas/:id
PUT                    /v1/pessoas_fisicas/:id
```

###### JSON Válido

```
{
    "pessoa_fisica": {
        "cpf": "12345678958",
        "nome": "Nome da Pessoa Física",
        "data_nascimento": "1980-05-15"
    }
}
```
###### Validações

:cpf 

* Deve estar presente
* Deve ser único
* Deve ser numérico
* Deve ter 11 caracteres.

:nome:

* Dever estar presente
* Deve ser apenas letras.
* Deve ser entre 2 e 70 caracteres.

:data_nascimento

* Deve estar presente
* Deve ser uma data do dia de hoje ou anterior.


##### Recurso Pessoa Jurídica

###### Pontos de acesso

```
Métodos                URI
GET                    /v1/pessoas_juridicas
POST                   /v1/pessoas_juridicas
GET                    /v1/pessoas_juridicas/:id
PATCH                  /v1/pessoas_juridicas/:id
PUT                    /v1/pessoas_juridicas/:id
```

###### JSON Válido

```
{
    "pessoa_juridica": {
        "cnpj": "12345678958124",
        "razao_social": "Nome Razão Social",
        "nome_fantasia": "Nome Fantasia"
    }
}
```
###### Validações

:cnpj

* Deve estar presente
* Deve ser único
* Deve ser numérico
* Deve ter 14 caracteres

:razao_social

* Deve estar presente
* Deve ser único
* Deve ser entre 2 e 70 caracteres.

:nome_fantasia

* Deve estar presente
* Deve ser único
* Deve ser entre 2 e 70 caracteres.


##### Recurso Conta

###### Pontos de acesso

```
Métodos                URI
GET                    /v1/contas
POST                   /v1/contas
GET                    /v1/contas/:id
PATCH                  /v1/contas/:id
PUT                    /v1/contas/:id
DELETE                 /v1/contas/:id
```

###### JSON Válido

```
{
    "conta": {
        "nome": "Nome da conta",
        "status": "ativo",
        "saldo": 500,
        "pessoa_type": "PessoaJuridica",
        "pessoa_id": 2
    }
}

{
    "conta": {
        "nome": "Nome da conta",
        "status": "ativo,
        "saldo": 500,
        "pessoa_type": "PessoaFisica",
        "pessoa_id": 1,
        "ancestry": 1
    }
}

```

###### Validações

:nome 

* Deve estar presente
* Deve ser único
* Deve ser letras
* Deve ter entre 2 e 70 caracteres.

:saldo

* Deve estar presente
* Deve ser numérico

:status

* Deve estar presente
* Deve ser "cancelado", "ativo" ou "bloqueado"

:pessoa_type

* Deve estar presente
* Deve ser "PessoaFisica" ou "PessoaJuridica"

:pessoa_id

* Deve ser inteiro e ter uma "PessoaFisica" ou "PessoaJuridica" cadastrada como referência.
        
:ancestry

* Quando informado deve ser um número de uma conta já cadastrada.


###### Adicionais

* Contas canceladas não podem ser bloqueadas, ativadas ou alteradas.


##### Recurso Transação

###### Pontos de acesso


```
Métodos                URI
GET                    /v1/transacoes
POST                   /v1/transacoes
GET                    /v1/transacoes/:id
```

###### JSON Válido

```
{
  "transacao": {
    "tipo": "carga",
    "valor": 250,
    "conta_origem_id": 4
  }
}


{
  "transacao": {
    "tipo": "transferencia",
    "valor": 500,
    "conta_origem_id": 2,
    "conta_destino_id": 3
  }
}


{
  "transacao": {
    "tipo": "estorno",
    "codigo_transacional_estornado": "191512c6409fefcd1f48c8f04983752e"
  }
}

```

##### Validações

:tipo

* Deve estar presente
* Deve ser "carga", "transferencia", "estorno"

:valor

* Quando transação do tipo "carga" ou "transferencia" deve ter um valor maior que 0

:conta_origem_id

* Deve estar presente quando transação for do tipo "carga" ou "transferencia"


:conta_destino_id

* Deve estar presente quando transação for do tipo "transferencia"


codigo_transacional_estornado:

* Deve ser fornecido quando a transação for do tipo "estorno"
* Deve ter 32 caracteres e deve estar cadastrado
* Não é possível estornar transações do tipo "estorno" ou transação do tipo "carga" ou "transferencia" já estornadas.

###### Adicionais

* Não é possível fazer transações do tipo "carga" e "transferencia" para contas "bloqueadas" ou "canceladas"
* Só é possível fazer transações do tipo "transferencia" para contas que não são da mesma hierarquia
* Contas matrizes não transações do tipo "transferencia"

## Testes

### Tipos de testes

1. Para esta aplicação foram implementados o **Teste de Integração** para os __controllers__, onde são testados:

    1.1 Se as requisições retornam o valor esperado.
    
    1.2 Se as requisições redirecionam para a página correta.
    
    1.3 Se o __status code__ retornoado é o esperado
    
2. Também foram implementados **Teste Unitário** aos __models__, onde são testados:

    2.1 Validações
    
    2.2 Associações
    
    2.3 Regras de negócio
    
3. Quantificando os testes

    3.1 Nesta versão do projeto estão disponíveis 165 testes, sendo:

    ```
    112 - Testes referentes os controllers.
    053 - Testes referentes aos models.
    ```
    
### Executando os testes

1. Para executar os testes basta executar o seguinte comando:

    ```
    $ rspec spec
    ```

## Dúvidas

Para mais informações basta entrar em contato, para que assim eu possa auxilia-lo com suas dúvidas.
    