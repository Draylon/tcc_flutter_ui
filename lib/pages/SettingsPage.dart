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
          title: Text("Settings",
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
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
                        child: Text("Precisão da localização:",style: TextStyle(
                          fontSize: 20,
                        ),),
                      ),
                    ),
                    ToggleButtons(
                      color: Theme.of(context).primaryColorDark,
                      renderBorder: false,
                      isSelected: _isSelected,
                      onPressed: (int index) {
                        setState(() {
                          _isSelected[index] = !_isSelected[index];
                        });
                      },
                      children: <Widget>[
                        Column(
                          children:const [
                            Icon(Icons.signal_cellular_4_bar),
                            Text("Cellular"),
                          ]
                        ),
                        Column(
                          children:const [
                            Icon(Icons.gps_fixed),
                            Text("GPS"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      child:Container(child: Text("Tipo de card\nna tela inicial:",textAlign: TextAlign.center,style: TextStyle(
                        fontSize: 20,
                      ),),),
                    ),
                    Expanded(
                      child: Padding(

                        padding: EdgeInsets.fromLTRB(20,0,0,0),
                        child: DropdownButton(

                          onChanged: (int? value) {
                            setState(() {
                              _dropdownIsSelected=value;
                            });
                          },
                          value: _dropdownIsSelected,
                          iconEnabledColor: Colors.green,
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 15,
                          ),
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 0,child: Text("Wide cards",style: TextStyle(fontSize: 15)),),
                            DropdownMenuItem(value: 1,child: Text("Square cards",style: TextStyle(fontSize: 15)),),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Apagar Cache?"),

                ),
              ),
            ),
          ],
        ),
      );
  }
}