import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Meus imports
import '_item.dart';

class MyCartButton extends StatelessWidget {
  final BuildContext context;
  final List<Item> itens;

  const MyCartButton({Key? key, required this.context, required this.itens})
      : super(key: key);
  // const MyCartButton({Key? key, required this.context}) : super(key: key);

  void showCart() {
    // var loadingItens = ListView.builder(
    //     padding: const EdgeInsets.all(16.0),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         final itens = snapshot.data!;
    //         var tiles = <Widget>[];
    //         for (var i = 0; i < itens.ids.length; i++) {
    //           tiles.add(ListTile(
    //             title:
    //                 Text(itens.names[i], style: const TextStyle(fontSize: 25)),
    //           ));
    //         }

    //         final dividedTiles = tiles.isNotEmpty
    //             ? ListTile.divideTiles(
    //                 context: context,
    //                 tiles: tiles,
    //               ).toList()
    //             : <Widget>[];

    //         return ListView(children: dividedTiles);
    //       } else if (snapshot.hasError) {
    //         return Text("${snapshot.error}");
    //       }

    //       // By default, show a loading spinner
    //       return const CircularProgressIndicator();
    //     });

    Navigator.of(context).pushNamed("/showCart", arguments: {'itens': itens});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.attach_money,
        color: Colors.white,
      ),
      onPressed: () => {
        Navigator.of(context)
            .pushNamed("/showCart", arguments: {'itens': itens})
      },
    );
  }
}

class MyBuyButton extends StatelessWidget {
  final List<Item> itensToBuy;
  final List<int> quantitys;

  const MyBuyButton(
      {Key? key, required this.itensToBuy, required this.quantitys})
      : super(key: key);

  Future<Itens?> _buyItens(List<Item> itensToBuy, List<int> quantitys) async {
    const url = "http://localhost:8001/buy_itens";
    var ids = <int>[];
    var quantitys = <int>[];
    for (Item item in itensToBuy) {
      ids.add(item.id);
      quantitys.add(item.quantityPurchased);
    }
    var body = jsonEncode(<String, List<int>>{
      "ids": ids,
      "quantitys": quantitys,
    });
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true'
      },
      body: body,
    );

    const statusOK = 200;

    if (response.statusCode == statusOK) {
      // print(response);
      // return JsonCodec();
      return null;
    } else {
      throw Exception('Failed to post /buy_itens');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.credit_card,
        color: Colors.white,
      ),
      onPressed: () => {
        // http.post da compra
        _buyItens(itensToBuy, quantitys)
        // Mostra mensagem "Itens comprados"
      },
    );
  }
}
