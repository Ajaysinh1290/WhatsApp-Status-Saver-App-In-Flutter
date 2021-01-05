import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
class PlayVideo extends StatefulWidget {

  String videoPath;
  PlayVideo({this.videoPath});
  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  VideoPlayerController _videoPlayerController;
  ChewieController chewieController;
  Color _themeColor=Color(0xff30384c);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    await _videoPlayerController.initialize();
    chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
      allowFullScreen: false,
      allowMuting: false
    );
    setState(() {});
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

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
                              "Video Saved in Gallary",
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
      tag: widget.videoPath,
      child: Scaffold(
        extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: _themeColor.withOpacity(0.5),
            actions: [
              IconButton(
                onPressed: () async {
                  print('Downloading...');
                  _onLoading(true, "");
                  File originalVideoFile = File(widget.videoPath);
                  if (!Directory("/storage/emulated/0/whatsapp_status_saver/Videos")
                      .existsSync()) {
                    Directory("/storage/emulated/0/whatsapp_status_saver/Videos")
                        .createSync(recursive: true);
                  }
                  String curDate = DateTime.now().toString();
                  String newFileName =
                      "/storage/emulated/0/whatsapp_status_saver/Videos/VIDEO-$curDate.mp4";
                  print(newFileName);
                  await originalVideoFile.copy(newFileName);

                  _onLoading(false,
                      "If Video not available in gallary\nYou can find all videos at");
                  print("Downloaded");
                },
                icon: Icon(Icons.download_sharp,size:30),
              ),
              IconButton(
                onPressed: (){

                  print("Sharing");
                  Share.shareFiles([widget.videoPath]);

                },
                icon: Icon(Icons.share_outlined,size: 25,),
              ),
              SizedBox(width: 10,)
            ],
          ),
          body: chewieController != null &&
              chewieController.videoPlayerController.value.initialized ?
          Container(
            padding: EdgeInsets.only(top: 18),
            child: Chewie(
              controller: chewieController,
            ),
          ) :
          Center(
            child: CircularProgressIndicator(),
          ),
      ),
    );
  }
}
