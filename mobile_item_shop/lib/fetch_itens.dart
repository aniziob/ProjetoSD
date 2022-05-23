import 'package:http/http.dart' as http;
import 'dart:convert';

// Meus imports
import '_item.dart';

Future<Itens> fetchItens() async {
  const url = "http://localhost:8001/buy_item";

  final response = await http.get(Uri.parse(url));

  const statusOK = 200;

  if (response.statusCode == statusOK) {
    final b = jsonDecode(response.body);

    // print(b);

    return Itens.fromJson(b);
  } else {
    throw Exception('Failed to load itens');
  }
}
