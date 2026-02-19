import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/grievance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/grievance.dart';
import '../../models/user.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

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
              // Custom FormField to avoid deprecated 'value' parameter
              FormField<GrievanceCategory>(
                initialValue: _selectedCategory,
                validator: (value) => value == null ? 'Please select category' : null,
                builder: (FormFieldState<GrievanceCategory> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: const OutlineInputBorder(),
                      errorText: state.errorText,
                    ),
                    child: DropdownButton<GrievanceCategory>(
                      value: state.value,
                      hint: const Text('Select Category'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: GrievanceCategory.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        state.didChange(newValue);
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Brief summary of the issue',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
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
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
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
                builder: (context, grievanceProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: grievanceProvider.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                // Capture necessary objects before async
                                final scaffoldMessenger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);
                                final currentUser = auth.currentUser!;

                                bool success = await grievanceProvider.submitGrievance(
                                  userId: currentUser.id,
                                  userName: currentUser.name,
                                  userType: currentUser.type == UserType.citizen ? 'citizen' : 'fps',
                                  category: _selectedCategory!,
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                );

                                if (success && mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text('Grievance submitted successfully'),
                                      backgroundColor: AppColors.green,
                                    ),
                                  );
                                  navigator.pop();
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: grievanceProvider.isLoading
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