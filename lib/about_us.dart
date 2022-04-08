import 'package:flutter/material.dart';
class AboutUs_Page extends StatefulWidget {
  const AboutUs_Page({Key? key}) : super(key: key);

  @override
  _AboutUs_PageState createState() => _AboutUs_PageState();
}
//Not included yet
class _AboutUs_PageState extends State<AboutUs_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us")
      ),
      body:Container(),
    );
  }
}
