import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseController extends GetxController {
  var expenses = <Map<String, dynamic>>[].obs;

  double get totalExpense =>
      expenses.fold(0.0, (sum, item) => sum + (item["amount"] as double));

  void addExpense(String item, String place, double amount) {
    expenses.add({
      "item": item,
      "place": place,
      "amount": amount,
      "date": DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.now()),
    });
  }

  void editExpense(int index, String item, String place, double amount) {
    expenses[index] = {
      "item": item,
      "place": place,
      "amount": amount,
      "date": DateFormat("dd MMM yyyy, hh:mm a").format(DateTime.now()),
    };
  }

  void deleteExpense(int index) {
    expenses.removeAt(index);
  }
}
