import 'package:come491_cattle_market/constants.dart';
import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String butonText;
  final Color butonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget butonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {Key key,
      @required this.butonText,
      this.butonColor: kPrimaryColor,
      this.textColor: Colors.white,
      this.radius: 28,
      this.yukseklik: 40,
      this.butonIcon,
      @required this.onPressed})
      : assert(butonText != null, onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: yukseklik,
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: yukseklik,
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: butonColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Spreads, Collection-if, Collection-For
              if (butonIcon != null) ...[
                butonIcon,
                Text(
                  butonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Muli',
                    color: textColor,
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Opacity(opacity: 0, child: butonIcon)
              ],
              if (butonIcon == null) ...[
                Container(),
                Text(
                  butonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textColor, fontSize: 24, fontFamily: 'Muli'),
                ),
                Container(),
              ]
            ],
          ),
          color: kLogoColor,
        ),
      ),
    );
  }
}
