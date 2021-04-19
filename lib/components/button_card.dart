import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  final void Function() _onTap;
  final String _label;
  final IconData _icon;
  ButtonCard(
      {required IconData icon,
      required String label,
      required void Function() onTap})
      : this._icon = icon,
        this._onTap = onTap,
        this._label = label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              _icon,
              color: Colors.white,
              size: 42,
            ),
            Text(
              _label,
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
