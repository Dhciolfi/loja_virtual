import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/checkout/components/card_back.dart';
import 'package:lojavirtual/screens/checkout/components/card_front.dart';

class CreditCardWidget extends StatelessWidget {

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlipCard(
            key: cardKey,
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            flipOnTouch: false,
            front: CardFront(),
            back: CardBack(),
          ),
          FlatButton(
            onPressed: (){
              cardKey.currentState.toggleCard();
            },
            textColor: Colors.white,
            padding: EdgeInsets.zero,
            child: const Text('Virar cartão'),
          )
        ],
      ),
    );
  }
}
