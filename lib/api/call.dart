import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:http/http.dart' as http;

class ApiRequests{
    static const bool doSecure = false;
    static Future<http.Response> call(String route, [Map<String,dynamic>?queryParameters,]){
        if(!doSecure){
            print("Requesting on debug");
            return http.get(Uri.http(
                "192.168.3.121:8081",route,queryParameters
            )).timeout(const Duration(seconds: 5));
        }
        if(Foundation.kReleaseMode){
            return http.get(Uri.https(
                "tcc-api-mon.azurewebsites.net",route,queryParameters
            ));
        }else{
            print("Requesting on debug");
            return http.get(Uri.https(
                "192.168.3.98:8080",route,queryParameters
            ));
        }
    }
}