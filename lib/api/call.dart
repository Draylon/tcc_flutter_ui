
import 'package:file/src/interface/file.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class ApiRequests{

    static Future<File> cached_call(String route, [Map<String,String>?queryParameters,]){
        if(Foundation.kReleaseMode){
            return DefaultCacheManager().getSingleFile(
                "tcc-api-mon.azurewebsites.net"+route,headers: queryParameters
            );
        }else{
            print("Requesting on debug");
            return DefaultCacheManager().getSingleFile(
                "192.168.0.4:8081"+route,headers: queryParameters
            );
        }
    }

    static Future<http.Response> call(String route, [Map<String,dynamic>?queryParameters,]){
        if(Foundation.kReleaseMode){
            return http.get(Uri.https(
                "tcc-api-mon.azurewebsites.net",route,queryParameters
            ),headers: {'Access-Control-Allow-Origin': '*'});
        }else{
            print("Requesting on debug");
            return http.get(Uri.http(
                "192.168.0.4:8081",route,queryParameters
            ));
        }
    }


    static http.Response? sync_call(String route, [Map<String,dynamic>?queryParameters,]) {
        if(Foundation.kReleaseMode){
            http.get(Uri.https(
                "tcc-api-mon.azurewebsites.net",route,queryParameters
            ),headers: {'Access-Control-Allow-Origin': '*'}).then((value) {
                return value;
            });
        }else{
            print("Requesting on debug");

            http.get(Uri.http(
                "192.168.0.4:8081",route,queryParameters
            )).then((value) {
                return value;
            });
            print("requested on debug");
        }
    }
}