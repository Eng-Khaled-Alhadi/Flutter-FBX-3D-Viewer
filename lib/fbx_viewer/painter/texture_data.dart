import 'dart:io';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fbx3d_viewer/fbx_viewer/utils/utils.dart';

import 'package:image/image.dart' as IMG;

///
/// Created by Kozári László in 2020.01.06
/// lostinwar22@gmail.com
///

class TextureData {
  IMG.Image? imageIMG;
  UI.Image? imageUI;
  late int width;
  late int height;

  load(BuildContext context,String path, {int? resizeWidth}) async {
    ByteData? imageData;

    if (path.startsWith("assets/"))
      imageData = await rootBundle.load(path);
    else {
      final fileImg = File(path);
      if (await fileImg.exists()) {
        imageData = ByteData.view((await fileImg.readAsBytes()).buffer);
      }

    }

    if(imageData == null){
      return;
    }
    final buffer = imageData.buffer;
    final imageInBytes = buffer.asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);
    final image = IMG.decodeImage(imageInBytes);
    if(image == null) return;
    IMG.Image resized = IMG.copyResize(image, width: resizeWidth);

    imageIMG = resized;
    width = imageIMG!.width;
    height = imageIMG!.height;

    imageUI = await ImageLoader.loadImage(context, path);
  }

  IMG.Color map(double tu, double tv) {
    if (imageIMG == null) {
      return IMG.ColorUint4.rgb(24, 24, 24);
    }
    int u = ((tu * width).toInt() % width).abs();
    int v = ((tv * height).toInt() % height).abs();
    final List<num> l =imageIMG!.getPixelLinear(u, v).toList();
    return  IMG.ColorUint4.rgba(l[3].toInt(), l[2].toInt(), l[1].toInt(),l[0].toInt());
  }
}
