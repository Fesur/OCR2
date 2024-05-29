import 'dart:io';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  File? selectedMedia;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            'Reconocimiento de Texto'
        ),
      ),
      body: Stack(
        children: [
          _background(),
          _buildUI(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<MediaFile>? media = await GalleryPicker.pickMedia(
              context: context, singleMedia: true);
          if (media != null && media.isNotEmpty) {
            var data = await media.first.getFile();
            setState(() {
              selectedMedia = data;
            });
          }
        },
        child: const Icon(
            Icons.add),
      ),
    );
  }
  Widget _background(){
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: const ParticleOptions(
          spawnMaxRadius: 50,
          spawnMinSpeed: 10.00,
          particleCount: 68,
          spawnMaxSpeed: 50,
          minOpacity: 0.3,
          spawnOpacity: 0.4,
          baseColor: Colors.brown,
          image: Image(image: AssetImage('lib/assets/Images/Flutter.png')),
        ),
      ), vsync: this,
      child: Container(),
    );
  }
  Widget _buildUI(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _imageView(),
        _extractTextView(),
      ],
    );
  }
  Widget _imageView(){
    if(selectedMedia==null){
      return const Center(
        child: Text("Elige una imagen para el reconocimiento de texto.",style: TextStyle(fontSize: 20),),
      );
    }
    return Center(
      child: Image.file(
        selectedMedia!,
        width: 200,
      ),
    );
  }
  Widget _extractTextView(){
    if(selectedMedia==null){
      return const Center(
        child: Text("Ningún resultado",style: TextStyle(fontSize: 30),),
      );
    }
    return FutureBuilder(future: _extractText(selectedMedia!), builder: (context,snapshot){
      return Text(
        snapshot.data ?? "",
      style: const TextStyle(
        fontSize: 25,
        ),
      );
    });
  }
  Future<String?> _extractText(File file) async{
    final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin
    );
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }
}
