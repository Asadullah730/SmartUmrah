import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_umrah_app/Controller/expense_track_controller.dart';

final _formKey = GlobalKey<FormState>();
final TextEditingController _itemController = TextEditingController();
final TextEditingController _placeController = TextEditingController();
final TextEditingController _amountController = TextEditingController();
final ExpenseController expenseController = Get.put(ExpenseController());
void showAddExpenseDialog(BuildContext context) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text(
        "Add Expense",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _itemController,
              decoration: const InputDecoration(
                labelText: "Item (e.g., Tasbeeh)",
                prefixIcon: Icon(Icons.shopping_bag),
              ),
              validator: (value) => value!.isEmpty ? "Enter item name" : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: "Place (e.g., Madinah)",
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) => value!.isEmpty ? "Enter place" : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount (SAR)",
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) => value!.isEmpty ? "Enter amount" : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              expenseController.addExpense(
                _itemController.text,
                _placeController.text,
                double.parse(_amountController.text),
              );
              _itemController.clear();
              _placeController.clear();
              _amountController.clear();
              Get.back();
            }
          },
          child: const Text("Add"),
        ),
      ],
    ),
  );
}

void showEditExpenseDialog(
  BuildContext context,
  int index,
  Map<String, dynamic> expense,
) {
  final TextEditingController _itemController = TextEditingController(
    text: expense["item"],
  );
  final TextEditingController _placeController = TextEditingController(
    text: expense["place"],
  );
  final TextEditingController _amountController = TextEditingController(
    text: expense["amount"].toString(),
  );

  final _formKey = GlobalKey<FormState>();
  final ExpenseController expenseController = Get.find();

  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text(
        "Edit Expense",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _itemController,
              decoration: const InputDecoration(
                labelText: "Item",
                prefixIcon: Icon(Icons.shopping_bag),
              ),
              validator: (value) => value!.isEmpty ? "Enter item name" : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _placeController,
              decoration: const InputDecoration(
                labelText: "Place",
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) => value!.isEmpty ? "Enter place" : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount (SAR)",
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) => value!.isEmpty ? "Enter amount" : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              expenseController.editExpense(
                index,
                _itemController.text,
                _placeController.text,
                double.parse(_amountController.text),
              );
              Get.back();
            }
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}
