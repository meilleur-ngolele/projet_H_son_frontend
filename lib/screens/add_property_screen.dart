import 'package:flutter/material.dart';
import '../services/property_service.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageController = TextEditingController();
  String _type = 'hotel';
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await PropertyService.createProperty(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      type: _type,
      pricePerNight: double.tryParse(_priceController.text.trim()) ?? 0,
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
      imageUrl: _imageController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Bien publié avec succès !' : 'Erreur lors de la publication'), backgroundColor: success ? const Color(0xFF00A86B) : Colors.red),
      );
      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publier un logement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleController, validator: (v) => v!.isEmpty ? 'Requis' : null, decoration: const InputDecoration(labelText: 'Titre')),
              TextFormField(controller: _priceController, keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Requis' : null, decoration: const InputDecoration(labelText: 'Prix par nuit (FCFA)')),
              TextFormField(controller: _cityController, validator: (v) => v!.isEmpty ? 'Requis' : null, decoration: const InputDecoration(labelText: 'Ville')),
              TextFormField(controller: _addressController, validator: (v) => v!.isEmpty ? 'Requis' : null, decoration: const InputDecoration(labelText: 'Adresse')),
              TextFormField(controller: _imageController, validator: (v) => v!.isEmpty ? 'Requis' : null, decoration: const InputDecoration(labelText: 'URL de l\'image')),
              TextFormField(controller: _descController, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), minimumSize: const Size(double.infinity, 50)),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Publier', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}