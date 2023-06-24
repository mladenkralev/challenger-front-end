import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OccurrenceSwitcher extends StatelessWidget {
  final String title;
  final bool isForList;

  const OccurrenceSwitcher({required Key key, required this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.0,
      child: isForList ? _buildSelectionOptions() : _buildCard()
    );
  }

  Widget _buildCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          buildItem(),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.arrow_drop_down),
          )
        ],
      ),
    );
  }

  Widget _buildSelectionOptions() {
    return Padding(child: buildItem(), padding: EdgeInsets.all(10.0));
  }

  buildItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
      child: Container(
        width: 100,
        alignment: Alignment.center,
        child: Text(title),
      ),
    );
  }
}