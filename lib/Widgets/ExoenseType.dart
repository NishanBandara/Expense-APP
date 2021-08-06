import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Color.dart';

class ExpenseType extends StatefulWidget {
  @override
  _ExpenseTypeState createState() => _ExpenseTypeState();
}

class _ExpenseTypeState extends State<ExpenseType> {
  double expenseWidth = 145.0;
  double rowHeight = 40.0;
  double amountWidth = 80.0;
  double imageWidth = 50.0;

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

  @override
  Widget build(BuildContext context) {
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

    return Column(
      children: [
        // Headind Row

        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: expenseWidth,
                  height: rowHeight,
                  decoration: BoxDecoration(
                      border: Border.all(color: CustomColor().primaryColor)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      child: Center(
                        child: TextFormField(
                          controller: expenseType,
                          style: TextStyle(
                              fontSize: 13, decorationColor: Colors.white),
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Expense",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Container(
                    width: amountWidth,
                    height: rowHeight,
                    decoration: BoxDecoration(
                        border: Border.all(color: CustomColor().primaryColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        child: Center(
                          child: TextFormField(
                            controller: expenseAmount,
                            style: TextStyle(
                                fontSize: 13, decorationColor: Colors.white),
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "0.00",
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Container(
                    width: imageWidth,
                    height: rowHeight,
                    decoration: BoxDecoration(
                        border: Border.all(color: CustomColor().primaryColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(
                        child: imgFile == null
                            ? Text("N/A")
                            : ClipRRect(
                                child: Image.file(imgFile),
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: InkWell(
                    child: Container(
                      height: rowHeight,
                      child: bigCircle,
                    ),
                    onTap: () {
                      getTravelImag();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
