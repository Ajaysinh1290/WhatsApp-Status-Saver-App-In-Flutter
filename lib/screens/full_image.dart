import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';

class FullImage extends StatefulWidget {

  String imagePath;
  FullImage(this.imagePath);
  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  Color _themeColor=Color(0xff30384c);
  @override
  Widget build(BuildContext context) {
    void _onLoading(bool t, String str) {
      if (t) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator()),
                  ),
                ],
              );
            });
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SimpleDialog(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Image Saved in Gallary",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20,),
                            Text(str,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,

                                )),
                            SizedBox(height: 15,),
                            Text("Storage > whatsapp_status_saver",
                                style: TextStyle(
                                    fontSize: 16.0, color: _themeColor,fontWeight: FontWeight.bold)),
                            SizedBox(height: 20,),
                            MaterialButton(
                              child: Text("Close"),
                              color: _themeColor,
                              textColor: Colors.white,
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      }
    }
    return Hero(
      tag: widget.imagePath,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _themeColor,
          actions: [
            IconButton(
              onPressed: () async {
                print('Downloading...');
                _onLoading(true, "");
                File originalImageFile = File(widget.imagePath);
                if (!Directory("/storage/emulated/0/whatsapp_status_saver/Images/whatsapp_status_saver")
                    .existsSync()) {
                  Directory("/storage/emulated/0/whatsapp_status_saver/Images/whatsapp_status_saver")
                      .createSync(recursive: true);
                }
                String curDate = DateTime.now().toString();
                String newFileName =
                    "/storage/emulated/0/whatsapp_status_saver/Images/Image-$curDate.jpg";
                print(newFileName);
                await originalImageFile.copy(newFileName);

                _onLoading(false,
                    "If Image not available in gallary\nYou can find all images at");
                print("Downloaded");
              },
              icon: Icon(Icons.download_sharp,size:30),
            ),
            IconButton(
              onPressed: (){

                print("Sharing");
                Share.shareFiles([widget.imagePath]);

              },
              icon: Icon(Icons.share_outlined,size: 25,),
            ),
            SizedBox(width: 10,)
          ],
        ),
        body: Center(
          child: Image.file(
            File(widget.imagePath),
          ),
        ),

      ),
    );
  }
}
