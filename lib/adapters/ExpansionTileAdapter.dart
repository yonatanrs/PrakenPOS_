import 'package:flutter/material.dart';
import 'package:flutter_scs/adapters/CartHistoryAdapter.dart';
import 'package:flutter_scs/models/AllTransaction.dart';

class ExpansionTileAdapter extends StatelessWidget {
  final AllTransaction models;
  ExpansionTileAdapter({required this.models});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<AllTransaction>(models),
      title: Text(models.date!),
      children: <Widget>[
        for (int counts = 0; counts < models.listTransaction!.length; counts++)
          CartHistoryAdapter(
            models: models.listTransaction![counts],
          ),
      ],
    );
  }
}
