import 'package:flutter/material.dart';

class MenuAdd extends StatefulWidget {
  final String _title;
  final List<String> _list;
  MenuAdd({required String title, required List<String> list})
      : this._title = title,
        this._list = list;
  @override
  _MenuAddState createState() => _MenuAddState();
}

class _MenuAddState extends State<MenuAdd> {
  @override
  Widget build(BuildContext context) {
    final title = widget._title;
    final list = widget._list;
    final getDecoration = ({String? labelText}) => InputDecoration(
          labelText: labelText,
        );

    _buildList({required List<String> list}) {
      return list.asMap().entries.map((entry) {
        int index = entry.key;
        String illness = entry.value;
        return ListTile(
          title: Text(illness),
          leading: Icon(
            Icons.circle,
            size: 20,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              setState(() {
                list.removeAt(index);
              });
            },
          ),
        );
      }).toList();
    }

    final inputController = TextEditingController();

    _handleAddItem() {
      String newValue = inputController.value.text;
      if (newValue.isNotEmpty)
        setState(() {
          list.add(newValue);
          inputController.clear();
        });
    }

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: inputController,
                onFieldSubmitted: (value) {
                  _handleAddItem();
                },
                decoration: getDecoration(labelText: title),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _handleAddItem,
            ),
          ],
        ),
        ..._buildList(list: list)
      ],
    );
  }
}
