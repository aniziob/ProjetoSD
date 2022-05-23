import 'package:flutter/material.dart';

// Meus imports
import 'custom_background.dart';
import '_item.dart';
import 'buyed_page.dart';
import 'custom_buttons.dart';
import 'fetch_itens.dart';

void main() {
  runApp(const ItemShopApp());
}

class ItemShopApp extends StatelessWidget {
  const ItemShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const ItemShopPage(),
        '/showCart': (context) => const BuyedPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class ItemShopPage extends StatefulWidget {
  const ItemShopPage({Key? key}) : super(key: key);

  @override
  _ItemShopPageState createState() => _ItemShopPageState();
}

class _ItemShopPageState extends State<ItemShopPage> {
  late Future<Itens> futureItens;

  final _cart = <Item>[];
  List<int> _quantitys = [];

  Widget _waitFutureData() {
    return FutureBuilder<Itens>(
      future: futureItens,
      builder: (context, snapshot) {
        print("Build Widget, ${snapshot.hasData}");
        if (snapshot.hasData) {
          print("Future Itens, ${snapshot.data}");
          Itens? data = snapshot.data;
          if (data != null) {
            _quantitys = data.quantityPurchaseds; // Atualiza _quantitys
            return _buildFutureData(data);
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

  Widget _buildFutureData(Itens data) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        //            i = 0 1 2 3 4 5 6 7 8 9 ...
        // index = f(i) = 0 0 1 1 2 2 3 3 4 4 ...
        final index = i ~/ 2;
        // print(index);

        if (index < data.ids.length) {
          var currentItem = Item(
            id: data.ids[index],
            name: data.names[index],
            price: data.prices[index],
            description: data.descriptions[index],
            imageLink: data.imageLinks[index],
            isBuyed: data.isBuyeds[index],
            quantityPurchased: data.quantityPurchaseds[index],
          );

          final alreadyInCart = _cart.contains(currentItem);

          return SizedBox(
            width: double.maxFinite,
            // height: 500.0,
            child: ListTile(
              title: Text(
                data.names[index],
                style: const TextStyle(fontSize: 15),
              ),
              leading: Image.network(
                data.imageLinks[index],
                width: 80.0,
              ),
              subtitle: Text(
                data.descriptions[index],
                style: const TextStyle(fontSize: 15),
              ),
              trailing: SizedBox(
                width: 160.0,
                // height: 100.0,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (alreadyInCart) {
                            _cart.remove(currentItem);
                            // _quantitys.add(0);
                          } else {
                            _cart.add(currentItem);
                            // _quantitys.add(0);
                          }
                        });
                      },
                      icon: Icon(
                        alreadyInCart
                            ? Icons.remove_circle
                            : Icons.add_shopping_cart_rounded,
                        color: alreadyInCart ? Colors.red : Colors.white,
                        semanticLabel:
                            alreadyInCart ? 'Remove from cart' : 'Add to cart',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _quantitys[index] += 1;
                        });
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        // color: Colors.deepPurple,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_quantitys[index] == 0) return;
                        setState(() {
                          _quantitys[index] -= 1;
                        });
                      },
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        // color: Colors.amber,
                      ),
                    ),
                    Text("Qty: ${_quantitys[index]}"),
                  ],
                ),
              ),
            ),
          );
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
  }

  @override
  void initState() {
    super.initState();
    futureItens = fetchItens();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final itemShopPageBody = Scaffold(
      appBar: AppBar(
        title: const Text("Shop de remédios \n(totalmente não da deep web)"),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          MyCartButton(context: context, itens: _cart),
          MyBuyButton(itensToBuy: _cart, quantitys: _quantitys),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: _waitFutureData(),
    );

    return CustomBackground(child: itemShopPageBody, w: _width, h: _height);
  }
}

class ShopItem extends StatelessWidget {
  const ShopItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Todo o corpo do item aki");
  }
}
