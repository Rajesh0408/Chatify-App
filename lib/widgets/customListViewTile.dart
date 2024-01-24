//packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//Widgets
import '../widgets/roundedImage.dart';
import '../widgets/messageBubbles.dart';

//Models
import '../models/chatMessage.dart';
import '../models/chatUser.dart';

class CustomListViewTileWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

  const CustomListViewTileWithActivity(
      {super.key,
      required this.height,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.isActive,
      required this.isActivity,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => onTap(),
        minVerticalPadding: height * 0.20,
        leading: RoundedImageNetworkWithStatusIndicator(
          key: UniqueKey(),
          size: height / 2,
          imagePath: imagePath,
          isActive: isActive,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: isActivity
            ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                      color: Colors.white54, size: height * 0.10),
                ],
              )
            : Text(
                subtitle,
                style: const TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ));
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;

  const CustomChatListViewTile(
      {required this.deviceHeight,
      required this.width,
      required this.isOwnMessage,
      required this.message,
      required this.sender,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                  key: UniqueKey(),
                  imagePath: sender.image,
                  size: width * 0.08,
                )
              : Container(),
          SizedBox(
            width: width * 0.05,
          ),
          message.type == MessageType.TEXT
              ? TextMessageBubbles(
                  isOwnMessage: isOwnMessage,
                  message: message,
                  width: width,
                  height: deviceHeight * 0.06,
                )
              : ImageMessageBubbles(
                  message: message,
                  width: width * 0.55,
                  height: deviceHeight * 0.30,
                  isOwnMessage: isOwnMessage),
        ],
      ),
    );
  }
}
