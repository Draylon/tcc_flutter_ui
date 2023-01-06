
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
      body: Container(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        height: 220,
        width: double.maxFinite,
        child: Card(
          color: Colors.deepOrangeAccent,
        elevation: 5,
        ),
      ),
    );
  }

}