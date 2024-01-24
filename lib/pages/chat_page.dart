//packages
import 'package:chatify/providers/authenticationProvider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//widgets
import '../widgets/topBar.dart';
import '../widgets/customListViewTile.dart';
import '../widgets/customInputField.dart';

//models
import '../models/chat.dart';
import '../models/chatMessage.dart';

//providers
import '../providers/chatsPageProvider.dart';
import '../providers/chatPageProvider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({required this.chat, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
              this.widget.chat.uid, _auth, _messagesListViewController),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<ChatPageProvider>();

        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.03,
                vertical: deviceHeight * 0.02,
              ),
              height: deviceHeight,
              width: deviceWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    this.widget.chat.title(),
                    fontSize: 10,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                      onPressed: () {
                        _pageProvider.deleteChat();
                      },
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                      onPressed: () {
                        _pageProvider.goBack();
                      },
                    ),
                  ),
                  _messagesListview(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListview() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages?.length != 0) {
        return Container(
          height: deviceHeight * 0.74,
          child: ListView.builder(
            controller: _messagesListViewController,
              itemCount: _pageProvider.messages?.length,
              itemBuilder: (BuildContext _context, int _index) {
                ChatMessage _message = _pageProvider.messages![_index];
                bool _isOwnMessage = _message.senderId == _auth.user!.uid;
                return Container(
                    child: CustomChatListViewTile(
                  deviceHeight: deviceHeight,
                  width: deviceWidth * 0.80,
                  message: _message,
                  isOwnMessage: _isOwnMessage,
                  sender: this
                      .widget
                      .chat
                      .members
                      .where((_m) => _m.uid == _message.senderId)
                      .first,
                ));
              }),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            'Be the first to say Hi!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: deviceWidth * 0.60,
      child: CustomInputField(
        onSaved: (_value) {
          _pageProvider.message = _value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: "Type a message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if(_messageFormState.currentState!.validate()){
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 82, 218, 1.0),
        child: const Icon(Icons.camera_enhance),
        onPressed: (){
          _pageProvider.sentImageMessage();
        },
      ),
    );
  }
}
