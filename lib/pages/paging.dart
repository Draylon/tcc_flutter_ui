

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/pages/paging_fragments/data_detailed_list.dart';
import 'package:ui/pages/paging_fragments/gps_detailed_list.dart';
import 'package:ui/pages/paging_fragments/map.dart';
import 'package:path/path.dart' as pathing;
import 'package:provider/provider.dart';

import '../shared/state/DownloadProvider.dart';
import '../shared/state/GeneralProvider.dart';

class PageMap extends StatefulWidget {
  PageMap({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _PageMapState createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> {

  @override
  void initState() {
    super.initState();

    //AppDatabase().openDb().whenComplete(loaded);
  }

  @override
  void dispose(){
    _pager_ctrl.dispose();
    super.dispose();
  }

  //final _sideCtrl = PageController();
  final _pager_ctrl = PageController(
    initialPage: 0,
    //viewportFraction: 1.1
  );
  int _pager_current = 0;

  @override
  Widget build(BuildContext context) => _buildPager();

  _pageMapTitle(BuildContext parent_ctx) => AppBar(
      centerTitle: true,
      title: TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Pesquisar Locais"
        ),
      ),
      toolbarOpacity: 0.4,
      backgroundColor: Theme.of(context).accentColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
          topLeft: Radius.circular(-30),
          topRight: Radius.circular(-30),
        ),
      ),
      /*leading: IconButton(
        icon: Icon(Icons.list),
        onPressed: () => Scaffold.of(parent_ctx).openDrawer(),
      ),*/
    );
    /*return Expanded(
      child: Container(
        margin: EdgeInsets.all(25),
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [BoxShadow(color: Theme.of(context).cardColor,spreadRadius: 3,blurRadius: 5),]
        ),
        child: const Text("Mapa",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 36,
            decoration: TextDecoration.none,
            color: Colors.white,
          ),
        ),
      ),
    );*/


  _buildPager(){
    return PageView(
      onPageChanged: (i)=>{
        _pager_current=i,
      },
      physics: NeverScrollableScrollPhysics(),
      controller: _pager_ctrl,
      scrollDirection: Axis.vertical,
      clipBehavior: Clip.antiAlias,
      children: [
        _main_mapPage(context),
        _sideDataPages()
      ],
    );

  }

  _main_mapPage(BuildContext pager_context){
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapFragment(title: "yikes",),
          Container(
            margin: EdgeInsets.fromLTRB(12,0,12,12),
            //padding: EdgeInsets.fromLTRB(12,12,12,12),
            height: 70,
            child: _pageMapTitle(pager_context),
          ),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 5,
          itemBuilder: (context, index) {
            if(index==0){
              return DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.6,1],
                    colors:[
                      Theme.of(pager_context).buttonColor,
                      Color.fromRGBO(30,30, 30,0),
                    ]
                  ),
                ),
                padding: EdgeInsets.fromLTRB(0,30,0,0),
                child: Column(
                    children: [
                      Text("Seletor de dados à mostrar"),
                      Text("Seletor de tipo de mapa")
                    ]
                ),
              );
            }else{
              return ListTile(
                subtitle: Text("descrição do parametro"),
                //trailing: Icon(Icons.question_mark,size: 15,),
                //leading: Checkbox(onChanged: (bool? value) {}, value: false,),
                style: ListTileStyle.list,
                selected: index%2==0?true:false,
                enabled: true,

                title: Text("Parâmetro de medida $index"),
                onTap: () {

                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  //Navigator.pop(context);
                },
              );
            }
          },
        ),
      ),
      //appBar:
      //drawerScrimColor: Colors.green, // background

      /*appBar: AppBar(
        title: _pageMapTitle(),

      ),*/
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{
          _pager_ctrl.animateToPage(1, duration: Duration(milliseconds: 600), curve: Curves.easeOutCubic),
          _sidepager_delay=4
        },
        child: const Icon(Icons.keyboard_arrow_up),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Theme.of(context).bottomAppBarColor,
        child: IconTheme(
            data: const IconThemeData(
              color: Colors.white,
              size: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.cloud_queue_sharp,), // não sei oq por aqui kkkk
                  Icon(Icons.settings,),
                ],
              ),
            )
        ),
      ),
    );
  }

  int _sidepager_delay = 4;
  _sideDataPages(){
    //ValueNotifier Listener Builder pode resolver o problema, mas dá rebuild sepá
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        if(_sidepager_delay <= 0){
          _pager_ctrl.animateToPage(0, duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic);
        }else{
          _sidepager_delay--;
        }
        return true;
      },
      child: PageView(
        //controller: _sideCtrl,
        scrollBehavior: const ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.antiAlias,
        children: [
          CardedListFragment(title: "yikes2",),
          DBDataListFragment(title: "yikes3",),
        ],
      ),
    );
  }

  /*
  _buildPager2(){
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        bool portrait = constraints.maxHeight > constraints.maxWidth?true:false;
        return Stack(
          children: [
            MapFragment(title: "yikes",),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: portrait? [
                _pageMapTitle(),
                _switchPages(),
                ] : [_switchPages()],
            ),
          ],
        );
      },
    );


    */
/*return PageView.builder(
      //physics: const ClampingScrollPhysics(),
      controller: _pager_ctrl,
      itemCount: _pages.length,
      itemBuilder: (BuildContext context, int index) {
        return FractionallySizedBox(
          widthFactor: 1 / _pager_ctrl.viewportFraction,
          child: _pages[index],
        );
      },

      */
/**//*onPageChanged: (index)=>{
        _pager_current=index,
        print(_pager_current),
        if(_pager_current==0){_pager_physics=ScrollPhysics()}else{_pager_physics=NeverScrollableScrollPhysics()},
      },*/
/**/
/*
    );

    PageView(
          onPageChanged: (i)=>{
            _pager_current=i
          },
          controller: _pager_ctrl,
          scrollDirection: Axis.horizontal,
          children: _pages,
          clipBehavior: Clip.antiAlias,

        ),*//*


  }
*/
}