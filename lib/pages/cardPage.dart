

import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ui/api/call.dart';
import 'package:ui/pages/SearchPage.dart';
import 'package:ui/pages/map_paging.dart';
import 'package:ui/shared/components/exibit_card.dart';
import 'package:ui/pages/SettingsPage.dart';
import 'package:ui/shared/components/LoadingIndicator.dart';
import 'package:ui/shared/control/LocationHandler.dart';
import 'package:location/location.dart';

import '../shared/components/ExibitCardLoader.dart';
import '../shared/components/LoadingFailed.dart';

class CardPage extends StatefulWidget {
  CardPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) => _buildPage();

  @override
  void initState() {
    super.initState();

    _fetch_card_data();
    //AppDatabase().openDb().whenComplete(loaded);
  }

  @override
  void dispose(){
    super.dispose();
  }

  Map whois_json={};
  Map geocode_json={};
  LocationData? _curr_location;
  String uiCityName="Local não definido";
  bool locationAvaliable=false;

  _fetch_location_data({bool precision=false}) async{

    String whois_params;

    // check permission
    print("check permission");

    if(!precision) {
      await LocationHandler.checkGPSPermission().then((value) {
        setState(() {
          locationAvaliable = value == PermissionStatus.granted;
        });
      }, onError: (e) {
        print("Error on GPS permission");
        print(e);
      });
    }else {
      await LocationHandler.requestGPSPrecision().then((value) {
        setState(() {
          locationAvaliable = value == PermissionStatus.granted;
        });
      });
    }

    //retrieve coordinates
    //LocationData? curr_location;
    if(locationAvaliable){
      print("retrieve coordinates");
      await LocationHandler.requestCurrentGPS(prompt: false).then((value) {
        _curr_location=value;
      },onError: (e){
        locationAvaliable=false;
        print("Error on GPS Location retrieval");print(e);
      });
      setState(() {
        _curr_location==null?locationAvaliable=false:null;
      });

    }


    //retrieve geocoding
    //_last_location?.latitude!=curr_location?.latitude &&
    //_last_location?.longitude!=curr_location?.longitude
    if(locationAvaliable && geocode_json.isEmpty){
      print("retrieve geocoding");
      await ApiRequests.call('/api/v1/loc/${_curr_location?.latitude}/${_curr_location?.longitude}').then((api_response){
        if (api_response.statusCode == 200) {
          String api_response_body = api_response.body.replaceAll('null',"\"null\"");

          try{
            geocode_json = json.decode(api_response_body);
          }on Exception catch(e){
            print("internal error:");
            print(e);
            setState(() {
              locationAvaliable=false;
            });
          }
          print("Geocoding completed");
        }else{
          print("request invalid: "+api_response.statusCode.toString());
          setState(() {
            locationAvaliable=false;
          });
        }
        //return true;
      },onError: (e){
        print("major error:");
        print(e);
        setState(() {
          locationAvaliable=false;
        });
      });
    }else{
      print("skipping geocoding");
    }
    //==============================

    if(locationAvaliable){
      whois_params='ip,connection,success,type';
    }else{
      whois_params='ip,connection,success,type,country,city,latitude,longitude';
    }

    if(whois_json.isEmpty) {
      await LocationHandler.cached_isp_data(whois_params).then((whois_response) {
        whois_json = whois_response;
        return true;
      }, onError: (e) {
        print("Error on whois fetch:");
        print(e);
        //setState((){failureMessage="Error on whois fetch";menuLoaded=1;});
        //return false;
      });
    }else{
      print("skipping whois phase");
    }

    if(locationAvaliable) setState(() {uiCityName=geocode_json['county'];});
    else setState(() {uiCityName=whois_json['city'];});

  }


  _fetch_card_data() async{
    await _fetch_location_data();
    Map<String,dynamic> azure_json={};
    if(whois_json.isEmpty && !locationAvaliable){
      setState((){failureMessage="Problema no apontamento da região";menuLoaded=1;});
      return;
    }
    print("Obtendo cards");
    Map<String,dynamic>? api_requests_query;
    if(locationAvaliable){
      print("Precise locations avaliable");
      api_requests_query={
        'ip': whois_json['ip'],
        'country': geocode_json['country'],
        'city': geocode_json['county'],
        'street_name': geocode_json['name'],
        'region': geocode_json['region'],
        'latitude': _curr_location?.latitude.toString(),
        'longitude': _curr_location?.longitude.toString(),
        'connection': whois_json['connection'].toString(),
      };

    }else{
      print("Location unavaliable, Sticking to whois");
      api_requests_query={
        'ip': whois_json['ip'],
        'country': whois_json['country'],
        'city': whois_json['city'],
        'latitude': whois_json['latitude'].toString(),
        'longitude': whois_json['longitude'].toString(),
        'connection': whois_json['connection'].toString(),
      };

    }

    await ApiRequests.call("/api/v2/ui_data/main_menu",api_requests_query).then((api_response) {
      print("Request completed");
      if (api_response.statusCode == 200) {
        try{
          azure_json = json.decode(api_response.body);
          avaliableCards.initializer(azure_json,context);
          setState(() {
            menuLoaded=2;
            //azure_json.map((e) => ExibitCard.fromJson(e)).toList();
          });
        }on Exception catch(e){
          print(e);
          setState((){failureMessage="API returned invalid data";menuLoaded=1;});
        }
      }else{
        setState((){failureMessage="API returned invalid code";menuLoaded=1;});
      }
      return true;
    },onError:(e) {
      print("Error on API fetch:");print(e);
      setState((){failureMessage="Serviço com problemas";menuLoaded=1;});
      //return Future.error("Api Error");
      return false;
    });
  }

  int menuLoaded=0;
  String failureMessage="Loading Failed!\nPlease refresh";
  ExibitCardLoader avaliableCards = ExibitCardLoader();
  //List<ExibitCard>avaliableCardsContainer = [];

  //()=>ScaffoldMessenger.of(context).showSnackBar(markerClicked),
  final settingsMarker = const SnackBar(
    content: Text('Settings em breve'),
    duration: Duration(seconds:3),
  );
  final buscaMarker = const SnackBar(
    content: Text('S/ Busca por enquanto\nProblema no mongo'),
    duration: Duration(seconds:4),
  );


  _buildPage(){
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx,isScrolled)=>[
          SliverAppBar(
            title: Container(
              padding: const EdgeInsets.fromLTRB(15, 0,15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text("Titulo?",style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),),
                  ),
                  FittedBox(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      onPressed: ()=> _fetch_location_data(precision: true),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black45,
                                  style: BorderStyle.solid,
                                  width: 2
                              )
                          ),
                        ),
                        child:Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10,0,10,0),
                              child: locationAvaliable?const Icon(Icons.near_me):const Icon(Icons.wifi_tethering),
                            ),
                            Text(uiCityName,style: TextStyle(
                              fontSize: 20
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.blueGrey,
          )
        ],
        body: RefreshIndicator(
        displacement: 80,
        onRefresh:(){return _fetch_card_data();},
        child:ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30,0,30,0),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Como funciona?",style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    wordSpacing: 3,
                  ),),
                  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vel mauris velit. Fusce non ullamcorper nibh. Nunc sit amet lacus pharetra, volutpat leo et, rhoncus ipsum. Nunc nisl nisi, posuere sed lorem eu, pellentesque finibus tellus. Nulla quis auctor odio. Nam commodo fermentum tortor nec auctor. Fusce molestie sagittis libero eget fringilla. Aenean ut tristique ligula. In sit amet velit sagittis, iaculis urna sed, placerat ante. Proin sollicitudin, dui a porta scelerisque, lorem nunc bibendum ligula, quis luctus sapien libero ut quam. Duis et enim ante. Praesent pharetra metus nec arcu tincidunt, ac iaculis nunc scelerisque. Maecenas porttitor ipsum eget tincidunt mattis. Vestibulum egestas rhoncus ex, at aliquam nunc fermentum vitae.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w200
                    ),
                  ),
                ],
              ),
            ),
            menuLoaded==0?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.square(
                    child: const LoadingIndicator(),
                    dimension: 150,
                  )
                ],
              )
            :menuLoaded==1?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  child: LoadingFailed(message: failureMessage,),
                  dimension: 150,
                )
              ],
            ):
            MasonryGridView.count(
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,

                physics: const NeverScrollableScrollPhysics(),
                itemCount: avaliableCards.length,
                itemBuilder: (ctx,i)=>avaliableCards.item(i)
            ),
          ],
        ),
        ),
      ),

      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:FloatingActionButton(
        //onPressed: ()=>ScaffoldMessenger.of(context).showSnackBar(settingsMarker), // liberar logo settings <=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=
        onPressed: () async => {
          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => SearchPage()))
        },
        child: const Icon(Icons.search),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Theme.of(context).bottomAppBarColor,
        child: IconTheme(
            data: const IconThemeData(
              color: Colors.white,
              size: 26,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                alignment: Alignment.topLeft,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // não sei oq por aqui kkkk
                      IconButton(onPressed: () async =>{
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext c) {
                              return SettingsPage();
                            }))
                      }, icon: const Icon(Icons.settings,),),
                      /*IconButton(onPressed: (){
                          // add device to network?
                      }, icon: const Icon(Icons.add,),),*/
                      IconButton(onPressed: () async => {
                          // interactive map page
                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => PageMap(title: "Mapa interativo")))
                      }, icon: const Icon(Icons.map_outlined,),),
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );

  }



  _buildPageCards(int i){
    //DateTime d = DateTime.parse(_imagesController.images[i].data!);
    return Container(
      margin: EdgeInsets.fromLTRB(0,5, 0, 5),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black54,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: () async {
            /*final val = await Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext c) {
                  return new ViewImage(_imagesController.images[i].id!);
                }));
            if(val != null && val == true) loaded();*/
          },
          child: Ink(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("text 1"),
                      Text("text 2"),
                      Text("text 3"),
                      Text("text 4"),
                      /*Text(_imagesController.images[i].titulo!),
                      Text("${d.day}/${d.month}/${d.year} ${d.hour > 12 ? d.hour - 12 : d.hour} : ${d.minute} ${d.hour > 12 ? 'PM' : 'AM'}"),
                      Text(_imagesController.images[i].lat!.toString()),
                      Text(_imagesController.images[i].long!.toString())*/
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text("Image here"),//Image.memory(base64.decode(_imagesController.images[i].img!)),
                    //Image(image: NetworkImage("https://i.pinimg.com/originals/41/71/b1/4171b1b35e0c25ed4871c1109372ea4c.gif"),),
                    margin: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }


}