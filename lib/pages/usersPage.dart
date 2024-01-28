import 'package:chatify/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//Providers
import '../providers/authenticationProvider.dart';
import '../providers/usersPageProvider.dart';

//Widgets
import '../widgets/topBar.dart';
import '../widgets/customInputField.dart';
import '../widgets/customListViewTile.dart';
import '../widgets/customButton.dart';

//Models
import '../models/chatUser.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(
            _auth,
          ),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Users',
                primaryAction: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  onPressed: () {
                    _auth.logout();
                  },
                ),
              ),
              CustomTextField(
                onEditingComplete: (_value) {
                  _pageProvider.getUsers(name: _value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: _searchFieldTextEditingController,
                icon: Icons.search,
              ),
              _UsersList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _UsersList() {
    List<ChatUser>? _users = _pageProvider.users;

    if (_users != null) {
      if (_users.length != 0) {
        return Expanded(
          child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext _context, int _index) {
                return GestureDetector(
                  child: CustomListViewTile(
                    height: _deviceHeight * 0.10,
                    title: _users[_index].name,
                    subtitle: "Last Active: ${_users[_index].lastActive} ",
                    imagePath: _users[_index].image,
                    isActive: _users[_index].wasRecentlyActive(),
                    isSelected:
                        _pageProvider.selectedUsers.contains(_users[_index]),
                    onTap: () {},
                  ),
                  onTap: () {
                    _pageProvider.updateSelectedUsers(_users[_index]);
                  },
                );
              }),
        );
      } else {
        return Center(
          child: Text(
            "No Users Found.",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
  }

  Widget _createChatButton() {
    return Visibility(
        visible: _pageProvider.selectedUsers.isNotEmpty,
        child: CustomButton(
            text: _pageProvider.selectedUsers.length == 1
                ? "Chat With ${_pageProvider.selectedUsers.first.name}"
                : "Create Group chat",
            height: _deviceHeight * 0.08,
            width: _deviceWidth * 0.80,
            onPressed: () {
              _pageProvider.createChat();
            }));
  }
}
