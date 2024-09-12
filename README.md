# Projeto Avirario

## Descrição

O Projeto Avirario é uma aplicação desenvolvida em Dart e Flutter, focada na gestão de aviários e lotes para um sistema de controle de propriedades avícolas. Utiliza o banco de dados SQLite para persistência e a arquitetura de software é baseada em princípios de POO e testes.

## Estrutura do Projeto

### Diretórios e Arquivos

- **`lib/`**: Código fonte da aplicação.
  - **`app/`**:
    - **`database/sqlite/`**: Contém a configuração do banco de dados e classes de acesso a dados.
      - **`conexao.dart`**: Configuração e gerenciamento da conexão com o banco de dados SQLite.
      - **`dao_aviario.dart`**: Implementação da classe DAO para aviários.
      - **`dao_lote.dart`**: Implementação da classe DAO para lotes.
      - **`dao_propriedade.dart`**: Implementação da classe DAO para propriedades.
    - **`domain/`**: Contém as definições de entidades e interfaces.
      - **`dto/`**: Data Transfer Objects (DTOs) para transportar dados entre camadas.
        - **`dto_aviario.dart`**: DTO para aviário.
        - **`dto_lote.dart`**: DTO para lote.
        - **`dto_propriedade.dart`**: DTO para propriedade.
      - **`interface/`**: Interfaces para os DAOs.
        - **`i_dao_aviario.dart`**: Interface para o DAO de aviário.
        - **`i_dao_lote.dart`**: Interface para o DAO de lote.
        - **`i_dao_propriedade.dart`**: Interface para o DAO de propriedade.
    - **`aplication/`**: Contém as classes de aplicação que utilizam os DAOs.
      - **`a_aviario.dart`**: Classe de aplicação para a gestão de aviários.
      - **`a_lote.dart`**: Classe de aplicação para a gestão de lotes.
      - **`a_propriedade.dart`**: Classe de aplicação para a gestão de propriedades.
- **`test/`**: Contém os testes automatizados.
  - **`database/sqlite/`**: Testes para as classes de acesso a dados.
    - **`dao_aviario_test.dart`**: Testes para o DAO de aviários.
    - **`dao_lote_test.dart`**: Testes para o DAO de lotes.
    - **`dao_propriedade_test.dart`**: Testes para o DAO de propriedades.
  - **`aplication/`**: Testes para as classes de aplicação.
    - **`a_aviario_test.dart`**: Testes para a classe de aplicação `AAviario`.
    - **`a_lote_test.dart`**: Testes para a classe de aplicação `ALote`.
    - **`a_propriedade_test.dart`**: Testes para a classe de aplicação `APropriedade`.

## Tecnologias Utilizadas

- **Dart**: Linguagem de programação principal.
- **Flutter**: Framework para desenvolvimento de aplicativos.
- **SQLite**: Banco de dados para persistência de dados.
- **sqflite_common_ffi**: Biblioteca para SQLite em memória para testes.

## Configuração do Ambiente

1. **Instalar Dependências**

   Certifique-se de ter o [Flutter](https://flutter.dev/docs/get-started/install) e o [Dart](https://dart.dev/get-dart) instalados. No diretório do projeto, execute:

   ```bash
   flutter pub get
