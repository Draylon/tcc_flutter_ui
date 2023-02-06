
import 'package:flutter/material.dart';
import 'package:ui/pages/paging_fragments/map.dart';

class DBDataListFragment extends StatefulWidget {
  DBDataListFragment({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _DBDataListFragState createState() => _DBDataListFragState();
}

class _DBDataListFragState extends State<DBDataListFragment> with AutomaticKeepAliveClientMixin<DBDataListFragment> {
  @override
  bool get wantKeepAlive => true;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //AppDatabase().openDb().whenComplete(loaded);
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return !_isLoading ? _build_screen() : Center(
        child: CircularProgressIndicator());
  }

  _build_screen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latest metrics",style: TextStyle(
            letterSpacing: 3
        )),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            color: Colors.blueGrey,
            child: Container(
              alignment: Alignment.center,
              child: Text("Últimas métricas sobre algum dado da região"),
              height: 220,
            ),
            elevation: 5,
          ),
          Card(
            color: Colors.blueGrey,
            child: Container(
              child: Text("Fazer algo informativo em formato de card"),
              height: 220,
              alignment: Alignment.center,
            ),
            elevation: 5,
          )
        ],
      ),
    );
  }

}