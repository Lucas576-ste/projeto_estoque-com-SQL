-- Script SQL para o Banco de Dados de Controle de Estoque Básico

-- Criação da tabela de Categorias de Produtos
CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(100) NOT NULL UNIQUE
);

-- Criação da tabela de Produtos
CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

-- Criação da tabela de Movimentacoes de Estoque
CREATE TABLE Movimentacoes (
    id_movimentacao INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT,
    tipo_movimentacao ENUM('entrada', 'saida') NOT NULL,
    quantidade INT NOT NULL,
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);




-- Trigger para atualizar a quantidade em estoque após uma movimentação
DELIMITER //
CREATE TRIGGER trg_atualiza_estoque
AFTER INSERT ON Movimentacoes
FOR EACH ROW
BEGIN
    IF NEW.tipo_movimentacao = 'entrada' THEN
        UPDATE Produtos
        SET quantidade_estoque = quantidade_estoque + NEW.quantidade
        WHERE id_produto = NEW.id_produto;
    ELSEIF NEW.tipo_movimentacao = 'saida' THEN
        UPDATE Produtos
        SET quantidade_estoque = quantidade_estoque - NEW.quantidade
        WHERE id_produto = NEW.id_produto;
    END IF;
END;
//
DELIMITER ;


