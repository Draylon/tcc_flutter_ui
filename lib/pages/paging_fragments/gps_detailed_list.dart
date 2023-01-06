
import 'package:flutter/material.dart';
import 'package:ui/pages/paging_fragments/map.dart';

class CardedListFragment extends StatefulWidget {
  CardedListFragment({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _CardedListFragState createState() => _CardedListFragState();
}

class _CardedListFragState extends State<CardedListFragment> with AutomaticKeepAliveClientMixin<CardedListFragment> {
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
      body: Container(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        height: 220,
        width: double.maxFinite,
        child: ListView(
          children:[
            Card(
              elevation: 5,
              color: Colors.indigo,
            ),Card(
              elevation: 5,
              color: Colors.indigo,
            ),Card(
              elevation: 5,
              color: Colors.indigo,
            ),Card(
              elevation: 5,
              color: Colors.indigo,
            ),Card(
              elevation: 5,
              color: Colors.indigo,
            ),Card(
              elevation: 5,
              color: Colors.indigo,
            ),Card(
              elevation: 5,
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }

}