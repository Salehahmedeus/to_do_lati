import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({super.key, required this.Text, required this.onTap, required this.icon});
  final String Text;
  final Function onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}