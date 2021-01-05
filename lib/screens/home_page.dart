import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_status_saver/screens/video_screen.dart';

import 'image_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _themeColor=Color(0xff30384c);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _themeColor,
          title: Text('WhatsApp Status Saver'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(child: Text('Video',style: TextStyle(fontSize: 16)),),
              Tab(child: Text('Images',style: TextStyle(fontSize: 16),),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VideoScreen(),
            ImageScreen()
          ],
        ),
      ),
    );
  }
}
