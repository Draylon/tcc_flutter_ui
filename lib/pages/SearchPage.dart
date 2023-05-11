import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../api/call.dart';

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

    _textEditingController.text = "Joinville";
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      print("focus change");
      print(_textEditingController.value.text);
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

  final TextEditingController _textEditingController = TextEditingController();
  late StreamSubscription<bool> keyboardSubscription;
  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String,String>> _search_data = [
    {
      "title": "Cidade",
      "desc": "Definir como local atual"
    },{
      "title": "Tipos de dados em Joinville",
      "desc": "co2, pH"
    },{
      "title": "Últimas médias de Joinville",
      "desc": "porcentagens/estatísticas em diversos lugares da cidade, estes lugares foram consultados recentemente por outros"
    }
  ];

  int searchLoaded=0;
  String searchFailureMessage="Loading Failed!\nPlease refresh";
  _performSearch() async {
    if(_textEditingController.value.text == "") return;
    Map<String,dynamic> searchDataJson={};
    Map<String,dynamic>? apiRequestsQuery;
    apiRequestsQuery={
      'search_topic': _textEditingController.value.text,
    };

    print(_textEditingController.value.text);
    await ApiRequests.call("/api/v2/data/searchengine",apiRequestsQuery).then((apiResponse) {
      print("Request completed");
      if (apiResponse.statusCode == 200) {
        try{
          searchDataJson = json.decode(apiResponse.body);
          setState(() {
            searchLoaded=2;
            searchDataJson.forEach((key, value)=>_search_data.add({key:value}));
            //azure_json.map((e) => ExibitCard.fromJson(e)).toList();
          });
        }on Exception catch(e){
          print(e);
          setState((){searchFailureMessage="API returned invalid data";searchLoaded=1;});
        }
      }else{
        setState((){searchFailureMessage="API returned invalid code";searchLoaded=1;});
      }
      return true;
    },onError:(e) {
      print("Error on API fetch:");print(e);
      setState((){searchFailureMessage="Serviço com problemas";searchLoaded=1;});
      //return Future.error("Api Error");
      return false;
    });
  }

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
              padding: EdgeInsets.fromLTRB(25, 0, 25,0),
              child: ElevatedButton(
                  onPressed: () {

                  },
                  onFocusChange:(e)=>{
                    if(!e) _performSearch()
                  },
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _textEditingController,
                    focusNode: _searchFocusNode,
                    style: TextStyle(
                      fontSize: 22,
                    ),
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

          Expanded(
              child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _search_data.length,
            itemBuilder: (BuildContext context,int index)=>Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Text(_search_data[index]["title"] ?? "No data",style: TextStyle(
                      fontSize: 25,
                    ),),
                    Text(_search_data[index]["desc"] ?? "Nothing was found, yet this card remains",style: TextStyle(
                      fontSize: 18,
                    ),),
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