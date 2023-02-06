import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) => _buildPage();

  @override
  void initState() {
    super.initState();
    //AppDatabase().openDb().whenComplete(loaded);
  }

  @override
  void dispose(){
    super.dispose();
  }


  List<bool> _isSelected=[false,false];
  int? _dropdownIsSelected=0;

  _buildPage(){
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings",style: TextStyle(
              letterSpacing: 3
          )),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 60,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text("Localização",style: TextStyle(
                          fontSize: 20,
                        ),),
                      ),
                    ),
                    ToggleButtons(
                      renderBorder: false,
                      isSelected: _isSelected,
                      onPressed: (int index) {
                        setState(() {
                          _isSelected[index] = !_isSelected[index];
                        });
                      },
                      children: const <Widget>[
                        Icon(Icons.signal_cellular_4_bar),
                        Icon(Icons.gps_fixed),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: DropdownButton(
                  onChanged: (int? value) {
                    setState(() {
                      _dropdownIsSelected=value;
                    });
                  },
                  value: _dropdownIsSelected,
                  iconEnabledColor: Colors.green,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 0,child: Text("Item 1",style: TextStyle(fontSize: 15)),),
                    DropdownMenuItem(value: 1,child: Text("Item 2",style: TextStyle(fontSize: 15)),),
                    DropdownMenuItem(value: 2,child: Text("Item 3",style: TextStyle(fontSize: 15)),),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: () {  },
                  child: Text("Botão elevado"),

                ),
              ),
            ),
          ],
        ),
      );
  }
}