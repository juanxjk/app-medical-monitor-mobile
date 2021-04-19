import 'package:flutter/material.dart';

class SearchForm extends StatefulWidget {
  String _searchTitle;
  final void Function() _handleAbortSearch;
  final void Function() _handleSearch;
  final void Function(String) _handleOnChanged;

  SearchForm({
    String? searchTitle,
    required void Function() onAbortSearch,
    required void Function() onSearch,
    required void Function(String searchValue) onChanged,
  })   : this._searchTitle = searchTitle ?? "",
        this._handleAbortSearch = onAbortSearch,
        this._handleSearch = onSearch,
        this._handleOnChanged = onChanged;
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Buscar por ${widget._searchTitle}...",
        hintStyle: TextStyle(color: Colors.white54),
        suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: widget._handleAbortSearch),
      ),
      onSubmitted: (value) => widget._handleSearch(),
      onChanged: widget._handleOnChanged,
      textInputAction: TextInputAction.done,
    );
  }
}
