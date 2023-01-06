
import 'package:flutter/material.dart';

class ExibitCard{
  String title;
  String description;
  Image img;
  ExibitCard(this.title, this.description,this.img);
  ExibitCard.fromJson(Map json):title = json['title'],description = json['email'],img=json['img'];
}