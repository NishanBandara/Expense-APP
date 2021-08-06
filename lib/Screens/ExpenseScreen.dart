import 'dart:io';
import 'package:Ceylonlinux_Expense_APP/model/WebServices.dart';
import 'package:Ceylonlinux_Expense_APP/Database/DB_Helper.dart';
import 'package:Ceylonlinux_Expense_APP/Database/Expenses.dart';
import 'package:Ceylonlinux_Expense_APP/Widgets/Color.dart';
import 'package:Ceylonlinux_Expense_APP/Widgets/CustomAppbar.dart';
import 'package:Ceylonlinux_Expense_APP/Widgets/ExoenseType.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpenseScreen extends StatefulWidget {
  final String titleName;
  ExpenseScreen({this.titleName});

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  double expenseWidth = 145.0;
  double rowHeight = 40.0;
  double amountWidth = 80.0;
  double imageWidth = 50.0;

  int expenseIndex = 1;
  final dbHelper = DatabaseHelper.instance;

  List<Expense> expenses = [];
  List<Expense> expensesTypes = [];

// DATE AND TIME
  DateTime now = DateTime.now();
  DateTime selectedDate;

  TextEditingController dateContoller = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  TextEditingController expenseType = TextEditingController();
  TextEditingController expenseAmount = TextEditingController();

  // Image Picker
  File imgFile;

  final _picker = ImagePicker();

  Future getTravelImag() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    final img = File(pickedFile.path);

    setState(() {
      imgFile = img;
    });
  }

  Widget bigCircle = new Container(
    width: 35.0,
    height: 35.0,
    decoration: new BoxDecoration(
      color: Colors.black,
      shape: BoxShape.circle,
    ),
    child: Icon(
      MdiIcons.cameraPlus,
      color: Colors.white,
      size: 20,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar("Expenses"),
        drawer: Drawer(),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Date : "),
                      dateContoller.text == null
                          ? Container(
                              width: 165,
                              child: TextFormField(
                                enabled: false,
                                controller: dateContoller,
                                onTap: () {
                                  _selectDate(context);
                                },
                                style: TextStyle(
                                    fontSize: 13,
                                    decorationColor: Colors.white),
                                keyboardType: TextInputType.datetime,
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          : Text(DateFormat.yMMMMEEEEd().format(now)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(DateFormat.jm().format(now)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Back-Date : "),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectDate(context);
                          });
                        },
                        child: Icon(
                          MdiIcons.calendarMonth,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15, 0, 10),
                  child: Text(
                    "ExpensesTypes",
                    style: TextStyle(
                        color: CustomColor().secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Column(children: [
                  // Headind Row
                  Row(
                    children: [
                      Container(
                        width: 145,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("EXPENSE"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: Container(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text("AMOUNT"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: Container(
                          width: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("IMAGE"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),

                Expanded(
                  child: ListView.builder(
                      itemCount: expenseIndex,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpenseType();
                      }),
                ),

                // Tasks(),
                // Tasks(),

                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RaisedButton(
                      padding: EdgeInsets.only(left: 60, right: 60),
                      highlightElevation: 30.5,
                      onPressed: () async {
                        setState(() {
                          expenseIndex = expenseIndex + 1;
                        });

                        await showDialog(
                          context: context,
                          builder: (context) => new AlertDialog(
                            title: new Text('HTTP request response'),
                            content: HTTPRequest(),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();

                                  String expense_Type = expenseType.text;
                                  int expense_Amount =
                                      int.parse(expenseAmount.text);
                                  _insert(expense_Type, expense_Amount);
                                },
                                child: new Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: CustomColor().primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _insert(expense_Type, expense_Amount) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnExpenseType: expense_Type,
      DatabaseHelper.columnAmount: expense_Amount
    };
    Expense expense = Expense.fromMap(row);
    final id = await dbHelper.insert(expense);
    _showMessageInScaffold('inserted row id: $id');
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate != null ? selectedDate : DateTime.now(),
        firstDate: DateTime(1800),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                    primary: CustomColor().primaryColor,
                    onPrimary: Colors.white,
                    surface: CustomColor().primaryColor,
                    onSurface: CustomColor().secondaryColor),
                dialogBackgroundColor: Colors.white),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      dateContoller
        ..text = DateFormat.yMMMMEEEEd().format(selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateContoller.text.length,
            // offset: txtDate.toString().length,
            affinity: TextAffinity.upstream));
    }
  }

  jsonDecode(String body) {}
}
