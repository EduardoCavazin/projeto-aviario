# Projeto Aviário

## Descrição

O Projeto Aviário é uma aplicação desenvolvida em Dart e Flutter, focada na gestão de aviários e lotes para um sistema de controle de propriedades avícolas. Utiliza o **Firebase Firestore** para persistência de dados e a arquitetura de software é baseada em princípios de POO e testes.

## Tecnologias Utilizadas

- **Dart**: Linguagem de programação principal.
- **Flutter**: Framework para desenvolvimento de aplicativos.
- **Firebase**: Backend como serviço, usado para persistência de dados e autenticação.
  - **Firebase Firestore**: Banco de dados NoSQL para armazenamento de dados da aplicação.
  - **Firebase Auth**: Autenticação de usuários para controle de acesso.
- **cloud_firestore**: Biblioteca para integração com o Firestore.

## Configuração do Ambiente

1. **Instalar Dependências**

   Certifique-se de ter o [Flutter](https://flutter.dev/docs/get-started/install) e o [Dart](https://dart.dev/get-dart) instalados. No diretório do projeto, execute:

   ```bash
   flutter pub get
