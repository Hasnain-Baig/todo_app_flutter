import 'package:flutter/material.dart';

class ToDoApp extends StatefulWidget {
  @override
  _ToDoAppState createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  List<dynamic> lst = [];
  var item = "";
  TextEditingController editText = TextEditingController();

  addItem(var item) {
    Navigator.of(context)
        .pop(); //for after clicking move to  homescreen immediately
    if (item != "") {
      lst.add(item);
    } else {
      emptyInputDialogBox();
      // addItemDialogBox();
    }
    setState(() {});
  }

  editItem(var index, var item) {
    Navigator.of(context)
        .pop(); //for after clicking move to  homescreen immediately
    if (item != "") {
      lst.replaceRange(index, index + 1, {item});
    } else {
      emptyInputDialogBox();
    }
    setState(() {});
  }

  deleteItem(var index) {
    lst.removeAt(index);
    setState(() {});
  }

  addItemDialogBox() {
    item = "";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
                width: MediaQuery.of(context).size.width * 1,
                padding: EdgeInsets.all(10),
                color: Colors.orange,
                child: Center(
                    child: Text(
                  "Add Item",
                  style: TextStyle(color: Colors.white),
                ))),
            content: TextField(
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              autofocus: true,
              onChanged: (value) {
                item = value;
              },
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange)),
                onPressed: () => {addItem(item)},
                child: Text("Add"),
              )
            ],
          );
        });
  }

  editItemDialogBox(var index) {
    editText.text = item;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.all(10),
              color: Colors.orange,
              child: Center(
                  child: Text(
                "Edit Item",
                style: TextStyle(color: Colors.white),
              )),
            ),
            content: TextField(
              controller: editText,
              cursorColor: Colors.orange,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              // style:StrutStyle() ,
              autofocus: true,
              onChanged: (value) {
                item = value;
              },
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange)),
                onPressed: () => {editItem(index, item)},
                child: Text(
                  "Update",
                ),
              )
            ],
          );
        });
  }

  emptyInputDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            width: MediaQuery.of(context).size.width * .3,
            padding: EdgeInsets.all(8),
            color: Colors.orange,
            child: Center(
                child: Text(
              "ERROR",
              style: TextStyle(color: Colors.white),
            )),
          ),
          content: Container(
              width: MediaQuery.of(context).size.width * .3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("No Input Found!\nKindly fill the text field"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // addItemDialogBox();
                    },
                    child: Text("OK"),
                  )
                ],
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do App"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: lst.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 245, 238),
                border: Border(
                  bottom: BorderSide(width: 3.0, color: Colors.white),
                )),
            child: ListTile(
              title: Text(
                "${lst[index]}",
                style: TextStyle(color: Colors.black),
              ),
              trailing: Container(
                width: 50,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () => {editItemDialogBox(index)},
                        child: Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 243, 158, 31),
                        )),
                    GestureDetector(
                        onTap: () => {deleteItem(index)},
                        child: Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 243, 158, 31),
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () => {addItemDialogBox()},
          child: Icon(Icons.add)),
    );
  }
}
