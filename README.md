# AcheiDocs

**AcheiDocs** é um aplicativo Flutter que permite ao usuário cadastrar e buscar documentos perdidos ou encontrados.

O projeto usa o **Firebase Realtime Database** para armazenar os dados de documentos cadastrados e realizar buscas em tempo real.

## Funcionalidades

- **Busca de Documentos**: Permite ao usuário buscar documentos no banco de dados por nome.
- **Cadastro de Documentos**: Permite que os usuários cadastrem documentos encontrados ou perdidos.
- **Contador de Documentos**: Exibe a quantidade total de documentos cadastrados em tempo real.
- **Menu de Navegação**: Oferece acesso às seções de Dicas de Segurança, Feedback e Sobre o App.

## Tecnologias

- **Flutter**: Framework para desenvolvimento de aplicativos móveis.
- **Firebase**: Plataforma de desenvolvimento que fornece banco de dados em tempo real.
- **Firebase Realtime Database**: Armazenamento e recuperação de dados em tempo real.

### Cadastro de Documento

O formulário de cadastro exige os seguintes campos:

- **Nome Completo**
- **Telefone** (com máscara de entrada)
- **Cidade**
- **Estado**
- **Tipo de Documento** (como RG, CPF, etc.)
- **Situação** (Achado ou Perdido)

### Dicas de Segurança

A seção de **Dicas de Segurança** oferece orientações sobre como proteger seus documentos.

### Feedback

Os usuários podem fornecer feedback sobre o app através de um formulário simples.

### Sobre

A seção **Sobre** exibe informações sobre o app, como versão e politica de privacidade.

## Estrutura do Projeto

A estrutura do projeto é organizada da seguinte forma:

- **lib/**: Diretório principal contendo o código do aplicativo.
  - **main.dart**: Arquivo principal que inicia o app.
  - **telas/**: Diretório com as telas do aplicativo.
    - **home_page.dart**: Tela inicial com busca e cadastro de documentos.
    - **dicas_seguranca.dart**: Tela com dicas de segurança.
    - **feedback.dart**: Tela de feedback do usuário.
    - **sobre.dart**: Tela sobre o aplicativo.
  - **widgets/**: Diretório com widgets reutilizáveis.
    - **cadastrar_documento.dart**: Formulário para cadastro de documentos.

## Licença

Este projeto é licenciado sob a Licença MIT.

