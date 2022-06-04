import 'package:flutter/material.dart';

// Meus imports
import '_item.dart';
import 'fetch_itens.dart';

class BuyedPage extends StatefulWidget {
  // List<Item> itens;

  // CartPage({Key? key, required this.itens}) : super(key: key);
  const BuyedPage({Key? key}) : super(key: key);

  @override
  // State<CartPage> createState() => _CartPageState(itens);
  State<BuyedPage> createState() => _BuyedPageState();
}

class _BuyedPageState extends State<BuyedPage> {
  late Future<Itens> futureItens;
  List<int> _quantities = [];

  // _CartPageState(List<Item> itens);

  Widget _waitFutureData() {
    return FutureBuilder<Itens>(
      future: futureItens,
      builder: (context, snapshot) {
        print("Build Widget, ${snapshot.hasData}");
        if (snapshot.hasData) {
          print("Future Itens, ${snapshot.data}");
          Itens? data = snapshot.data;
          if (data != null) {
            _quantities = data.quantityPurchaseds; // Atualiza _quantities
            return _buildTiles(data);
          } else {
            return const CircularProgressIndicator();
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return const CircularProgressIndicator(); // Mostra um loading Widget
      },
    );
  }

  Widget _buildTiles(Itens data) {
    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // print("A");
    // print(arguments);
    // print("=-----=");
    // var itens = arguments['itens']; // Future<Itens>
    // print("B");
    // print(itens);
    // // print(itens.ids.length);
    // print("=-----=");

    var hasBuildedDivider = false;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd && !hasBuildedDivider) return const Divider();
        hasBuildedDivider = false; // reset

        //            i = 0 1 2 3 4 5 6 7 8 9 ...
        // index = f(i) = 0 0 1 1 2 2 3 3 4 4 ...
        final index = i ~/ 2;

        if (index < data.ids.length && data.isBuyeds[index]) {
          final currentItem = Item(
            id: data.ids[index],
            name: data.names[index],
            price: data.prices[index],
            description: data.descriptions[index],
            imageLink: data.imageLinks[index],
            isBuyed: data.isBuyeds[index],
            quantityPurchased: data.quantityPurchaseds[index],
          );

          return SizedBox(
            width: double.maxFinite,
            // height: 500.0,
            child: ListTile(
              title: Text(
                currentItem.name,
                style: const TextStyle(fontSize: 15),
              ),
              leading: Image.network(currentItem.imageLink, width: 80.0,
                  errorBuilder: (_, object, stackTrace) {
                return const SizedBox(
                  width: 80.0, // Make Text wrap and allow white background
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Text(
                      "Error loading image from link",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }),
              subtitle: Text(
                currentItem.description,
                style: const TextStyle(fontSize: 15),
              ),
              trailing: SizedBox(
                width: 160.0,
                // height: 100.0,
                child: Text("Qty: ${_quantities[index]}"),
              ),
            ),
          );
        } else if (index < data.ids.length && !data.isBuyeds[index]) {
          hasBuildedDivider = true;
          return const SizedBox.shrink();
        } else {
          // return const Text("Vazio");
          return const ListTile(
            title: Text("Vazio", style: TextStyle(fontSize: 15)),
            leading: Icon(
              Icons.do_not_disturb,
              color: Colors.white,
              semanticLabel: "Slot de item vazio",
            ),
          );
        }
      },
    );
    // FutureBuilder<Itens>(
    //     future: itens,
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

    // var tiles = <Widget>[];
    // for (var i = 0; i < itens.length; i++) {
    //   tiles.add(ListTile(
    //     title: Text(itens[i].names, style: const TextStyle(fontSize: 25)),
    //   ));
    // }

    // final tiles = itens.map((item) {
    //   return ListTile(
    //       title: Text(item.name, style: const TextStyle(fontSize: 25)));
    // });
    // print("C");
    // print(tiles);
    // print("=-----=");

    // final dividedTiles = tiles.isNotEmpty
    //     ? ListTile.divideTiles(
    //         context: context,
    //         tiles: tiles,
    //       ).toList()
    //     : <Widget>[];

    // return ListView(children: dividedTiles);
  }

  @override
  void initState() {
    super.initState();
    futureItens = fetchItens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Itens Comprados"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      backgroundColor: Colors.amber, // Color(0xFF273A48),
      body: _waitFutureData(), // _buildTiles(),
    );
  }
}
