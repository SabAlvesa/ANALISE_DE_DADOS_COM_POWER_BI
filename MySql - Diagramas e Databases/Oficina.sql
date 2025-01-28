
DROP DATABASE Oficina;
CREATE DATABASE Oficina;
USE Oficina;
SHOW tables;
DESCRIBE information_schema.TABLE_CONSTRAINTS;


CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    CPF CHAR(11) NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100),
    tipo_cliente ENUM('PF', 'PJ') NOT NULL,
    CONSTRAINT unique_CPF UNIQUE (CPF)
);


INSERT INTO Cliente (nome, CPF, telefone, email, tipo_cliente)
VALUES 
('João da Silva', '12345678901', '11987654321', 'joao.silva@email.com', 'PF'),
('Maria Oliveira', '98765432100', '11987654322', 'maria.oliveira@email.com', 'PF'),
('Empresa X', '12312312300', '1132334455', 'contato@empresax.com', 'PJ');

ALTER TABLE Cliente MODIFY COLUMN CPF VARCHAR(14) NOT NULL;


CREATE TABLE Servico (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    preco_serviço DECIMAL(10, 2) NOT NULL
);

INSERT INTO Servico (descricao, preco_serviço)
VALUES 
('Reparo de motor', 300.00),
('Troca de óleo', 120.00),
('Balanceamento de rodas', 80.00);


CREATE TABLE TabelaServico (
    id_tabela_servico INT PRIMARY KEY AUTO_INCREMENT,
    id_servico INT NOT NULL,
    id_cliente INT NOT NULL,
    data_inclusao DATE,
    CONSTRAINT fk_tabela_servico_servico FOREIGN KEY (id_servico) REFERENCES Servico(id_servico),
    CONSTRAINT fk_tabela_servico_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);


INSERT INTO TabelaServico (id_servico, id_cliente, data_inclusao)
VALUES 
(1, 1, '2025-01-10'),
(2, 2, '2025-01-11'),
(3, 3, '2025-01-12');


CREATE TABLE OrdemServico (
    id_ordem_servico INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_servico INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    status VARCHAR(50),
    CONSTRAINT fk_ordem_servico_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_ordem_servico_servico FOREIGN KEY (id_servico) REFERENCES Servico(id_servico)
);

INSERT INTO OrdemServico (id_cliente, id_servico, data_inicio, data_fim, status)
VALUES 
(1, 1, '2025-01-10', '2025-01-12', 'Concluída'),
(2, 2, '2025-01-11', '2025-01-12', 'Em andamento'),
(3, 3, '2025-01-12', NULL, 'Pendente');


CREATE TABLE FormaPagamento (
    id_forma_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    tipo_pagamento ENUM('Cartão', 'Pix', 'Boleto') NOT NULL,
    numero_cartao VARCHAR(16),
    nome_cartao VARCHAR(100),
    validade_cartao DATE,
    CVV_cartao CHAR(3),
    chave_pix VARCHAR(50),
    codigo_boleto VARCHAR(50),
    CONSTRAINT unique_cartao UNIQUE (numero_cartao, CVV_cartao),
    CONSTRAINT unique_pix UNIQUE (chave_pix),
    CONSTRAINT unique_boleto UNIQUE (codigo_boleto)
);


INSERT INTO FormaPagamento (tipo_pagamento, numero_cartao, nome_cartao, validade_cartao, CVV_cartao, chave_pix, codigo_boleto) 
VALUES 
('Cartão', '4113482934820312', 'João Silva', '2026-05-30', '334', NULL, NULL),  -- Cartão 1
('Pix', NULL, NULL, NULL, NULL, 'marcia03.souza@pix.com', NULL),  -- Pix
('Boleto', NULL, NULL, NULL, NULL, NULL, '847000000012345642342234567890123456789013'); 


CREATE TABLE Pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_ordem_servico INT NOT NULL,
    id_forma_pagamento INT NOT NULL,
    valor_pago DECIMAL(10, 2) NOT NULL,
    data_pagamento DATE NOT NULL,
    CONSTRAINT fk_pagamento_ordem_servico FOREIGN KEY (id_ordem_servico) REFERENCES OrdemServico(id_ordem_servico),
    CONSTRAINT fk_pagamento_forma_pagamento FOREIGN KEY (id_forma_pagamento) REFERENCES FormaPagamento(id_forma_pagamento)
);


