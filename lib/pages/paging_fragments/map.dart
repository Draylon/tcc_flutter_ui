import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:provider/provider.dart';
import 'package:ui/api/call.dart';

import '../../shared/components/LoadingIndicator.dart';
import '../../shared/state/GeneralProvider.dart';

class MapFragment extends StatefulWidget {
  final String title;
  MapFragment({Key? key, required this.title}) : super(key: key);

  @override
  _MapFragState createState() => _MapFragState();
}

class _MapFragState extends State<MapFragment> with AutomaticKeepAliveClientMixin<MapFragment>,TickerProviderStateMixin  {

  @override
  bool get wantKeepAlive => true;

  bool _isLoading = false;

  MapController mapctrl = MapController();
  late Marker userMarker;
  List<Marker> markers = [];

  Location _locationService = Location();
  LocationData? _userLocation;
  StreamSubscription? _locSub;

  IconData? _locationStatus = Icons.location_searching;

  bool _permission = false;

  String? _serviceError = '';

  int interActiveFlags = InteractiveFlag.all;

  DraggableScrollableController _pin_ctrl = DraggableScrollableController();


  //========================================================

  @override
  void initState() {

    userMarker=Marker(
        width: 40,
        height: 40,
        point: LatLng(-26.2542072,-48.8555393), //point: LatLng(-26.2861838,-48.9949695),
        builder: (ctx) => GestureDetector(
          child: Icon(Icons.location_on_outlined,size: 40,color: Colors.blueAccent,),
          onTap: ()=>ScaffoldMessenger.of(context).showSnackBar(markerClicked),
        ) //builder: (ctx) => const FlutterLogo( textColor: Colors.blue,  key: ObjectKey(Colors.blue), ),
    );

    super.initState();

    _initLocationService();

    markers = [userMarker];
    _fetch_markers();
    //AppDatabase().openDb().whenComplete(loaded);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //ImagePicker picker = ImagePicker();
    return !_isLoading ? _build_screen() : Center(child: CircularProgressIndicator());
  }

  void _parse_markers(String responseBody) {
    final List<Map<String,dynamic>>parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    parsed.forEach((e) {
      markers.add(
          Marker(
              width: 40,
              height: 40,
              point: LatLng(e["location"]["coordinates"][0],e["location"]["coordinates"][1]), //point: LatLng(-26.2861838,-48.9949695),
              builder: (ctx) => GestureDetector(
                child: Icon(Icons.location_on_outlined,size: 40,color: Colors.blueAccent,),
                onTap: ()=>ScaffoldMessenger.of(context).showSnackBar(markerClicked),
              ) //builder: (ctx) => const FlutterLogo( textColor: Colors.blue,  key: ObjectKey(Colors.blue), ),
          )
      );
    });

    //return parsed.map<String>((json)=>String);
    //return parsed.map<String>((json) =>String.fromJson(json)).toList();
  }
  _fetch_markers() async{
    try{
      print("Fetching sensor position");
      final response = await ApiRequests.call("/api/v1/sensor");
      if (response.statusCode == 200) {
        return _parse_markers(response.body);
      } else {
        throw Exception(response.statusCode);
      }
    }on Exception catch(e){
      print(e);
    }
  }

  Future<void> loaded() async {
    /*return await _imagesController.queryAll().whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });*/
  }
  //()=>ScaffoldMessenger.of(context).showSnackBar(markerClicked),
  final markerClicked = const SnackBar(
    content: Text('Marker tap'),
    duration: Duration(seconds:2),
  );

