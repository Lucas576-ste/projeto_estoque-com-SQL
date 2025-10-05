# Descrição do Cenário e Código SQL

## Cenário: Sistema de Controle de Estoque Básico

Este projeto implementa um sistema de controle de estoque básico para um pequeno comércio. O objetivo é gerenciar produtos, suas categorias e registrar todas as movimentações de entrada e saída de estoque. O sistema visa simplificar o acompanhamento do inventário e garantir a integridade dos dados de estoque.

### Entidades Principais:

*   **Categorias:** Armazena as diferentes categorias de produtos (e.g., Eletrônicos, Alimentos, Vestuário).
*   **Produtos:** Contém informações detalhadas sobre cada produto, incluindo nome, descrição, preço, quantidade em estoque e a qual categoria pertence.
*   **Movimentações:** Registra cada entrada ou saída de produtos no estoque, incluindo o tipo de movimentação (entrada/saída), a quantidade e a data/hora da operação.

## Script SQL (`schema.sql`)

O script `schema.sql` é responsável pela criação das tabelas do banco de dados e pela implementação de uma trigger que automatiza a atualização do estoque.

### Estrutura das Tabelas:

1.  **`Categorias`**
    *   `id_categoria` (INT, PK, AUTO_INCREMENT): Identificador único da categoria.
    *   `nome_categoria` (VARCHAR(100), NOT NULL, UNIQUE): Nome da categoria do produto.

2.  **`Produtos`**
    *   `id_produto` (INT, PK, AUTO_INCREMENT): Identificador único do produto.
    *   `nome_produto` (VARCHAR(255), NOT NULL): Nome do produto.
    *   `descricao` (TEXT): Descrição detalhada do produto.
    *   `preco` (DECIMAL(10, 2), NOT NULL): Preço unitário do produto.
    *   `quantidade_estoque` (INT, NOT NULL, DEFAULT 0): Quantidade atual do produto em estoque.
    *   `id_categoria` (INT, FK): Chave estrangeira para a tabela `Categorias`.

3.  **`Movimentacoes`**
    *   `id_movimentacao` (INT, PK, AUTO_INCREMENT): Identificador único da movimentação.
    *   `id_produto` (INT, FK): Chave estrangeira para o produto movimentado.
    *   `tipo_movimentacao` (ENUM('entrada', 'saida'), NOT NULL): Tipo de movimentação (entrada ou saída).
    *   `quantidade` (INT, NOT NULL): Quantidade de itens movimentados.
    *   `data_movimentacao` (DATETIME, DEFAULT CURRENT_TIMESTAMP): Data e hora da movimentação.

### Trigger Implementada:

**`trg_atualiza_estoque`**

Esta trigger é acionada **APÓS** a inserção de um novo registro na tabela `Movimentacoes`. Sua função é manter a `quantidade_estoque` na tabela `Produtos` sempre atualizada, de acordo com o tipo de movimentação:

*   Se `tipo_movimentacao` for 'entrada', a `quantidade_estoque` do produto correspondente é **aumentada** pela `quantidade` da movimentação.
*   Se `tipo_movimentacao` for 'saida', a `quantidade_estoque` do produto correspondente é **diminuída** pela `quantidade` da movimentação.

**Exemplo de uso da Trigger:**

Ao inserir um registro na tabela `Movimentacoes` como, por exemplo, uma entrada de 10 unidades do `Produto X`, a trigger automaticamente adicionará 10 à `quantidade_estoque` do `Produto X` na tabela `Produtos`. Da mesma forma, uma saída de 5 unidades reduzirá o estoque em 5.

Este mecanismo garante a integridade e a consistência dos dados de estoque sem a necessidade de atualizações manuais ou chamadas explícitas de procedures após cada movimentação.

