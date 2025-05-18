import 'package:flutter/material.dart';
import '../services/clothes_services.dart';

class DetailClothesPage extends StatelessWidget {
  final int id;

  const DetailClothesPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clothing Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothesDetail(),
      ),
    );
  }

  Widget _clothesDetail() {

    return FutureBuilder(
      future: ClothesApi.getClothesById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error.toString()}");
        }
        
        else if (snapshot.hasData) {
        
          final response = snapshot.data!;
          if (response["status"] == "Error") {
            return Text("Gagal: ${response["message"]}");
          }

     
          final item = response["data"];

          return _clothes(item);
        }
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothes(Map<String, dynamic> item) {
    return ListView(
      children: item.entries.map((entry) {
        return ListTile(
          title: Text(entry.key),
          subtitle: Text('${entry.value}'),
        );
      }).toList(),
    );
  }
}
