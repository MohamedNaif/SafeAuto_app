import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardItem {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final Color switchColor;
  final Color switchBallColor;
  final bool isSwitchOn;
  void Function(bool)? onChange;

  CardItem({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    required this.switchColor,
    required this.switchBallColor,
    required this.isSwitchOn,
    required this.onChange,
  });
}

class CardWidget extends StatefulWidget {
  const CardWidget({
    super.key,
    required this.cardItems,
  });

  final List<CardItem> cardItems;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  // void powerSwitchChanged(bool value, int index) {
  //   setState(() {
  //     widget.cardItems[index] = value as CardItem;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(widget.cardItems.length, (
          index,
        ) {
          
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.elliptical(50, 50)),
            child: Card(
              color: widget.cardItems[index].backgroundColor,
              margin: EdgeInsets.all(16.0),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.cardItems[index].title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: widget.cardItems[index].textColor,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            widget.cardItems[index].subtitle,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: widget.cardItems[index].textColor),
                          ),
                        ],
                      ),
                    ),
                    Transform.rotate(
                      angle: -pi / 2, // 90 degrees in radians
                      child: CupertinoSwitch(
                        value: widget.cardItems[index].isSwitchOn,
                        onChanged: widget.cardItems[index].onChange,
                        activeColor: widget.cardItems[index].switchBallColor,
                        // activeTrackColor: widget.cardItems[index].switchColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
