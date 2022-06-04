import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ItemRegisterApp());

class ItemRegisterApp extends StatelessWidget {
  const ItemRegisterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const ItemRegisterScreen(),
        '/ok': (context) => const OkScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class ItemRegisterScreen extends StatelessWidget {
  const ItemRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          // height: 550,
          child: Card(
            child: ItemRegisterForm(),
          ),
        ),
      ),
    );
  }
}

class OkScreen extends StatelessWidget {
  const OkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Item registrado!',
            style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}

class ItemRegisterForm extends StatefulWidget {
  const ItemRegisterForm({Key? key}) : super(key: key);

  @override
  _ItemRegisterFormState createState() => _ItemRegisterFormState();
}

class _ItemRegisterFormState extends State<ItemRegisterForm> {
  final _nameTextController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageLinkController = TextEditingController();

  double _formProgress = 0;
  String _inputURL =
      'https://blog.megajogos.com.br/wp-content/uploads/2018/07/no-image.jpg';

  final _formKey = GlobalKey<FormState>();

  void _updateFormProgress() {
    var progress = 0.0;

    final controllers = [
      _nameTextController,
      _priceController,
      _descriptionController,
      _imageLinkController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  void _showOkScreen() {
    Navigator.of(context).pushNamed('/ok');
  }

  // Função que testa se a URL é válida (não funciona)
  // Future<http.Response> _checkURL(Uri url) async {
  //   final res = await http.get(url);

  //   print('Response status: ${res.statusCode}');
  //   print('Response body: ${res.body}');

  //   return res;
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Cadastre um item',
              style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameTextController,
              decoration: const InputDecoration(
                labelText: 'Nome do item',
                hintText: 'Max caracteres: 64',
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(64)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (price) {
                if (price == null) return "Digite um preço";

                final isValidPrice = RegExp(r'^[0-9]*(\.[0-9]{1,2})?$');
                if (!isValidPrice.hasMatch(price)) {
                  return "Formato do preço -> X..X.XX";
                }

                return null;
              },
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Preço (R\$)',
                hintText: 'Formatação: X...X.XX',
              ),
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]|\.')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Max caracteres: 512',
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(512)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (url) {
                if (url == null) return "Digite uma url válida";

                final isValidURL = Uri.parse(url).isAbsolute;
                if (!isValidURL) return "Digite uma url válida";

                return null;
              },
              controller: _imageLinkController,
              decoration: const InputDecoration(
                labelText: 'Imagem do item (link)',
                hintText: 'Imagem do item (link)',
              ),
            ),
          ),
          Image.network(
            _inputURL,
            errorBuilder: (_, object, stackTrace) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Falha ao carregar imagem na rede"),
              );
            },
            headers: const {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Credentials': 'true'
            },
            width: 128.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.white;
                }),
                backgroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : Colors.blue;
                }),
              ),
              onPressed: _formProgress == 1 && _formKey.currentState!.validate()
                  ? _registerIten //_showOkScreen // _requestPOST()
                  : null,
              child: const Text('Enviar informações'),
            ),
          ),
        ],
      ),
    );
  }

  void _registerIten() async {
    // Mostra uma miniatura da imagem
    _displayImage();

    // Define a url e body da requisição
    const url = "http://localhost:8002/register_item";
    var body = jsonEncode(<String, dynamic>{
      "name": _nameTextController.text,
      "price": double.parse(_priceController.text),
      "description": _descriptionController.text,
      "img_link": _imageLinkController.text,
    });

    // Faz a requisição
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true'
      },
      body: body,
    );

    // Checa se a requisição retornou OK
    const statusOK = 200;

    if (response.statusCode == statusOK) {
      return null;
    } else {
      throw Exception('Failed to post /register_item');
    }
  }

  void _displayImage() {
    // Disparo - Atualiza a preview
    // Image.network(url);
    // Drag and Drop -> https://www.google.com/search?q=drag+and+drop+iamge+input+form+in+flutter&oq=drag+and+drop+iamge+input+form+in+flutter&aqs=edge..69i57.8971j0j1&sourceid=chrome&ie=UTF-8
    // Fetch -> https://docs.flutter.dev/cookbook/networking/fetch-data
    // Cors -> https://navoki.com/solved-flutter-web-cors-error/#Adding_CORS_Cross-Origin_Resource_Sharing_header
    // Exemplos de urls que funcionam:
    /*
    https://picsum.photos/250?image=9
    https://picsum.photos/250?image=7
    https://picsum.photos/250?image=6
    */
    // Exemplos de urls que NÃO funcionam:
    /*
    http://bestflutterapps.com/wp-content/uploads/2021/07/flappy_bird_game_flutter.jpg
    */
    setState(() {
      _inputURL = _imageLinkController.text;
    });
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({Key? key, required this.value})
      : super(key: key);

  // const AnimatedProgressIndicator({
  //   required this.value,
  // });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
