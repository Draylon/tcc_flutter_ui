import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key? key}) : super(key: key);
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage>{
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
          title: Text("Help",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Consultar informação sobre condições do ar, agua, etc.",style: TextStyle(
                      fontSize: 25,
                    ),),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("a tela principal mostra quais tópicos estão disponíveis na região selecionada.",style: TextStyle(
                        fontSize: 20,
                      ),),
                    ),Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("O sistema de busca é capaz de:\nidentificar um local por nome;\nbuscar um tipo de informação",style: TextStyle(
                        fontSize: 20,
                      ),),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Redefinir locais",style: TextStyle(
                      fontSize: 25,
                    ),),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("o app define a localização automáticamente através de ISP",style: TextStyle(
                        fontSize: 20,
                      ),),
                    ),Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("a localização pode ser melhorada utilizando GPS",style: TextStyle(
                        fontSize: 20,
                      ),),
                    ),Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("Adicionalmente, a localização pode ser definida manualmente, assim como é possível buscar por uma localização",style: TextStyle(
                        fontSize: 20,
                      ),),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }
}