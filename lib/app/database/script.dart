const createTables = [
  '''
    CREATE TABLE usuario (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      nome VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      senha VARCHAR(100) NOT NULL
    )
  ''',
  '''
    CREATE TABLE propriedade (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      nome VARCHAR(100) NOT NULL,
      localizacao VARCHAR(100) NOT NULL,
      qtdAviario INTEGER NOT NULL
    )
  '''
];

const insertUsuarios = [
  '''
    INSERT INTO usuario (nome, email, senha)
    VALUES ('Admin', 'admin@example.com', 'admin123')
  ''',
  '''
    INSERT INTO usuario (nome, email, senha)
    VALUES ('User1', 'user1@example.com', 'password1')
  ''',
  '''
    INSERT INTO usuario (nome, email, senha)
    VALUES ('User2', 'user2@example.com', 'password2')
  '''
];

const insertPropriedades = [
  '''
    INSERT INTO propriedade (nome, localizacao, qtdAviario)
    VALUES ('Propriedade A', 'Localização A', 5)
  ''',
  '''
    INSERT INTO propriedade (nome, localizacao, qtdAviario)
    VALUES ('Propriedade B', 'Localização B', 10)
  ''',
  '''
    INSERT INTO propriedade (nome, localizacao, qtdAviario)
    VALUES ('Propriedade C', 'Localização C', 8)
  '''
];
