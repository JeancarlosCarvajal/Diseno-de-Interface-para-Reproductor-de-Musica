// ignore_for_file: unnecessary_this
import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:j_reproductor_app/src/helpers/helpers.dart';
import 'package:j_reproductor_app/src/models/audioplayer_model.dart';
import 'package:j_reproductor_app/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          const Background(),

          Column(
            children: <Widget>[

              CustomAppBar(),

              const ImagenDiscoDuracion(),

              const TituloPlay(),

              const Expanded(
                child: Lyrics()
              )

            ],
          ),
        ],
      )
   );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.70,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only( bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ]
        )
      ),
    );
  }
}

class Lyrics extends StatelessWidget {
  const Lyrics({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final lyrics = getLyrics();

    return Container(
      // color: const Color.fromARGB(255, 32, 32, 32),
      margin: const EdgeInsets.only(top: 10),
      child: ListWheelScrollView( 
        physics: const BouncingScrollPhysics(),
        itemExtent: 42,
        diameterRatio: 1.5,
        children: lyrics.map( 
          (linea) => Text( linea, style: TextStyle( fontSize: 20, color: Colors.white.withOpacity(0.6) ) )
        ).toList()
      ),
    );
  }
}

class TituloPlay extends StatefulWidget {
  const TituloPlay({Key? key}) : super(key: key);


  @override
  _TituloPlayState createState() => _TituloPlayState();
}

class _TituloPlayState extends State<TituloPlay> with SingleTickerProviderStateMixin {

  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController playAnimation; 
 
  final assetAudioPlayer = new AssetsAudioPlayer();
 
  @override
  void initState() { 
    // final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
    this.playAnimation = AnimationController( vsync: this, duration: const Duration(milliseconds: 500 ) );  
    // audioPlayerModel.controller = playAnimation;
    // playAnimation.forward();
    super.initState();
  }

  @override
  void dispose() { 
    this.playAnimation.dispose();
    super.dispose();
  }

  void open() {

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

    //! assetAudioPlayer.open('assets/Breaking-Benjamin-Far-Away.mp3');
    assetAudioPlayer.open(
      Audio('assets/Mariposa-Traicionera-Video-Oficial.mp3'),
      autoStart: true,
      showNotification: true
    );

    assetAudioPlayer.currentPosition.listen( (duration) {
      audioPlayerModel.current = duration;
      // print('jean: $duration');
    });
  
    assetAudioPlayer.current.listen( (playingAudio){
      //! audioPlayerModel.songDuration = playingAudio.duration;
      audioPlayerModel.songDuration = playingAudio?.audio.duration ?? const Duration(seconds: 0);
      print('jean: ${playingAudio?.audio.duration}'); 
    }); 
 
  }


  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false); 
    // playAnimation = audioPlayerModel.controller;  

    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
      margin: const EdgeInsets.only( top: 20 ),
      child: Row(
        children: <Widget>[

          Column(
            children: <Widget>[
              Text('Mariposa Traicionera', style: TextStyle( fontSize: 20, color: Colors.white.withOpacity(0.8) )),
              Text('-Mana-', style: TextStyle( fontSize: 15, color: Colors.white.withOpacity(0.5) )),
            ],
          ),

          const Spacer(),

          FloatingActionButton(
            elevation: 3,
            splashColor: const Color.fromARGB(255, 255, 8, 8),
            // highlightElevation: 0,
            backgroundColor: const Color.fromARGB(255, 21, 173, 13),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause, 
              progress: playAnimation,
            ),
            onPressed: () {

              if (kDebugMode) {
                // print('jean: dandole Play');
                print('jean: Play y quedan ${audioPlayerModel.restTimeSong} segundos'); 
              }
              
              if( isPlaying ) {
                playAnimation.reverse();
                this.isPlaying = false; 
                audioPlayerModel.playing = false;
                audioPlayerModel.controller.stop();  
              } else {
                playAnimation.forward();
                this.isPlaying = true; 
                audioPlayerModel.playing = true;
                audioPlayerModel.controller.repeat();   
              }

              if ( firstTime ) {
                this.open(); 
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause(); 
              }

            },
          )

        ],
      ),
    );
  }
}

class ImagenDiscoDuracion extends StatelessWidget {
  const ImagenDiscoDuracion({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 30 ),
      margin: const EdgeInsets.only( top: 40 ),
      child: Row(
        children: const <Widget>[

          ImagenDisco(),
 
          Spacer(),

          BarraProgreso(), 

        ],
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {
  const BarraProgreso({Key? key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {

    final estilo = TextStyle( color: Colors.white.withOpacity(0.4) );

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;

    return Column(

      children: <Widget>[

        Text(audioPlayerModel.songTotalDuration, style: estilo), 
        const SizedBox( height: 10 ),
        Stack(
          children: <Widget>[

            Container(
              width: 3,
              height: 230,
              color: Colors.white.withOpacity(0.1),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                width: 3,
                height: 230 * porcentaje,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

          ],
        ),
        const SizedBox( height: 10 ),
        Text(audioPlayerModel.currentSecond, style: estilo ),
      ],
    );
  }
}

class ImagenDisco extends StatelessWidget {
  const ImagenDisco({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context); 
    print('jean is playing: ${audioPlayerModel.porcentaje}'); 
    
    audioPlayerModel.playing
      ? audioPlayerModel.controller.status == AnimationStatus.completed ? audioPlayerModel.controller.repeat() : false
      : false; 

    audioPlayerModel.porcentaje == 1.0 
      ? audioPlayerModel.controller.stop()
      : false;

    // final status = audioPlayerModel.playing ? print('jean: en Corriendo') : print('jean: Parado'); 
    
    return Container(
      padding: const EdgeInsets.all(20),
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [

            Color(0xff484750),
            Color(0xff1E1C24),

          ]
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            
            SpinPerfect(
              animate: audioPlayerModel.playing,
              duration: Duration(seconds: 10), // audioPlayerModel.current
              infinite:  true,
              manualTrigger:  true,
              controller: ( animationController ) => audioPlayerModel.controller = animationController,
              child: const Image( image: AssetImage('assets/mana.jpg') )
            ),

            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(100)
              ),
            ),

            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xff1C1C25),
                borderRadius: BorderRadius.circular(100)
              ),
            ),

          ],
        )
      ),
    );
  }
}