import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:latlong2/latlong.dart';

import '../../api/call.dart';
import '../../pages/paging_fragments/map.dart';

class LocationHandler{

  Map<String,dynamic> whois_data = {};

  static final LocationHandler _instance = LocationHandler._internal();

  factory LocationHandler(){
    return _instance;
  }

  LocationHandler._internal();

  void initialize(){

  }

  static Map whois_json={};
  static Map geocode_json={};
  //LocationData? _curr_location;
  static String uiCityName="Local não definido";

  static bool locationAvaliable=false;
  static bool manually_set = false;
  static Location _locationService = Location();
  static StreamSubscription? _locSub;
  static LocationData? _locationData;
  static ValueNotifier _locationDataNotifier=ValueNotifier(_locationData);

  static Location get locationService => _locationService;
  static StreamSubscription? get locSub => _locSub;
  static LocationData? get locationData => _locationData;
  static ValueNotifier get locationDataNotifier => _locationDataNotifier;


  static void defineLocationManually(LocationData result){
    _locationData = result;
    _locationDataNotifier.value = _locationData;
  }

  static Future<Stream<LocationData>?> requestGPSListener({bool prompt=false}) async{

    try{
      PermissionStatus? perm = await checkGPSPermission();
      if(prompt){
        if(perm!=PermissionStatus.deniedForever){
          perm = await _locationService.requestPermission();
        }
      }
      if(perm==PermissionStatus.granted){
        await _locationService.changeSettings(
          accuracy: LocationAccuracy.balanced,
          interval: 15000,
        );
        return _locationService.onLocationChanged;
        //===========
      }else{
        throw Exception("Permission Denied");
      }
    } on Exception catch(e){
      return Future.error(e);
    }

  }

  static Future<LocationData?> requestCurrentGPS({bool prompt=false}) async{

    try{
      PermissionStatus? perm = await checkGPSPermission();
      if (prompt && perm != PermissionStatus.deniedForever) {
        perm = await _locationService.requestPermission();
      }

      if(perm==PermissionStatus.granted||perm==PermissionStatus.grantedLimited){
        //===========
        await _locationService.changeSettings(
          accuracy: LocationAccuracy.balanced,
          interval: 15000,
        );
        return _locationService.getLocation().timeout(const Duration(seconds: 4));
      }else{
        throw Exception("Permission Denied");
      }

    } on Exception catch(e){
      return Future.error(e);
    }

  }

  static Future<void> updateGlobalGPS({bool prompt=false}) async{

    try{
      PermissionStatus? perm = await checkGPSPermission();
      if (prompt && perm != PermissionStatus.deniedForever) {
        perm = await _locationService.requestPermission();
      }

      if(perm==PermissionStatus.granted||perm==PermissionStatus.grantedLimited){
        //===========
        await _locationService.changeSettings(
          accuracy: LocationAccuracy.balanced,
          interval: 15000,
        );
        _locationData = await _locationService.getLocation().timeout(const Duration(seconds: 4));
        _locationDataNotifier.value = _locationData;
        return;
      }else{
        throw Exception("Permission Denied");
      }

    } on Exception catch(e){
      return Future.error(e);
    }

  }

  static Future<PermissionStatus?> requestGPSPrecision() async{
    try{
      PermissionStatus? perm = await checkGPSPermission();
      if(perm!=PermissionStatus.deniedForever){
        return _locationService.requestPermission();

      }
    } on Exception catch(e){
      print(e);
    }
  }

