import 'package:flutter/material.dart';
import 'dart:io';

import 'package:thumbnails/thumbnails.dart';
import 'package:whatsapp_status_saver/screens/play_video.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final Directory _videoDirectory = new Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
  @override
  Widget build(BuildContext context) {
    return !Directory("${_videoDirectory.path}").existsSync()?
        Container(child: Center(child: Text('Install WhatsApp'),),):
        VideoGrid(directory: _videoDirectory,);
  }
}

class VideoGrid extends StatefulWidget {

  Directory directory;
  VideoGrid({this.directory});
  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {


  getThumbnail(videoPath) async{
    String thumb=await Thumbnails.getThumbnail(
        videoFile: videoPath,
        imageType:ThumbFormat.PNG,
        quality: 8
    );
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    var videoList=widget.directory.listSync().map((item) =>item.path).
    where((item) =>item.endsWith(".mp4") ).toList(growable: false);
    return videoList.length==0||videoList==null?
        Container(child: Center(child: Text('No video status found'),),):
        Container(
          padding: EdgeInsets.all(10.0),
          child: GridView.builder(
              itemCount: videoList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing:10.0,
                crossAxisSpacing: 10.0
              ),
            itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>PlayVideo(videoPath: videoList[index],)));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      child: FutureBuilder(
                        future: getThumbnail(videoList[index]),
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.done&&snapshot.hasData) {
                            return Hero(
                                tag:videoList[index],
                                child: Image.file(
                                  File(snapshot.data),
                                  fit: BoxFit.cover,
                                )
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    )
                  ),
                );
            },

          ),
        );
  }
}
