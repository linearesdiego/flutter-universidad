import 'package:flutter/material.dart';

final Map<String,dynamic> _icons ={
    "add_alert":Icons.add_alert,
    "accessibility": Icons.accessibility,
    "folder_open": Icons.folder_open
};


Icon getIcon(String icon){
  return Icon(_icons[icon], color: Colors.blueAccent);
}
