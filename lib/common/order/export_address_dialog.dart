import 'package:flutter/material.dart';
import 'package:lojavirtual/models/address.dart';

class ExportAddressDialog extends StatelessWidget {

  const ExportAddressDialog(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Text(
        '${address.street}, ${address.number} ${address.complement}\n'
        '${address.district}\n'
        '${address.city}/${address.state}\n'
        '${address.zipCode}',
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        FlatButton(
          onPressed: (){

          },
          child: const Text('Exportar'),
        )
      ],
    );
  }
}
