import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Grid extends StatelessWidget {
  List area = [
    "Casa",
    "Alimentação",
    "Saúde",
    "Transportes",
    "Presentes",
    "Outros"
  ];

  List cor = [
    Color.fromARGB(206, 86, 231, 91),
    Color.fromARGB(255, 230, 146, 227),
    Color.fromARGB(255, 91, 155, 207),
    Color.fromARGB(214, 230, 97, 87),
    Color.fromARGB(172, 32, 216, 240),
    Color.fromARGB(207, 247, 169, 53),
  ];

  List icones = [
    Icons.home,
    Icons.local_pizza,
    Icons.health_and_safety,
    Icons.emoji_transportation,
    Icons.card_giftcard_sharp,
    Icons.add,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        width: double.infinity,
        height: 300,
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: area.length,
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(100, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: cor[index],
                  foregroundColor: Colors.white),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icones[index],
                      size: 40,
                    ),
                    Text(
                      "${area[index]}",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
