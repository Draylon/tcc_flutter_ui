import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  @override
  Widget build(BuildContext context) => _buildPage();

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      print("focus change");
      setState(() {
        if(!visible) _searchFocusNode.unfocus();
      });
    });

    //AppDatabase().openDb().whenComplete(loaded);
  }

  @override
  void dispose(){
    keyboardSubscription.cancel();
    super.dispose();
  }

  late StreamSubscription<bool> keyboardSubscription;
  final FocusNode _searchFocusNode = FocusNode();


  _buildPage(){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search",style: TextStyle(
            letterSpacing: 3
        )),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: ElevatedButton(
                  onPressed: () {

                  },
                  onFocusChange:(e)=>{
                    print(e)
                  },
                  child: TextField(
                    focusNode: _searchFocusNode,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: false,
                        suffixIcon: Icon(Icons.search),
                        hintText: 'Buscar locais'
                    ),
                    textAlign: TextAlign.center,

                  ),

                ),
              )
            ),
          const Text("Inicial da localização pode ser por locais próximos"),
          Expanded(
              child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: 5,
            itemBuilder: (BuildContext context,int index)=>Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Text("Localização resultante da pesquisa - ${index}"),

                  ],
                ),
              ),
            ),
          )),
        ],
      )
      ),
    );
  }
}