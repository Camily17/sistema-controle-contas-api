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