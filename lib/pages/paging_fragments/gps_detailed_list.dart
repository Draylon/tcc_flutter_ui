
import 'package:carousel_slider/carousel_slider.dart';
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
      appBar: AppBar(
        title: const Text("Nearby Places",style: TextStyle(
          letterSpacing: 3
        )),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: true,
      ),
      body: CarouselSlider.builder(
        options: CarouselOptions(
          //height: 600
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          aspectRatio: 9/16,
          viewportFraction: 0.8,
          initialPage: 0,
          reverse: true,
        ),
        itemCount: 5,
        itemBuilder: (BuildContext context,int itemIndex,int pageviewIndex)=> Card(
          child: Container(
            width: double.maxFinite,
            child: Text("Filler\n\nfunção nova: places_by_geocoordinate"),
          ),
          elevation: 5,
          color: Colors.indigo,
        ),
      ),
    );
  }
}