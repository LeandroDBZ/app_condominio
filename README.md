# App Condominio

**App Condominio** é um aplicativo desenvolvido com Flutter e integrado com Firebase, destinado ao gerenciamento e administração eficiente de condomínios. Seu objetivo é oferecer uma plataforma intuitiva que auxilie na autenticação, controle dos dados dos usuários e futuras integrações para gerenciamento de acesso, comunicados e relatórios. 

## Tabela de Conteúdos
- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Configuração](#instalação-e-configuração)
- [Execução do App](#execução-do-app)
- [Contribuição](#contribuição)
- [Contato](#contato)

## Sobre o Projeto
Este projeto foi criado como ponto de partida para a construção de um aplicativo de gerenciamento de condomínios. No momento, o app conta com uma tela de login e uma tela principal, servindo de base para futuras implementações que possam incluir o cadastro de usuários, controle de incidentes e a gestão de notificações. 

## Funcionalidades
- **Tela de Login:** Realiza a autenticação dos usuários utilizando Firebase Authentication.
- **Tela Principal:** Apresenta a interface inicial com acesso às funcionalidades essenciais do app.
- **Integração com Firebase:** Utiliza o Firebase para autenticação, armazenamento de dados e, futuramente, para envio de notificações.
- **Desenvolvimento Multiplataforma:** Compatível com Android, iOS, Web, Windows, macOS e Linux.

*Funcionalidades previstas para futuras versões:*
- Cadastro e gerenciamento de dados dos usuários e unidades.
- Dashboard com relatórios e controle de veículos.
- Sistema de notificações e comunicados.
- Integração com sistemas de acesso.

## Tecnologias Utilizadas
- **Flutter & Dart:** Para o desenvolvimento da interface e lógica do aplicativo.
- **Firebase:** Gerenciamento de autenticação, banco de dados em tempo real, armazenamento e notificações.
- **Plataformas Suportadas:** Android, iOS, Web, Windows, macOS e Linux. 

## Pré-requisitos
Antes de iniciar, certifique-se de ter instalado em sua máquina:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (normalmente incluso com o Flutter)
- Uma conta no [Firebase](https://firebase.google.com/) para a configuração da aplicação.
- Um editor de código, como [VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio).

## Instalação e Configuração
1. **Clone o repositório:**
   ```bash
   git clone https://github.com/LeandroDBZ/app_condominio.git
2. **Instale as dependências:**
   ```bash
   cd app_condominio
   flutter pub get
3. **Configuração do Firebase:**
  - Crie um novo projeto no Firebase Console.
  - Adicione os aplicativos correspondentes (Android, iOS, Web) e baixe os arquivos de configuração (por exemplo, google-services.json para Android e GoogleService-Info.plist para iOS).
  - Siga as orientações da documentação do FlutterFire para a integração completa.

## Execução do App
Para rodar o aplicativo, utilize os seguintes comandos:
- Android/iOS:
  ```bash
  flutter run

- Web:
  ```bash
  flutter run -d chrome

**Lembre-se de ter o emulador ou dispositivo conectado para a execução.**

## Contribuição
Contribuições são bem-vindas! Se você deseja melhorar o App Condominio, siga estes passos:
1. Faça um fork deste repositório.
2. Crie uma branch para a sua feature:
   ```bash
   git checkout -b minha-feature
3. Faça os commits com suas alterações:
   ```bash
   git commit -m 'Minha nova feature'
4. Envie sua branch:
   ```bash
   git push origin minha-feature
5. Abra um Pull Request detalhando suas modificações.

## Contato
Desenvolvido por Leandro. Para dúvidas, sugestões ou feedback, você pode abrir uma issue neste repositório ou entrar em contato diretamente.