  _build_screen(){
    return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if(constraints.maxHeight > constraints.maxWidth) {
              return _build_appbody(Orientation.portrait);
            }
            else {
              return _build_appbody(Orientation.landscape);
            }
          },
    );
  }

  _build_appbody(orientation){
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: _build_page(orientation),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 45),
        child:
          FloatingActionButton(
            heroTag: null,
            onPressed: () async {
              /*final XFile? image = await picker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear);
              await _newImage(image);*/
              //mapctrl.move(markers[0].point, 15);
              //ScaffoldMessenger.of(context).showSnackBar(imageCanceled);
              _animatedMapMove(userMarker.point, 15);
              _initLocationService();
            },
            tooltip: 'Your Location',
            child: Icon(_locationStatus,size: 30,),
          ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  _build_page(orientation){
    return _build_basemap();
  }
  _build_page2(orientation){
    if(orientation == Orientation.portrait){
      return Stack(
        fit: StackFit.expand,
        children: [
          _build_basemap(),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
            ),
            child: const Icon(Icons.keyboard_arrow_up),
          ),
        ]
      );
    }else{
      return Stack(
        fit: StackFit.expand,
        children: [
          _build_basemap(),
          //_build_botleftDraggableSettings(),
        ],
      );
    }
  }

  /*
  * https://www.youtube.com/watch?v=NG6pvXpnIso
  * https://www.youtube.com/watch?v=RaThk0fiphA
  * https://www.youtube.com/watch?v=PGK2UUAyE54
  * https://www.youtube.com/watch?v=75CsnyRXf5I
  * https://www.youtube.com/watch?v=XcnP3_mO_Ms
  * https://www.youtube.com/watch?v=zEdw_1B7JHY
  * https://www.youtube.com/watch?v=NvtMt_DtFrQ
  *
  * https://www.youtube.com/watch?v=sVV3rjrTi3k
  * */


  _build_basemap(){
    return Container(
      child: FlutterMap(
      mapController: mapctrl,
      options: MapOptions(
        interactiveFlags: InteractiveFlag.all,
        center: LatLng(-26.2542072,-48.8555393),
        zoom: 15,
        maxZoom: 15,
        minZoom: 12,
      ),

      layers: [
        MarkerLayerOptions(markers: markers),
      ],

      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',backgroundColor: Colors.black54,
            tilesContainerBuilder: darkModeTilesContainerBuilder,
          ),
        ),
      ],
      /*layers: [

        TileLayerOptions(
          urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',backgroundColor: Colors.black54,
          tilesContainerBuilder: darkModeTilesContainerBuilder,

        ),
        MarkerLayerOptions(markers: markers),

      ],*/
    ),
    );
  }

  _build_basemap2(){
    return Consumer<GeneralProvider>(
      builder: (context, provider, _) => FutureBuilder<Map<String, String>?>(
        future: provider.currentStore == null
            ? Future.sync(() => {})
            : FMTC.instance(provider.currentStore!).metadata.readAsync,
        builder: (context, metadata) {
          if (!metadata.hasData ||
              metadata.data == null ||
              (provider.currentStore != null && metadata.data!.isEmpty)) {
            return const LoadingIndicator(
              message:
              'Loading Settings...\n\nSeeing this screen for a long time?\nThere may be a misconfiguration of the\nstore. Try disabling caching and deleting\n faulty stores.',
            );
          }

          final String urlTemplate =
          provider.currentStore != null && metadata.data != null
              ? metadata.data!['sourceURL']!
              : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

          return FlutterMap(
            options: MapOptions(
              center: LatLng(51.509364, -0.128928),
              zoom: 9.2,
              maxBounds: LatLngBounds.fromPoints([
                LatLng(-90, 180),
                LatLng(90, 180),
                LatLng(90, -180),
                LatLng(-90, -180),
              ]),
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              keepAlive: true,
            ),
            nonRotatedChildren: [
              AttributionWidget.defaultWidget(
                source: Uri.parse(urlTemplate).host,
              ),
            ],
            layers: [
              TileLayerOptions(
                urlTemplate: urlTemplate,
                tileProvider: provider.currentStore != null
                    ? FMTC.instance(provider.currentStore!).getTileProvider(
                  FMTCTileProviderSettings(
                    behavior: CacheBehavior.values
                        .byName(metadata.data!['behaviour']!),
                    cachedValidDuration: int.parse(
                      metadata.data!['validDuration']!,
                    ) ==
                        0
                        ? Duration.zero
                        : Duration(
                      days: int.parse(
                        metadata.data!['validDuration']!,
                      ),
                    ),
                  ),
                )
                    : NetworkNoRetryTileProvider(),
                maxZoom: 20,
                userAgentPackageName: 'dev.org.fmtc.example.app',
                keepBuffer: 5,
                backgroundColor: const Color(0xFFaad3df),
              ),
            ],
          );
        },
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapctrl.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapctrl.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapctrl.zoom, end: destZoom);
    final rotateTween = Tween<double>(begin: mapctrl.rotation,end: 0);

    final controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      mapctrl.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
      mapctrl.rotate(rotateTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

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

              setState(() {
                _locationStatus = Icons.my_location;
              });

              location = await _locationService.getLocation();
              _userLocation = location;
              userMarker.point.latitude =_userLocation!.latitude!;
              userMarker.point.longitude =_userLocation!.longitude!;
              _locationService.onLocationChanged.listen((LocationData result) async {
                if (mounted) {
                  setState(() {
                    _userLocation = result;
                    userMarker.point.latitude =_userLocation!.latitude!;
                    userMarker.point.longitude =_userLocation!.longitude!;
                  });
                }
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
        setState(() {
          _locationStatus = Icons.location_disabled_sharp;
        });
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
        setState(() {
          _locationStatus = Icons.location_disabled_sharp;
        });
      }
      location = null;
    } on Exception catch(e){
      print("unknown error");
      _serviceError = e as String?;
    }
  }


  /*_getPhotoList(){
    return ListView.builder(itemBuilder: (context, index) {
      return _imageCard(index);
    },
      itemCount: _imagesController.images.length,);
  }*/

  /*_imageCard(int i){
    DateTime d = DateTime.parse(_imagesController.images[i].data!);
    return Container(
      child: Card(
        child: InkWell(
          onTap: () async {
            final val = await Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext c) {
                  return new ViewImage(_imagesController.images[i].id!);
                }));
            if(val != null && val == true) loaded();
          },
          child: Ink(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(_imagesController.images[i].titulo!),
                      Text("${d.day}/${d.month}/${d.year} ${d.hour > 12 ? d.hour - 12 : d.hour} : ${d.minute} ${d.hour > 12 ? 'PM' : 'AM'}"),
                      Text(_imagesController.images[i].lat!.toString()),
                      Text(_imagesController.images[i].long!.toString())
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Image.memory(base64.decode(_imagesController.images[i].img!)),
                    //Image(image: NetworkImage("https://i.pinimg.com/originals/41/71/b1/4171b1b35e0c25ed4871c1109372ea4c.gif"),),
                    margin: EdgeInsets.all(15),
                  ),
                )
              ],
            ),
          ),
        ),
        elevation: 3,
        shadowColor: Colors.black54,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      margin: EdgeInsets.fromLTRB(15, 25, 15, 25),
    );

  }*/
}
