// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:get_it/get_it.dart';
//
// //Providers
// import '../providers/authenticationProvider.dart';
//
// //Widgets
// import '../widgets/topBar.dart';
// import '../widgets/customInputField.dart';
// import '../widgets/customListViewTile.dart';
// import '../widgets/customButton.dart';
//
// //Models
// import '../models/chatUser.dart';
//
// class UsersPage extends StatefulWidget {
//   const UsersPage({super.key});
//
//   @override
//   State<UsersPage> createState() => _UsersPageState();
// }
//
// class _UsersPageState extends State<UsersPage> {
//   late double _deviceHeight;
//   late double _deviceWidth;
//
//   late AuthenticationProvider _auth;
//
//   final TextEditingController _searchFieldTextEditingController =
//       TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     _deviceHeight = MediaQuery.of(context).size.height;
//     _deviceWidth = MediaQuery.of(context).size.width;
//     _auth = Provider.of<AuthenticationProvider>(context);
//     return buildUI();
//   }
//
//   Widget buildUI() {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: _deviceWidth * 0.03,
//         vertical: _deviceHeight * 0.02,
//       ),
//       height: _deviceHeight * 0.98,
//       width: _deviceWidth * 0.97,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           TopBar(
//             'Users',
//             primaryAction: IconButton(
//               icon: const Icon(
//                 Icons.logout,
//                 color: Color.fromRGBO(0, 82, 218, 1.0),
//               ),
//               onPressed: () {},
//             ),
//           ),
//           CustomTextField(
//             onEditingComplete: (_value) {},
//             hintText: "Search...",
//             obscureText: false,
//             controller: _searchFieldTextEditingController,
//             icon: Icons.search,
//           ),
//         ],
//       ),
//     );
//   }
// }
