import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/grievance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/grievance.dart';

class GrievanceFormScreen extends StatefulWidget {
  const GrievanceFormScreen({super.key});

  @override
  State<GrievanceFormScreen> createState() => _GrievanceFormScreenState();
}

class _GrievanceFormScreenState extends State<GrievanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  GrievanceCategory? _selectedCategory;
  String? _attachmentUrl; // Placeholder for file picker

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final grievanceProvider = Provider.of<GrievanceProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Grievance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Please provide details of your issue', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              DropdownButtonFormField<GrievanceCategory>(
                initialValue: _selectedCategory,
                hint: const Text('Select Category'),
                items: GrievanceCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (v) => v == null ? 'Please select category' : null,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Brief summary of the issue',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Explain your problem in detail',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File picker not implemented')),
                  );
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Attach File (optional)'),
              ),
              const SizedBox(height: 30),
              Consumer<GrievanceProvider>(
                builder: (context, gp, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: gp.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                bool success = await gp.submitGrievance(
                                  userId: auth.currentUser!.id,
                                  userName: auth.currentUser!.name,
                                  userType: auth.currentUser!.type == UserType.citizen ? 'citizen' : 'fps',
                                  category: _selectedCategory!,
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                );
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Grievance submitted successfully'),
                                      backgroundColor: AppColors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: gp.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Submit'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}