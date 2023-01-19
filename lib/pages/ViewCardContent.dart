import 'package:flutter/material.dart';

enum CardContentDataType{
  Tags,SensorData,WithinCity,NearbyCities
}

class ViewCardContent extends StatefulWidget{
  CardContentDataType type;
  List<dynamic> data;
  ViewCardContent(CardContentDataType this.type,List<dynamic> this.data);

  @override
  State<StatefulWidget> createState() => _ViewCardContentState();
}

class _ViewCardContentState extends State<ViewCardContent>{
  @override
  Widget build(BuildContext context) => _buildCardContent();

  @override
  void initState() {
    super.initState();
    //AppDatabase().openDb().whenComplete(loaded);
  }

  @override
  void dispose(){
    super.dispose();
  }

  _buildCardContent(){
    return Container();
  }
}