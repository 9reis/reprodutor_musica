import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicaPlayer(),
    );
  }
}

class MusicaPlayer extends StatefulWidget {
  const MusicaPlayer({super.key});

  @override
  State<MusicaPlayer> createState() => _MusicaPlayerState();
}

class _MusicaPlayerState extends State<MusicaPlayer> {
  bool isPlaying = false;
  double value = 0;

  // Cria a instancia do Music Player
  final player = AudioPlayer();

  // Seta a duração
  Duration? duration = Duration(seconds: 0);

  // Func para reproduzir a musica
  void initPlayer() async {
    await player.setSource(AssetSource('01.mp3'));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Music Streaming Player',
      //     style: TextStyle(
      //       color: Colors.black,
      //     ),
      //   ),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/summer.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black45,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/summer.jpg',
                  width: 250,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Summer Vibes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  letterSpacing: 6,
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(value / 60).floor()}: ${(value % 60).floor()}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Slider.adaptive(
                    onChanged: (v) {
                      setState(() {
                        value = v;
                      });
                    },
                    min: 0,
                    max: duration!.inSeconds.toDouble(),
                    value: value,
                    // Reproduz a partir de um determinado ponto da barra de reprodução
                    onChangeEnd: (newValue) async {
                      setState(() {
                        value = newValue;
                      });
                      player.pause();
                      await player.seek(Duration(seconds: newValue.toInt()));
                      await player.resume();
                    },
                    activeColor: Colors.white,
                  ),
                  Text(
                    '${duration!.inMinutes} : ${duration!.inSeconds % 60}',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.black87,
                  border: Border.all(color: Colors.pink),
                ),
                child: InkWell(
                  // Reproduz o som
                  onTap: () async {
                    if (isPlaying) {
                      player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await player.resume();
                      setState(() {
                        isPlaying = true;
                      });
                      // Seta o tempo atual da musica na barra de reprodução
                      player.onPositionChanged.listen(
                        (position) {
                          setState(() {
                            value = position.inSeconds.toDouble();
                          });
                        },
                      );
                    }
                  },
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
