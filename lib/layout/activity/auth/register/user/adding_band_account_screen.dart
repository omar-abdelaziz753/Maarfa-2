// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:my_academy/res/drawable/icon/icons.dart';
// import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
// import 'package:my_academy/widget/buttons/master/master_button.dart';
// import 'package:my_academy/widget/side_padding/side_padding.dart';
// import 'package:my_academy/widget/space/space.dart';
// import 'package:my_academy/widget/textfield/master/master2_textfiled.dart';

// class AddingBankAccount extends StatelessWidget {
//   const AddingBankAccount({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: DefaultAppBar(title: tr("add_bank")),
//       body: SidePadding(
//         sidePadding: 30,
//         child: ListView(
//           children: [
//             const Master2TextField(hintText: "SWIFT Code"),
//             const Space(
//               boxHeight: 15,
//             ),
//             Master2TextField(hintText: tr("bank_name")),
//             const Space(
//               boxHeight: 15,
//             ),
//             const Master2TextField(hintText: "IBAN"),
//             const Space(
//               boxHeight: 15,
//             ),
//             Master2TextField(hintText: tr("address")),
//             const Space(
//               boxHeight: 15,
//             ),
//             Master2TextField(
//               hintText: tr("city"),
//               suffixIcon: angleRight,
//             ),
//             const Space(boxHeight: 200),
//             MasterButton(
//               buttonText: tr("add"),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
