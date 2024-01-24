import 'package:chatify/models/chatUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//pages
import '../pages/chat_page.dart';

//providers
import '../providers/authenticationProvider.dart';
import '../providers/chatsPageProvider.dart';

//services
import '../services/navigationService.dart';

//widgets
import '../widgets/topBar.dart';
import '../widgets/customListViewTile.dart';

//Models
import '../models/chat.dart';
import '../models/chatUser.dart';
import '../models/chatMessage.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late NavigationService _navigation;
  late ChatsPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
            create: (_) => ChatsPageProvider(auth)),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<ChatsPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Chats',
                primaryAction: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  onPressed: () {
                    auth.logout();
                  },
                ),
              ),
              _chatsList(),
            ],
          ),
        );
      },
    );
  }

  Widget _chatsList() {
    List<Chat>? _chats = _pageProvider.chats;
    print(_chats);

    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.length != 0) {
            return ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (BuildContext _context, int _index) {
                  return _chatTile(_chats[_index]);
                });
          } else {
            return const Center(
                child: Text(
              'No chats found.',
              style: TextStyle(color: Colors.white),
            ));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subtitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.last.type != MessageType.TEXT
          ? "MediaAttachment"
          : _chat.messages.last.content;
    }

    return CustomListViewTileWithActivity(
      height: deviceHeight * 0.10,
      title: _chat.title(),
      subtitle: _subtitleText,
      imagePath: _chat.imageURL(),
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigation.navigateToPage(
          ChatPage(chat: _chat),
        );
      },
    );
  }
}
