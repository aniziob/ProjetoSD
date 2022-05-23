## Observações relevantes

- O código escrito para esse projeto esta todo dentro da pasta **/lib** (o resto é configuração incial ao criar um projeto)
- Flutter utiliza a classe Future para tratar de dados async

## Rotas consumidas com o protocolo HTTP

- Método GET  na API 1 http://localhost:8001/buy_item -> Retorna os itens mostrados na tela de comprar e ver oq está comprado
- Método POST na API 1 http://localhost:8001/register_item -> é usada pela API 2 quando se consome a mesma rota
- Método POST na API 1 http://localhost:8001/buy_itens -> Faz a compra do item enviando o id e a quantidade comprada

- Método POST na API 2 http://localhost:8002/register_item -> Registra um item e repassa os dados desse item para a API 1

## Como rodar ?

É necessário configurar o ambiente flutter seguindo a documentação ->
https://docs.flutter.dev/get-started/install

* 1 - Instalar o flutter SDK: 
  * ![Download do SDK 3.0.1](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.0.1-stable.zip)
  * Se a versão 3.0.1 for antiga, então a nova versão estará disponível em um novo link na documentação
  * Colocar a pasta do SDK numa pasta sem espaços ou caracteres especiais
  * Não pode ser dentro de uma pasta que precisa de privilégios elevados
* 2 - Baixa Android Studio  -> https://developer.android.com/studio
* 3 - Abrir Android Studio
  * Configurar uma virtual machine
    * More Actions > virtual machine manager > Create Device > Escolhe telefone > Download e Escolhe uma versão do SO Android > Escolhe configurações opcionais (name, orientation, graphics) > Finish
  * Baixar google USB driver + Android SDK Command-line Tools (latest)
    * More Actions > SDK manager > Android SDK > SDK Tools > seleciona as caixas google USB driver + Android SDK Command-line Tools (latest) > Apply
* 4 - Rodar o comando `flutter doctor` em algum terminal
  * Será necessário aceitar licensas usando o comando que o flutter doctor mostrar
  * Não é preciso ter Chrome e Visual Studio para rodar esse projeto
  * Todos os outros requerimentos do flutter doctor são necessários
  * Caso haja algum requerimento faltando, então será necesário seguir as instruções do flutter doctor ou da documentação do flutter
* 5 - Baixar extensão do flutter no VS Code (recomendado, mas não necessário)
  *  Segunda parte da documentação sobre Editor VS Code: https://docs.flutter.dev/get-started/editor?tab=vscode
  *  Link da entensão na web: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
  *  Nome do pacote de extensões: Flutter
  *  Nome do autor da extensão: Dart Code
  *  Id da extensão: Dart-Code.flutter
* 6 - Abrir uma das pastas módulos no editor 
  * O editor deve estar completamente configurado
  * Selecionar um **device** entre as opções: Edge, Chrome, VM criada no passo 3 ou um celular conectado por USB no pc
    * OBS: Se o device escolhido for um celular por USB, então será necessário ativar **modo depuração** e **permitir tráfego de dados** entre o pc e celular 
    * É possível fazer o celular por USB se comunicar com APIs rodando localmente ou na web
  * O tempo para comppilar é grande e maior ainda se usar uma VM ou Debug Mode
  * Clicar em Run (com ou sem debug, não importa) 
  