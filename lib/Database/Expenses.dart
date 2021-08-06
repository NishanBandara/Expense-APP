import 'DB_Helper.dart';

class Expense {
  int id;
  String expenseType;
  int amount;
  // String photo

  Expense(this.id, this.expenseType, this.amount);

  Expense.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    expenseType = map['expenseType'];
    amount = map['amount'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnExpenseType: expenseType,
      DatabaseHelper.columnAmount: amount,
    };
  }
}