  static Future<PermissionStatus?> checkGPSPermission() async {

    /*_locSub = Location.instance.onLocationChanged.listen((e) {
      setState(() {
        _userLocation = e;

      });
    });*/
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      //bool b1 = await ph.Permission.location.request().isGranted;
      //if(!b1) return;
      serviceEnabled = await _locationService.serviceEnabled();
      if (serviceEnabled) {
        return await _locationService.hasPermission();
        //return _permissionGranted;
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          return checkGPSPermission();
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        /*setState(() {
          _locationStatus = Icons.location_disabled_sharp;
        });*/
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        /*setState(() {
          _locationStatus = Icons.location_disabled_sharp;
        });*/
      }
      return Future.error(e);
    } on Exception catch(e){
      return Future.error(e);
    }
  }


  /*static Map _geocode_json={};
  static Map get geocode_json => _geocode_json;
  static Future<void> isp_geocode_data() async {
    await ApiRequests.get('/api/v1/loc/${LocationHandler.locationData?.latitude}/${LocationHandler.locationData?.longitude}').then((apiResponse){
      if (apiResponse.statusCode == 200) {
        String apiResponseBody = apiResponse.body.replaceAll('null',"\"null\"");

        try{
          _geocode_json = json.decode(apiResponseBody);
        }on Exception catch(e){
          print("internal error:");
          print(e);
          setState(() {
            LocationHandler.locationAvaliable=false;
          });
        }
        print("Geocoding completed");
      }else{
        print("request invalid: "+apiResponse.statusCode.toString());
        setState(() {
          LocationHandler.locationAvaliable=false;
        });
      }
      //return true;
    },onError: (e){
      print("major error:");
      print(e);
      setState(() {
        LocationHandler.locationAvaliable=false;
      });
    });
  }
*/

  static bool _isp_ongoing=false;
  static Map<String,dynamic> _response_isp_data={};

  static Future<Map<String,dynamic>> cached_isp_data(String params) async {

    if(_isp_ongoing==true) return Future.error("ongoing request");
    _isp_ongoing=true;
    try{

      if(_response_isp_data.isEmpty) {
        final Map<String,String> _qParams = <String,String>{
          'fields':params,
        };
        ApiRequests.cached_get("/api/v1/util/geocoding",_qParams).then((whoisResponse) {
          if (whoisResponse != null && whoisResponse.existsSync()) {
            var res = whoisResponse.readAsStringSync();
            _response_isp_data= json.decode(res);
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
      Future.error(e);
    }
    _isp_ongoing=false;
    return _response_isp_data;
    //final ipv4 = await Ipify.ipv4();
    //final geolocator_data = await http.get(Uri.http("geoplugin.net","/json.gp?ip=${ipv4}"));


    //inject default cards?
  }



  static Future<Map<String,dynamic>> isp_data(String params) async {
    if(_isp_ongoing==true) return Future.error("ongoing request");
    _isp_ongoing=true;
    try{
      if(_response_isp_data.isEmpty) {
        final Map<String,String> _qParams = <String,String>{
          'fields':params,
        };
        await ApiRequests.get("/api/v1/util/geocoding",_qParams).then((whoisResponse) {
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

  //================================================
  //================================================

  static manual_location_data(context,State state) async {
    LatLng? result = await Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) => MapFragment(mode: MapFragmentMode.LOCATIONPICKER,),
      fullscreenDialog: true,)
    );
    result!=null?
    LocationHandler.defineLocationManually(LocationData.fromMap({"latitude":result.latitude,"longitude":result.longitude}))
        :Scaffold.of(context).showSnackBar(const SnackBar(content: Text("Cancelled"),duration: Duration(seconds: 3),));

    await ApiRequests.get('/api/v1/loc/${LocationHandler.locationData?.latitude}/${LocationHandler.locationData?.longitude}').then((apiResponse){
      if (apiResponse.statusCode == 200) {
        String apiResponseBody = apiResponse.body.replaceAll('null',"\"null\"");

        try{
          LocationHandler.geocode_json = json.decode(apiResponseBody);
        }on Exception catch(e){
          print("internal error:");
          print(e);
          state.setState(() {
            LocationHandler.locationAvaliable=false;
          });
        }
        print("Geocoding completed");
      }else{
        print("request invalid: "+apiResponse.statusCode.toString());
        state.setState(() {
          LocationHandler.locationAvaliable=false;
        });
      }
      //return true;
    },onError: (e){
      print("major error:");
      print(e);
      state.setState(() {
        LocationHandler.locationAvaliable=false;
      });
    });

    state.setState(() {
      LocationHandler.uiCityName=LocationHandler.geocode_json['county'];
      LocationHandler.manually_set = true;
      LocationHandler.locationAvaliable=true;
    });
  }

  static fetch_location_data(State state,{bool precision=false}) async{
    if(LocationHandler.manually_set){
      state.setState(() {
        LocationHandler.locationAvaliable=false;
        LocationHandler.geocode_json.clear();
      });
    }
    LocationHandler.manually_set = false;

    // check permission
    print("check permission");

    if(!precision) {
      await LocationHandler.checkGPSPermission().then((value) {
        state.setState(() {
          LocationHandler.locationAvaliable = value == PermissionStatus.granted;
        });
      }, onError: (e) {
        print("Error on GPS permission");
        print(e);
      });
    }else {
      await LocationHandler.requestGPSPrecision().then((value) {
        state.setState(() {
          LocationHandler.locationAvaliable = value == PermissionStatus.granted;
        });
      });
    }

    //retrieve coordinates
    //LocationData? curr_location;
    if(LocationHandler.locationAvaliable){
      print("retrieve coordinates");
      await LocationHandler.updateGlobalGPS(prompt: false).then((value) {
        //_curr_location=value;
      },onError: (e){
        state.setState(() {
          LocationHandler.locationAvaliable = false;
        });
        print("Error on GPS Location retrieval");print(e);
      });
      /*setState(() {
        _curr_location==null?LocationHandler.locationAvaliable=false:null;
      });*/

    }
    await geocode_update(state);
  }

  static geocode_update(State state) async {
    String whoisParams;
    //retrieve geocoding
    //_last_location?.latitude!=curr_location?.latitude &&
    //_last_location?.longitude!=curr_location?.longitude
    if(LocationHandler.locationAvaliable && LocationHandler.geocode_json.isEmpty){
      print("retrieve geocoding");
      await ApiRequests.get('/api/v1/loc/${LocationHandler.locationData?.latitude}/${LocationHandler.locationData?.longitude}').then((apiResponse){
        if (apiResponse.statusCode == 200) {
          String apiResponseBody = apiResponse.body.replaceAll('null',"\"null\"");
          try{
            LocationHandler.geocode_json = json.decode(apiResponseBody);
          }on Exception catch(e){
            print("internal error:");
            print(e);
            state.setState(() {
              LocationHandler.locationAvaliable=false;
            });
          }
          print("Geocoding completed");
        }else{
          print("request invalid: ${apiResponse.statusCode}");
          state.setState(() {
            LocationHandler.locationAvaliable=false;
          });
        }
        //return true;
      },onError: (e){
        print("major error:");
        print(e);
        state.setState(() {
          LocationHandler.locationAvaliable=false;
        });
      });
    }else{
      print("skipping geocoding");
    }
    //==============================

    if(LocationHandler.locationAvaliable){
      whoisParams='ip,success,type';
    }else{
      whoisParams='ip,success,type,country,city,latitude,longitude';
    }

    if(LocationHandler.whois_json.isEmpty) {
      await LocationHandler.cached_isp_data(whoisParams).then((whoisResponse) {
        print("whois cached response set to:");
        print(whoisResponse);
        LocationHandler.whois_json = whoisResponse;
      }, onError: (e) {
        print("Error on whois fetch:");
        print(e);
        //state.setState((){failureMessage="Error on whois fetch";menuLoaded=1;});
        //return false;
      });
    }else{
      print("skipping whois phase");
    }

    if(LocationHandler.locationAvaliable) {
      if(LocationHandler.geocode_json.isNotEmpty) state.setState(() {LocationHandler.uiCityName=LocationHandler.geocode_json['county'];});
    } else {
      if(LocationHandler.whois_json.isNotEmpty) state.setState(() {LocationHandler.uiCityName=LocationHandler.whois_json['city'];});
    }
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
            'fields':'ip,success,type,country,city,latitude,longitude'
          };
          await http.get(
            Uri.https("ipwho.is","",_qParams)
        ).then((whois_response) {
          if(whois_response.statusCode==200){
              //ip,success,type,country,city,latitude,longitude
              whois_json= json.decode(whois_response.body);
              /*http.get(Uri.https(
                              "tcc-api-mon.azurewebsites.net","/api/v1/ui_data/main_menu",
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

        await ApiRequests.get("/api/v1/ui_data/main_menu",{
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