import 'package:flutter/material.dart';

class CardItem {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final Color switchColor;
  final Color switchBallColor;

  CardItem({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    required this.switchColor,
    required this.switchBallColor,
  });
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.cardItems,
  });

  final List<CardItem> cardItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(cardItems.length, (index) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.elliptical(50, 50)),
            child: Card(
              color: cardItems[index].backgroundColor,
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
                            cardItems[index].title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: cardItems[index].textColor,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            cardItems[index].subtitle,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: cardItems[index].textColor),
                          ),
                        ],
                      ),
                    ),
                    Transform.rotate(
                      angle: -1.5708, // 90 degrees in radians
                      child: GestureDetector(
                        onTap: () {
                          // Add your toggle switch logic here
                        },
                        child: Container(
                          width: 55.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            color: cardItems[index].switchColor,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: cardItems[index].switchBallColor,
                              width: 2.0,
                            ),
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                duration: Duration(milliseconds: 200),
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: BoxDecoration(
                                    color: cardItems[index].switchBallColor,
                                    borderRadius: BorderRadius.circular(13.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
