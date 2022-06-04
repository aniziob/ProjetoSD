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
  List<int> _quantities = [];

  Widget _waitFutureData() {
    return FutureBuilder<Itens>(
      future: futureItens,
      builder: (context, snapshot) {
        print("Build Widget -> ${snapshot.hasData}");
        if (snapshot.hasData) {
          print("Conteúdo de futureItens: ${snapshot.data}");
          Itens? data = snapshot.data;
          if (data != null) {
            _quantities = data.quantityPurchaseds; // Atualiza _quantities
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
            // height: 300.0,
            child: ListTile(
              title: Text(
                data.names[index],
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                data.descriptions[index],
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
              leading: Image.network(
                data.imageLinks[index],
                width: 80.0,
                // height: 150.0,
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
                },
              ),
              trailing: SizedBox(
                width: 220.0,
                // height: 250.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (alreadyInCart) {
                              _cart.remove(currentItem);
                              // _quantities[index] = 0;
                            } else {
                              _cart.add(currentItem);
                              // if (_quantities[index] == 0)
                              //   _quantities[index] = 1;
                            }
                          });
                        },
                        icon: Icon(
                          alreadyInCart
                              ? Icons.remove_circle
                              : Icons.add_shopping_cart_rounded,
                          color: alreadyInCart ? Colors.red : Colors.white,
                          semanticLabel: alreadyInCart
                              ? 'Remove from cart'
                              : 'Add to cart',
                        ),
                      ),
                      visible: _quantities[index] > 0,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _quantities[index] += 1;
                        });
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.deepPurple,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Restriction: Make qty never fall below zero
                        if (_quantities[index] == 0) return;

                        // If qty has changed, then setState()
                        // render _ItemShopPageState again
                        setState(() {
                          _quantities[index] -= 1;

                          // Edge case: Remove from cart if qty goes back to 0
                          if (_quantities[index] == 0) {
                            _cart.remove(currentItem);
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Qty: ${_quantities[index]}"),
                          Text("R\$${currentItem.price.toStringAsFixed(2)}"),
                          Text(
                            "Total: " +
                                (currentItem.price * _quantities[index])
                                    .toStringAsFixed(2),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
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
          MyBuyButton(itensToBuy: _cart, quantities: _quantities),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: _waitFutureData(),
    );

    return CustomBackground(child: itemShopPageBody, w: _width, h: _height);
  }
}

// class ShopItem extends StatelessWidget {
//   const ShopItem({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Text("Todo o corpo do item aki");
//   }
// }