INSERT INTO Pagamento (id_ordem_servico, id_forma_pagamento, valor_pago, data_pagamento)
VALUES
(1, 1, 300.00, '2025-01-12'), 
(2, 2, 120.00, '2025-01-12'), 
(3, 3, 80.00, '2025-01-13');


CREATE TABLE DepartamentoMecanica (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nome_departamento VARCHAR(100) NOT NULL
);


INSERT INTO DepartamentoMecanica (nome_departamento)
VALUES 
('Mecânica Geral'),
('Elétrica'),
('Suspensão');


CREATE TABLE Funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(20) NOT NULL,
    sobrenome VARCHAR(20) NOT NULL,
    id_departamento INT NOT NULL,
    salario DECIMAL(10, 2),
    telefone CHAR(11),
    CONSTRAINT fk_funcionario_departamento FOREIGN KEY (id_departamento) REFERENCES DepartamentoMecanica(id_departamento)
);


INSERT INTO Funcionario (nome, sobrenome, id_departamento, salario, telefone)
VALUES 
('Carlos', 'Pereira', 1, 2000.00, '11987654321'),
('Ana', 'Costa', 2, 2500.00, '11987654322'),
('Roberto', 'Santos', 3, 2200.00, '11987654323');


SELECT * FROM Cliente;
SELECT * FROM Servico;
SELECT * FROM TabelaServico;
SELECT * FROM OrdemServico;
SELECT * FROM FormaPagamento;
SELECT * FROM Pagamento;
SELECT * FROM DepartamentoMecanica;
SELECT * FROM Funcionario;


-- Filtrando clientes do tipo 'PF' (Pessoa Física)
SELECT * 
FROM Cliente
WHERE tipo_cliente = 'PF';

-- Filtrando serviços com preço superior a 100
SELECT * 
FROM Servico
WHERE preco_serviço > 100;

-- Filtrando ordens de serviço "Em andamento"
SELECT * 
FROM OrdemServico
WHERE status = 'Em andamento';

-- Filtrando pagamentos feitos após 2025-01-11
SELECT * 
FROM Pagamento
WHERE data_pagamento > '2025-01-11';



-- Calculando o valor total pago (valor_pago * 1.10, adicionando 10% de taxa)
SELECT 
    id_pagamento, 
    valor_pago, 
    valor_pago * 1.10 AS valor_com_taxa
FROM Pagamento;


-- Calculando o tempo de execução da ordem de serviço (data_fim - data_inicio)
SELECT 
    id_ordem_servico, 
    data_inicio, 
    data_fim, 
    DATEDIFF(data_fim, data_inicio) AS tempo_execucao
FROM OrdemServico
WHERE status = 'Concluída';



--  Ordenando os clientes por nome em ordem alfabética
SELECT * 
FROM Cliente
ORDER BY nome ASC;


--  Ordenando ordens de serviço por data de início, do mais recente para o mais antigo
SELECT * 
FROM OrdemServico
ORDER BY data_inicio DESC;

-- Exibiçao das ordens de serviço e os clientes
SELECT 
    Cliente.nome, 
    OrdemServico.id_ordem_servico, 
    OrdemServico.status
FROM Cliente
JOIN OrdemServico ON Cliente.id_cliente = OrdemServico.id_cliente;

-- Exbição do serviço, cliente e data de inclusão
SELECT 
    Servico.descricao, 
    Cliente.nome, 
    TabelaServico.data_inclusao
FROM TabelaServico
JOIN Servico ON TabelaServico.id_servico = Servico.id_servico
JOIN Cliente ON TabelaServico.id_cliente = Cliente.id_cliente;

-- Exibição os funcionários e os seus departamentos
SELECT 
    Funcionario.nome, 
    Funcionario.sobrenome, 
    DepartamentoMecanica.nome_departamento
FROM Funcionario
JOIN DepartamentoMecanica ON Funcionario.id_departamento = DepartamentoMecanica.id_departamento;

--  Exibição as ordens de serviço, clientes e formas de pagamento
SELECT 
    OrdemServico.id_ordem_servico, 
    Cliente.nome, 
    FormaPagamento.tipo_pagamento
FROM OrdemServico
JOIN Cliente ON OrdemServico.id_cliente = Cliente.id_cliente
JOIN Pagamento ON OrdemServico.id_ordem_servico = Pagamento.id_ordem_servico
JOIN FormaPagamento ON Pagamento.id_forma_pagamento = FormaPagamento.id_forma_pagamento;

