import 'package:flutter/material.dart';

class OrderForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController clientNameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController commentsController;
  final VoidCallback onSubmit;

  const OrderForm({
    super.key,
    required this.formKey,
    required this.clientNameController,
    required this.addressController,
    required this.phoneController,
    required this.emailController,
    required this.commentsController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: clientNameController,
            decoration: InputDecoration(labelText: 'Client Name'),
            validator: (value) => value!.isEmpty ? 'Enter client name' : null,
          ),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Address'),
            validator: (value) => value!.isEmpty ? 'Enter address' : null,
          ),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'Phone'),
            validator: (value) => value!.isEmpty ? 'Enter phone' : null,
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => value!.isEmpty ? 'Enter email' : null,
          ),
          TextFormField(
            controller: commentsController,
            decoration: InputDecoration(labelText: 'Comments'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text('Submit Order'),
          )
        ],
      ),
    );
  }
}
