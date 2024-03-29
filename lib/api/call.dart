
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:file/src/interface/file.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' show kIsWeb;

class ApiRequests{

    static Future<File> cached_get(String route, [Map<String,String>?queryParameters,]){
        String formattedQuery = "";
        if(queryParameters!=null){
            if(queryParameters.isNotEmpty) formattedQuery="?";
            queryParameters.forEach((key, value)=>{
                formattedQuery+= (key + "=" + value + "&")
            });
        }

        if(Foundation.kReleaseMode){
            return DefaultCacheManager().getSingleFile(
                "http://192.168.43.35:8081$route/$formattedQuery",headers:{
                "Access-Control-Allow-Origin": "*",
                'Content-Type': 'application/json',
                'Accept': '*/*',
                "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
                "Access-Control-Allow-Headers": "*",
                "Access-Control-Allow-Methods": "GET, POST, OPTIONS, PUT, DELETE"
            }
            );
        }else{
            print("Requesting on debug");
            return DefaultCacheManager().getSingleFile(
                "https://tcc-api-mon.azurewebsites.net$route/$formattedQuery",
                headers: {
                    "Access-Control-Allow-Origin": "*",
                    'Content-Type': 'application/json',
                    'Accept': '*/*',
                    "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
                    "Access-Control-Allow-Headers": "*",
                    "Access-Control-Allow-Methods": "GET, POST, OPTIONS, PUT, DELETE"
                }
            );
        }
    }

    /*static Future<Object> getCors(String route, [Map<String,dynamic>?queryParameters,]){
        String formattedQuery = "";
        if(queryParameters!=null){
            if(queryParameters.isNotEmpty) formattedQuery="?";
            queryParameters.forEach((key, value)=>{
                formattedQuery+= (key + "=" + value + "&")
            });
        }
        if(Foundation.kIsWeb){
            dynamic var1 = HttpRequest.requestCrossOrigin("tcc-api-mon.azurewebsites.net/$route/$formattedQuery");
            print(var1);
            return var1;
        }else{
            return ApiRequests.get("$route/$formattedQuery",queryParameters);
        }
    }*/


    static Future<http.Response> get(String route, [Map<String,dynamic>?queryParameters,]){
        if(Foundation.kReleaseMode){
            return http.get(Uri.http(
                "192.168.43.35:8081",route,queryParameters
            ),headers: {
                "Access-Control-Allow-Origin": "*",
                'Content-Type': 'application/json',
                'Accept': '*/*',
                "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
                "Access-Control-Allow-Headers": "*",
                "Access-Control-Allow-Methods": "GET, POST, OPTIONS, PUT, DELETE"
            });
        }else{
            print("Requesting on debug");
            return http.get(Uri.https(
                "tcc-api-mon.azurewebsites.net",route,queryParameters
            ),headers: {
                "Access-Control-Allow-Origin": "*",
                'Content-Type': 'application/json',
                'Accept': '*/*',
                "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
                "Access-Control-Allow-Headers": "*",
                "Access-Control-Allow-Methods": "GET, POST, OPTIONS, PUT, DELETE"
            });
        }
    }


    static http.Response? sync_get(String route, [Map<String,dynamic>?queryParameters,]) {
        if(Foundation.kReleaseMode){
            http.get(Uri.http(
                "192.168.43.35:8081",route,queryParameters
            )).then((value) {
                return value;
            });
        }else{
            print("Requesting on debug");

            http.get(Uri.https(
                "tcc-api-mon.azurewebsites.net",route,queryParameters
            )).then((value) {
                return value;
            });
            print("requested on debug");
        }
    }

    static Future<http.Response> post(String route, [Map<String,dynamic>?queryParameters,Object? body,Encoding? enc]){
        if(Foundation.kReleaseMode){
            return http.post(Uri.http(
                "192.168.43.35:8081",route,queryParameters
            ),body: body,encoding: enc);
        }else{
            print("Requesting on debug");
            return http.post(Uri.https(
                "tcc-api-mon.azurewebsites.net",route,queryParameters
            ),
                body: body,
                encoding: enc);
        }
    }
}