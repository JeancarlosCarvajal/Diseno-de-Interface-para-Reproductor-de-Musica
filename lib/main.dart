import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

import 'package:j_reproductor_app/src/models/audioplayer_model.dart';
import 'package:j_reproductor_app/src/pages/music_player_page.dart';
import 'package:j_reproductor_app/src/theme/theme.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> new AudioPlayerModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: miTema,
        home: const MusicPlayerPage()
      ),
    );
  }
}