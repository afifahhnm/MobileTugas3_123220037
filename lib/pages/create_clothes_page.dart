import 'package:flutter/material.dart';
import '../services/clothes_services.dart';

class CreateClothesPage extends StatefulWidget {
  const CreateClothesPage({super.key});

  @override
  State<CreateClothesPage> createState() => _CreateClothesPageState();
}

class _CreateClothesPageState extends State<CreateClothesPage> {

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    "name": "",
    "price": null,
    "category": "",
    "brand": "",
    "sold": null,
    "rating": null,
    "stock": null,
    "yearReleased": null,
    "material": "",
  };


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

 
      final response = await ClothesApi.createClothes(formData);


      if (response['status'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully added new clothing.")),
        );
        Navigator.pop(context);
      } else {
       
        _showError(response['message']);
      }
    }
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal: $message")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Clothes")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TextFormField secara otomatis generate form berdasarkan key dari Map
              for (var field in formData.keys)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: field,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: field == "rating"
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : (field == "price" ||
                                field == "sold" ||
                                field == "stock" ||
                                field == "yearReleased")
                            ? TextInputType.number
                            : TextInputType.text,
                    onSaved: (val) {
                      formData[field] = (field == "rating")
                          ? double.tryParse(val ?? "")
                          : (field == "price" ||
                                  field == "sold" ||
                                  field == "stock" ||
                                  field == "yearReleased")
                              ? int.tryParse(val ?? "")
                              : val;
                    },
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Wajib diisi' : null,
                  ),
                ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
