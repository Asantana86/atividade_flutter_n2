-- Tabela de Clientes
CREATE TABLE clientes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  documento TEXT,
  telefone TEXT,
  email TEXT,
  is_sync INTEGER DEFAULT 0
);

-- Tabela de Técnicos
CREATE TABLE tecnicos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  especialidade TEXT,
  is_sync INTEGER DEFAULT 0
);

-- Tabela de Catálogo de Serviços
CREATE TABLE servicos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  descricao TEXT NOT NULL,
  preco REAL NOT NULL,
  tempo_estimado TEXT,
  is_sync INTEGER DEFAULT 0
);

-- Tabela de Ordem de Serviço (Cabeçalho)
CREATE TABLE ordens_servico (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cliente_id INTEGER NOT NULL,
  tecnico_id INTEGER NOT NULL,
  observacao TEXT,
  pecas_aplicadas TEXT,
  valor_pecas REAL DEFAULT 0,
  foto_antes TEXT,
  foto_depois TEXT,
  assinatura TEXT,
  status_os TEXT DEFAULT 'Em aberto',
  is_sync INTEGER DEFAULT 0,
  FOREIGN KEY (cliente_id) REFERENCES clientes (id),
  FOREIGN KEY (tecnico_id) REFERENCES tecnicos (id)
);

-- Tabela de Itens da OS (Relacionamento N:N entre OS e Serviços)
CREATE TABLE os_itens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  os_id INTEGER NOT NULL,
  servico_id INTEGER NOT NULL,
  descricao_snapshot TEXT,
  preco_snapshot REAL,
  is_sync INTEGER DEFAULT 0,
  FOREIGN KEY (os_id) REFERENCES ordens_servico (id)
);