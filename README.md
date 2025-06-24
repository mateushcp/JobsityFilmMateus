# JobsityFilmMateus

Um aplicativo iOS para navegar e buscar séries de TV usando a [TVMaze API](https://www.tvmaze.com/api).  
O projeto está escrito em Swift, seguindo arquitetura **MVVM** e usando um **Coordinator** para navegação.

---

## 🎬 Conteúdo

1. [Clone o repositório](#-clone-o-repositório)  
2. [Instalação](#-instalação)  
3. [Uso](#-uso)  
   - Executar o `.ipa` pré-compilado  
   - Build & Run no Xcode  
   - Executar testes unitários  
4. [Visão geral da arquitetura](#-visão-geral-da-arquitetura)  
5. [Principais features](#-principais-features)  
6. [Bônus e extras](#%EF%B8%8F-bônus-e-extras)  

---

## 🚀 Clone o repositório

```bash
git clone https://github.com/mateushcp/JobsityFilmMateus.git
cd JobsityFilmMateus

##  🛠 Instalação
Xcode 14.0+
Baixe da Mac App Store ou do Developer Portal.

Abra o workspace

bash
open JobsityFilmMateus/JobsityFilmMateus.xcodeproj
O projeto não utiliza dependências externas via CocoaPods, Carthage ou SwiftPM.


## 🎯 Uso
1. Executar o .ipa pré-compilado
No diretório Distribution/ você encontra o arquivo JobsityFilmMateus.ipa pronto para instalação via TestFlight ou ferramentas como Apple Configurator / iTunes.

2. Build & Run no Xcode
Selecione Any iOS Device (arm64).

Menu Product ▶︎ Run (⌘R).

O app iniciará no simulador ou dispositivo conectado.

3. Executar testes unitários
No Xcode:

Menu Product ▶︎ Test (⌘U)

Confira o relatório de testes no Report Navigator (⌘8).

## 🏗 Visão geral da arquitetura
MVVM-C
Cada tela tem seu View, ViewController e ViewModel.

Coordinator
FilmsityCoordinator gerencia fluxos: Splash → Autenticação → TabBar.

Services

TVMazeServiceProtocol ↔️ TVMazeService: faz fetch de séries, detalhes e busca.

FavoritesManager + UserDefaultsFavoritesRepository: persistência de favoritos.

KeychainHelper: grava/le o PIN do usuário no Keychain.

Fluxo de navegação

Splash: animação inicial

Autenticação: Face ID ou PIN (criado na primeira vez)

TabBar

Populares

Buscar

Favoritos

## ✨ Principais features
Listagem paginada de séries

Busca por nome

Detalhes da série

Nome, pôster, gêneros, resumo

Lista de episódios por temporada

Detalhes do episódio

Nome, número, temporada, resumo, imagem

Favoritos

Adicionar/remover

Persistência em UserDefaults

Tela dedicada “Favoritos”

Segurança

PIN custom (guardado no Keychain)

Biometria (Face ID / Touch ID)

### ## ⚙️ Bônus que foram feitos
📌 PIN e biometria

Usuário cria PIN na primeira abertura

Pode optar por autenticar com Face ID / Touch ID

 ⭐️ Favoritos avançado

Ordenação alfabética

Empty state customizado

🎨 Animações

Splash (triângulo + logo)

“Respirar” no Face ID (elipses pulsantes)

Transições suaves (cross-dissolve)

🧩 Arquitetura modular

Features/

Common/

Resources/

###### ✅ Testes unitários

AuthenticationViewModelTests

AuthenticationViewControllerTests

AuthenticationViewTests

## 📬 Entrega
Este repositório contém todo o código-fonte.

Em Distribution/ há o JobsityFilmMateus.ipa.

Para feedback ou dúvidas, entre em contato com seu recrutador ou via issues no GitHub.
