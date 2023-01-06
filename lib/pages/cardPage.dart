

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/api/call.dart';
import 'package:ui/db/models/exibit_card.dart';
import 'package:ui/pages/paging_fragments/data_detailed_list.dart';
import 'package:ui/pages/paging_fragments/gps_detailed_list.dart';
import 'package:ui/pages/paging_fragments/map.dart';
import 'package:path/path.dart' as pathing;
import 'package:provider/provider.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:ui/shared/components/LoadingIndicator.dart';

import '../shared/components/LoadingFailed.dart';
import '../shared/state/DownloadProvider.dart';
import '../shared/state/GeneralProvider.dart';

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
  late Iterable azure_json;
  _fetch_card_data() async {
      try{
        setState(() {
          menuLoaded=0;
        });
        if(whois_json.isEmpty) {
          await http.get(
            Uri.https("ipwho.is","/?fields=ip,connection,success,type,country,city,latitude,longitude")
        ).then((whois_response) {
            if(whois_response.statusCode==200){
                //ip,success,type,country,city,latitude,longitude
                whois_json= json.decode(whois_response.body);
                /*http.get(Uri.https(
                          "tcc-api-mon.azurewebsites.net","/api/ui_data/main_menu",
                    {
                        'ip': whois_json['ip'],
                        'country': whois_json['country'],
                        'city': whois_json['city'],
                        'latitude': whois_json['latitude'],
                        'longitude': whois_json['longitude']
                    }
                )).then((azure_response) => {
                  menuLoaded=true,
                  if (azure_response.statusCode == 200) {
                    setState((){
                      azure_json = json.decode(azure_response.body);
                      avaliableCards = azure_json.map((e) => ExibitCard.fromJson(e)).toList();
                    })
                  }
                })*/
            }else{
              setState((){
                menuLoaded=1;
              });
            }
            return true;
        },onError: (e) {
          print("Error on whois fetch:");
          print(e);
          setState((){
            failureMessage="Error on whois fetch";
            menuLoaded=1;
          });
          return false;
        });
        }

        if(whois_json.isEmpty){
          setState((){
            failureMessage="Problema no apontamento da região";
            menuLoaded=1;
          });
        }

        await ApiRequests.call("/api/ui_data/main_menu",{
          'ip': whois_json['ip'],
          'country': whois_json['country'],
          'city': whois_json['city'],
          'latitude': whois_json['latitude'],
          'longitude': whois_json['longitude'],
          'connection': whois_json['connection'],
        }).then((api_response) {
          print("Request completed");
          if (api_response.statusCode == 200) {
            try{
              azure_json = json.decode(api_response.body);
              setState((){
                menuLoaded=2;
                avaliableCards = azure_json.map((e) => ExibitCard.fromJson(e)).toList();
              });
            }catch(e){
              setState((){
                failureMessage="API returned invalid data";
                menuLoaded=1;
              });
            }
          }else{
            setState((){
              failureMessage="API returned invalid code";
              menuLoaded=1;
            });
          }
          return true;
        },onError:(e) {
          print("Error on API fetch:");
          print(e);
          setState((){
            failureMessage="Serviço com problemas";
            menuLoaded=1;
          });
          //return Future.error("Api Error");
          return false;
        }
        );
        } catch(e){
          print("error on req:");
          print(e.toString());
          print("----");
        }

        //final ipv4 = await Ipify.ipv4();
        //final geolocator_data = await http.get(Uri.http("geoplugin.net","/json.gp?ip=${ipv4}"));


        //inject default cards?
  }

  int menuLoaded=0;
  String failureMessage="Loading Failed!\nPlease refresh";
  List<ExibitCard> avaliableCards = [];


  _buildPage(){
    return Scaffold(
      body:
        menuLoaded==0?
          const LoadingIndicator()
        :menuLoaded==1?
          LoadingFailed(message: failureMessage,refreshOption: () {
            return _fetch_card_data();
          },)
        :ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: avaliableCards.length,
          itemBuilder: (context, index)=>_buildPageCards(index),
        ),

      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:FloatingActionButton(
        onPressed: ()=>{
        },
        child: const Icon(Icons.settings),
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
                      Icon(Icons.cloud_queue_sharp,),
                      Icon(Icons.add,),
                      Icon(Icons.edit,),
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