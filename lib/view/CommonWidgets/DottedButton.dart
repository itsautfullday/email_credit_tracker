import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

//TODO : Add the other requirements of this class!
class DottedButton extends StatelessWidget {
  static const int ONLY_TEXT = 0;
  static const int ONLY_IMAGE =
      1; //TODO : Build when making the transactions screen
  static const int IMAGE_LEFT_TEXT_RIGHT =
      2; //TODO : Build when adding google image to introduction button
  static const int TEXT_LEFT_IMAGE_RIGHT = 3; //TODO : Build when required

  Image? image;
  String? text;
  VoidCallback? onPressed;

  DottedButton({this.image = null, this.text = null, this.onPressed = null}) {
    if (this.image == null && this.text == null) {
      throw Exception("Dotted border created with no text and no image");
    }

    if (this.onPressed == null) {
      throw Exception("No on pressed function has been passed");
    }
  }
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        dashPattern: [6, 3, 2, 3],
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        child: TextButton(
            onPressed: onPressed,
            child:
                Text(this.text!, style: Theme.of(context).textTheme.bodyMedium),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(12)))))));
  }
}
