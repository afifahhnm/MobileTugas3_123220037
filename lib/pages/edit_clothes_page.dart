import 'package:flutter/material.dart';
import '../services/clothes_services.dart';

class EditClothesPage extends StatefulWidget {
  final int id;
  const EditClothesPage({super.key, required this.id});

  @override
  State<EditClothesPage> createState() => _EditClothesPageState();
}

class _EditClothesPageState extends State<EditClothesPage> {
  final Map<String, TextEditingController> controllers = {};
  bool _isDataLoaded = false;

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clothing Update"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _clothesEdit(),
      ),
    );
  }

  Widget _clothesEdit() {
    return FutureBuilder(
      future: ClothesApi.getClothesById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          if (!_isDataLoaded) {
            _isDataLoaded = true;
            final data = snapshot.data!["data"];
          
            for (var key in data.keys) {
              if (key != "id") {
                controllers[key] = TextEditingController(text: "${data[key]}");
              }
            }
          }
          return _clothesEditForm();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _clothesEditForm() {
    return ListView(
      children: [
        TextField(
          controller: controllers["name"],
          decoration: const InputDecoration(
            labelText: "Name",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllers["category"],
          decoration: const InputDecoration(
            labelText: "Category",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllers["brand"],
          decoration: const InputDecoration(
            labelText: "Brand",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllers["material"],
          decoration: const InputDecoration(
            labelText: "Material",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllers["price"],
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Price",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllers["sold"],
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Sold",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllers["stock"],
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Stock",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllers["yearReleased"],
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Year Released",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controllers["rating"],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: "Rating",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _updateClothes,
          child: const Text("Save Changes"),
        ),
      ],
    );
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _updateClothes() async {
 
    final data = <String, dynamic>{};
    for (var key in controllers.keys) {
      data[key] = controllers[key]!.text.trim();
    }

    // Validasi sederhana
    final requiredFields = ["name", "category", "brand", "material"];
    for (var field in requiredFields) {
      if (data[field] == null || data[field].isEmpty) {
        showSnackBar("Field '$field' wajib diisi");
        return;
      }
    }

    // Validasi numerik dan range
    final price = int.tryParse(data["price"] ?? "");
    if (price == null || price < 0) {
      showSnackBar("Price must be a positive number");
      return;
    }
    final sold = int.tryParse(data["sold"] ?? "");
    if (sold == null || sold < 0) {
      showSnackBar("Sold must be a positive number");
      return;
    }
    final stock = int.tryParse(data["stock"] ?? "");
    if (stock == null || stock < 0) {
      showSnackBar("Stock must be a positive number");
      return;
    }
    final yearReleased = int.tryParse(data["yearReleased"] ?? "");
    if (yearReleased == null || yearReleased < 2018 || yearReleased > 2025) {
      showSnackBar("Release year must be between 2018 and 2025");
      return;
    }
    final rating = double.tryParse(data["rating"] ?? "");
    if (rating == null || rating < 0 || rating > 5) {
      showSnackBar("Rating must be between 0 and 5");
      return;
    }

    data["price"] = price;
    data["sold"] = sold;
    data["stock"] = stock;
    data["yearReleased"] = yearReleased;
    data["rating"] = rating;

    try {
      final response = await ClothesApi.updateClothes(widget.id, data);
      if (response["status"] == "Success") {
        showSnackBar("Successfully changed clothes ${data['name']}");
        Navigator.pop(context);
      } else {
        showSnackBar("Gagal: ${response["message"]}");
      }
    } catch (e) {
      showSnackBar("Error saat update: $e");
    }
  }
}
