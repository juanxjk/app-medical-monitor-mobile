import 'package:app_medical_monitor/components/search_form.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/user_service.dart';
import 'package:app_medical_monitor/views/user_add_view.dart';
import 'package:app_medical_monitor/views/user_view.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatefulWidget {
  final User _loggedUser;
  UsersListView(this._loggedUser, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  bool _hasMore = true;
  int _pageNumber = 1;
  bool _hasError = false;
  bool _isLoading = true;
  final int _defaultUsersPerPageCount = 10;
  List<User> _users = [];
  final int _nextPageThreshold = 1;

  bool _isSearching = false;
  String _searchText = "";

  void _handleSearch() {
    if (_isSearching) _resetState();
    setState(() {
      _isSearching = true;
    });
  }

  void _handleAbortSearch() {
    setState(() {
      _searchText = "";
      _isSearching = false;
      _resetState();
    });
  }

  void _handleOnChange(String value) {
    setState(() {
      _searchText = value;
    });
  }

  Future<void> _fetchListUsers() async {
    try {
      final String token = widget._loggedUser.session!.token;

      final List<User> fetchUsers = await UserService(token: token).findAll(
          page: _pageNumber,
          size: _defaultUsersPerPageCount,
          name: _searchText);
      setState(() {
        _hasMore = fetchUsers.length == _defaultUsersPerPageCount;
        _isLoading = false;
        _pageNumber = _pageNumber + 1;
        _users.addAll(fetchUsers);
      });
    } catch (err, stack) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void Function() _handleNavigateUserView(User user) => () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserView(widget._loggedUser, user),
        ),
      ).then((value) => _resetState());

  void _handleNavigateUserAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAddView(widget._loggedUser),
      ),
    ).then((value) => _resetState());
  }

  Widget _buildUserItem(User user) => Card(
        color: Colors.blue.shade500,
        child: ListTile(
          onTap: _handleNavigateUserView(user),
          leading: Icon(Icons.person),
          title: Text(
            user.fullName,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "Função: ${user.role.displayName}",
            style: TextStyle(color: Colors.white60),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
      );

  late final _error = Center(
      child: InkWell(
    onTap: _resetState,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text("Ocorreu um erro, pressione para tentar novamente"),
    ),
  ));

  late final _notFound = Center(
    child: InkWell(
      onTap: _resetState,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text("Nenhum usuário encontrado, pressione para atualizar"),
      ),
    ),
  );

  final _loading = Center(
      child: Padding(
    padding: const EdgeInsets.all(8),
    child: CircularProgressIndicator(),
  ));

  Widget _getBody() {
    if (_users.isEmpty) {
      if (_isLoading) return _loading;
      if (_hasError) return _error;
      return _notFound;
    } else {
      return ListView.builder(
          itemCount: _users.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (_hasMore && index == _users.length - _nextPageThreshold) {
              _fetchListUsers();
            }
            if (index == _users.length) {
              if (_hasError)
                return _error;
              else
                return _loading;
            }
            final User user = _users[index];
            return _buildUserItem(user);
          });
    }
  }

  Future<void> _resetState() async {
    _hasMore = true;
    _pageNumber = 1;
    _hasError = false;
    _isLoading = true;
    _users = [];
    _fetchListUsers();
  }

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? SearchForm(
                searchTitle: "nome",
                onAbortSearch: _handleAbortSearch,
                onSearch: _handleSearch,
                onChanged: _handleOnChange,
              )
            : Text(
                "Usuários ${_hasMore ? "(${_users.length}...)" : "(${_users.length})"}"),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: _handleSearch)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleNavigateUserAdd,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
        ),
      ),
      body: RefreshIndicator(onRefresh: _resetState, child: _getBody()),
    );
  }
}
