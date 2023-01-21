import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationHandler{

  Map<String,dynamic> whois_data = {};

  static final LocationHandler _instance = LocationHandler._internal();

  factory LocationHandler(){
    return _instance;
  }

  LocationHandler._internal();

  void initialize(){

  }

  static Location _locationService = Location();
  static LocationData? _userLocation;
  static StreamSubscription? _locSub;
  static bool _permission = false;
  static String? _serviceError = '';

  void _initLocationService() async {
    /*_locSub = Location.instance.onLocationChanged.listen((e) {
      setState(() {
        _userLocation = e;

      });
    });*/

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      //bool b1 = await ph.Permission.location.request().isGranted;
      //if(!b1) return;
      serviceEnabled = await _locationService.serviceEnabled();
      if (serviceEnabled) {
        PermissionStatus _permissionGranted = await _locationService.hasPermission();
        if (_permissionGranted != PermissionStatus.deniedForever){
          final permission = await _locationService.requestPermission();
          _permission = permission == PermissionStatus.granted;
          if (_permission) {
            //===========
            await _locationService.changeSettings(
              accuracy: LocationAccuracy.balanced,
              interval: 15000,
            );

            /*setState(() {
              _locationStatus = Icons.my_location;
            });*/

            location = await _locationService.getLocation();
            _userLocation = location;
            //userMarker.point.latitude =_userLocation!.latitude!;
            //userMarker.point.longitude =_userLocation!.longitude!;
            _locationService.onLocationChanged.listen((LocationData result) async {
              /*if (mounted) {
                setState(() {
                  _userLocation = result;
                  userMarker.point.latitude =_userLocation!.latitude!;
                  userMarker.point.longitude =_userLocation!.longitude!;
                });
              }*/
            });
            //============
          }
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          _initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
        /*setState(() {
          _locationStatus = Icons.location_disabled_sharp;
        });*/
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
        /*setState(() {
          _locationStatus = Icons.location_disabled_sharp;
        });*/
      }
      location = null;
    } on Exception catch(e){
      print("unknown error");
      _serviceError = e as String?;
    }
  }

  static bool _isp_ongoing=false;
  static Map<String,dynamic> _response_isp_data={};
  static Future<Map<String,dynamic>> isp_data() async {
    if(_isp_ongoing==true) return Future.error("ongoing request");
    _isp_ongoing=true;
    try{
      if(_response_isp_data.isEmpty) {
        final Map<String,String> _qParams = <String,String>{
          'fields':'ip,connection,success,type,country,city,latitude,longitude'
        };
        await http.get(
            Uri.https("ipwho.is","",_qParams)
        ).then((whoisResponse) {
          if(whoisResponse.statusCode==200){
            //ip,success,type,country,city,latitude,longitude
            _response_isp_data= json.decode(whoisResponse.body);
          }else{
            return Future.error(whoisResponse);
          }
        },onError: (e) {
          print("Error on whois fetch:");
          print(e);
          //failed to retrieve ISP info
          return Future.error(e);
        });
      }
    } catch(e){
      print(e);
    }
    _isp_ongoing=false;
    return _response_isp_data;
    //final ipv4 = await Ipify.ipv4();
    //final geolocator_data = await http.get(Uri.http("geoplugin.net","/json.gp?ip=${ipv4}"));


    //inject default cards?
  }

}


/*
_fetch_card_data() async {
      try{
        setState(() {
          menuLoaded=0;
        });
        if(whois_json.isEmpty) {
          final Map<String,String> _qParams = <String,String>{
            'fields':'ip,connection,success,type,country,city,latitude,longitude'
          };
          await http.get(
            Uri.https("ipwho.is","",_qParams)
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
          return;
        }

        //Pegar os dados do Location da pessoa ainda e por aq tbm
        //ver se dá pra fazer isso aq virar GET FormData

        await ApiRequests.call("/api/ui_data/main_menu",{
          'ip': whois_json['ip'],
          'country': whois_json['country'],
          'city': whois_json['city'],
          'latitude': whois_json['latitude'].toString(),
          'longitude': whois_json['longitude'].toString(),
          'connection': whois_json['connection'].toString(),
        }).then((api_response) {
          print("Request completed");
          if (api_response.statusCode == 200) {
            try{
              azure_json = json.decode(api_response.body);
              setState((){
                menuLoaded=2;
                avaliableCards.initializer(azure_json,this.context);
                //azure_json.map((e) => ExibitCard.fromJson(e)).toList();
              });
            }catch(e){
              print(e);
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
          print("latest error: $failureMessage");
          print(e.toString());
          print("----");
        }

        //final ipv4 = await Ipify.ipv4();
        //final geolocator_data = await http.get(Uri.http("geoplugin.net","/json.gp?ip=${ipv4}"));


        //inject default cards?
  }

 */