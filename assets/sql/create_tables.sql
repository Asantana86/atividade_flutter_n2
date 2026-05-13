-- Tabela de Usuários
CREATE TABLE usuarios (
    id TEXT PRIMARY KEY,
    created_at TEXT,
    is_sync INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

-- Tabela de Clientes
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT,
    is_sync INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    nome TEXT NOT NULL,
    documento TEXT NOT NULL,
    telefone TEXT NOT NULL,
    email TEXT
);

-- Tabela de Técnicos
CREATE TABLE tecnicos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT,
    is_sync INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    nome TEXT NOT NULL,
    especialidade TEXT
);

-- Tabela de Serviços (Catálogo)
CREATE TABLE servicos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT,
    is_sync INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    descricao TEXT NOT NULL,
    preco REAL NOT NULL,
    tempo_estimado TEXT
);

-- Tabela de Ordens de Serviço
CREATE TABLE ordens_servico (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT,
    is_sync INTEGER DEFAULT 0,
    ativo INTEGER DEFAULT 1,
    cliente_id INTEGER NOT NULL,
    tecnico_id INTEGER NOT NULL,
    servico_id INTEGER NOT NULL,
    data_inicio TEXT NOT NULL,
    data_fim TEXT,
    observacao_final TEXT,
    foto_antes TEXT NOT NULL,
    foto_after TEXT,
    assinatura TEXT,
    status TEXT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes (id),
    FOREIGN KEY (tecnico_id) REFERENCES tecnicos (id),
    FOREIGN KEY (servico_id) REFERENCES servicos (id)
);

CREATE TABLE IF NOT EXISTS system_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    level TEXT NOT NULL,
    source TEXT NOT NULL,
    operation TEXT NOT NULL,
    message TEXT NOT NULL,
    stack_trace TEXT,
    metadata TEXT,
    is_sync INTEGER DEFAULT 0,
    created_at INTEGER NOT NULL
);