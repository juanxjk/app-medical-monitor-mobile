import 'package:flutter/material.dart';

class MenuAdd extends StatefulWidget {
  final String _title;
  final List<String> _list;
  final Color _color;
  final Widget? _leading;

  MenuAdd(
      {required String title,
      required List<String> list,
      Color color = Colors.blue,
      Widget? leading})
      : this._title = title,
        this._list = list,
        this._color = color,
        this._leading = leading;
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
            Icons.label,
            size: 25,
            color: widget._color,
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

    final leading = widget._leading != null
        ? Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: widget._leading,
          )
        : SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            leading,
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
