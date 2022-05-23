// import 'package:flutter/material.dart';

// import '_item.dart';

// class MyCartButton extends StatelessWidget {
//   final BuildContext context;
//   final Future<Itens> itens;

//   const MyCartButton({Key? key, required this.context, required this.itens})
//       : super(key: key);
//   // const MyCartButton({Key? key, required this.context}) : super(key: key);

//   void showCart() {
//     var loadingItens = FutureBuilder<Itens>(
//         future: itens,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final itens = snapshot.data!;
//             var tiles = <Widget>[];
//             for (var i = 0; i < itens.ids.length; i++) {
//               tiles.add(ListTile(
//                 title:
//                     Text(itens.names[i], style: const TextStyle(fontSize: 25)),
//               ));
//             }

//             final dividedTiles = tiles.isNotEmpty
//                 ? ListTile.divideTiles(
//                     context: context,
//                     tiles: tiles,
//                   ).toList()
//                 : <Widget>[];

//             return ListView(children: dividedTiles);
//           } else if (snapshot.hasError) {
//             return Text("${snapshot.error}");
//           }

//           // By default, show a loading spinner
//           return const CircularProgressIndicator();
//         });

//     Navigator.of(context).pushNamed("/showCart", arguments: {'itens': itens});
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => CartPage()),
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: const Icon(
//         Icons.shopping_cart,
//         color: Colors.white,
//       ),
//       onPressed: () => {
//         Navigator.of(context)
//             .pushNamed("/showCart", arguments: {'itens': itens})
//       },
//     );
//   }
// }
