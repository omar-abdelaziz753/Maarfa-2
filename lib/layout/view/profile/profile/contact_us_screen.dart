// import 'package:flutter/material.dart';

// class ContactUsScreen extends StatefulWidget {
//   @override
//   _ContactUsScreenState createState() => _ContactUsScreenState();
// }

// class _ContactUsScreenState extends State<ContactUsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F5F5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 // Header Section
//                 Container(
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         'تواصل معنا',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF333333),
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         'هل تريد استشارة؟ مرحباً هنا أنتظرك',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF666666),
//                         ),
//                         textAlign: TextAlign.right,
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: 30),

//                 // Contact Info Section
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'info@maarefa.app',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Color(0xFF333333),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Icon(
//                             Icons.email_outlined,
//                             size: 20,
//                             color: Color(0xFF666666),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'المملكة العربية السعودية',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Color(0xFF333333),
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Icon(
//                             Icons.location_on_outlined,
//                             size: 20,
//                             color: Color(0xFF666666),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15),
//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Color(0xFFDDDDDD)),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           'راسلنا عبر البريد الإلكتروني',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Color(0xFF666666),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: 30),

//                 // Contact Form
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       // First Row - First Name and Last Name
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'الاسم الأول',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color(0xFF333333),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 TextFormField(
//                                   controller: _firstNameController,
//                                   textAlign: TextAlign.right,
//                                   decoration: InputDecoration(
//                                     hintText: 'أدخل الاسم الأول الخاص بك هنا',
//                                     hintStyle: TextStyle(
//                                       fontSize: 12,
//                                       color: Color(0xFF999999),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFDDDDDD)),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFDDDDDD)),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFB8860B)),
//                                     ),
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 15, vertical: 12),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'اسم العائلة',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color(0xFF333333),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 TextFormField(
//                                   controller: _lastNameController,
//                                   textAlign: TextAlign.right,
//                                   decoration: InputDecoration(
//                                     hintText: 'أدخل اسم العائلة الخاص بك هنا',
//                                     hintStyle: TextStyle(
//                                       fontSize: 12,
//                                       color: Color(0xFF999999),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFDDDDDD)),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFDDDDDD)),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFB8860B)),
//                                     ),
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 15, vertical: 12),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 20),

//                       // Second Row - Email and Phone
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'البريد الإلكتروني',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color(0xFF333333),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 TextFormField(
//                                   controller: _emailController,
//                                   textAlign: TextAlign.right,
//                                   decoration: InputDecoration(
//                                     hintText: 'أدخل بريدك الإلكتروني',
//                                     hintStyle: TextStyle(
//                                       fontSize: 12,
//                                       color: Color(0xFF999999),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFDDDDDD)),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFDDDDDD)),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFB8860B)),
//                                     ),
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 15, vertical: 12),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'رقم الجوال',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Color(0xFF333333),
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 TextFormField(
//                                   controller: _phoneController,
//                                   textAlign: TextAlign.right,
//                                   decoration: InputDecoration(
//                                     hintText: 'أدخل رقم الجوال',
//                                     hintStyle: TextStyle(
//                                       fontSize: 12,
//                                       color: Color(0xFF999999),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFDDDDDD)),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFDDDDDD)),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide:
//                                           BorderSide(color: Color(0xFFB8860B)),
//                                     ),
//                                     contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 15, vertical: 12),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 20),

//                       // Message Field
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             'الرسالة',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF333333),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           TextFormField(
//                             controller: _messageController,
//                             textAlign: TextAlign.right,
//                             maxLines: 6,
//                             decoration: InputDecoration(
//                               hintText: 'أدخل رسالتك هنا',
//                               hintStyle: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF999999),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide:
//                                     BorderSide(color: Color(0xFFDDDDDD)),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide:
//                                     BorderSide(color: Color(0xFFDDDDDD)),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide:
//                                     BorderSide(color: Color(0xFFB8860B)),
//                               ),
//                               contentPadding: EdgeInsets.all(15),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please fill out this field.';
//                               }
//                               return null;
//                             },
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 30),

//                       // Submit Button
//                       Container(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               // Handle form submission
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('تم إرسال الرسالة بنجاح!'),
//                                   backgroundColor: Color(0xFFB8860B),
//                                 ),
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFFB8860B),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             elevation: 2,
//                           ),
//                           child: Text(
//                             'إرسال الرسالة',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }
// }
