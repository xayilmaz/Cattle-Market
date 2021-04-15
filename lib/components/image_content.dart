import 'package:flutter/material.dart';


class ImageContent extends StatelessWidget {
  const ImageContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(image,width: 250,height: 250,),
      ],
    );
  }
}