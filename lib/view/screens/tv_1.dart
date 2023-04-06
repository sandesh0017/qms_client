// import 'package:flutter/material.dart';
// import 'package:qms_client/core/constants/colors.dart';

// class SingleDisplayScreen extends StatefulWidget {
//   const SingleDisplayScreen({super.key});

//   @override
//   State<SingleDisplayScreen> createState() => SingleDisplayScreenState();
// }

// class SingleDisplayScreenState extends State<SingleDisplayScreen> {
//   Color primaryColor = const Color.fromARGB(255, 14, 75, 124);
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Stack(children: [
//         Column(
//           children: [
//             Container(
//                 height: height * 0.2,
//                 color: primaryColor,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Image.asset(
//                         'assets/images/logo2.png',
//                         scale: 1,
//                       ),
//                     ),
//                     titleText(title: 'COUNTER'),
//                     titleText(title: 'TOKEN'),
//                     Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Image.asset(
//                         'assets/images/logo1.png',
//                         scale: 1,
//                       ),
//                     ),
//                   ],
//                 )),
//             SizedBox(
//               height: height * 0.2,
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 titleText(title: '09', color: Colors.red, fontSize: 200),
//                 titleText(title: 'AA05', color: Colors.red, fontSize: 200),
//               ],
//             )
//           ],
//         ),
//         CustomPaint(
//           isComplex: true,
//           willChange: true,
//           painter: PathPainter(
//             color: primaryColor,
//             path:
//                 drawPath(x1: width * 0.57, y1: 0, x2: width * 0.35, y2: height),
//           ),
//         ),
//         CustomPaint(
//           isComplex: true,
//           willChange: true,
//           painter: PathPainter(
//             color: Colors.white,
//             path: drawPath(
//                 x1: width * 0.57, y1: 0, x2: width * 0.5259, y2: height * 0.2),
//           ),
//         ),
//         Positioned(
//             right: 0,
//             bottom: 0,
//             child: Container(
//               height: 150,
//               width: 480,
//               decoration: const BoxDecoration(
//                   border: Border(left: BorderSide(), top: BorderSide())),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     '''प्रदेश सरकार
// भौतिक पूर्वाधार विकास मन्त्रालय
// यातायात व्यवस्था कार्यालय
// सवारी चालक अनुमतिपत्र
// पोखरा, कास्की जिल्ला, गण्डकी प्रदेश, नेपाल''',
//                     style:
//                         TextStyle(color: AppColor.primaryColor, fontSize: 20),
//                     textAlign: TextAlign.center,
//                   ),
//                   Image.asset(
//                     'assets/animations/flag.gif',
//                     scale: 1.5,
//                   )
//                 ],
//               ),
//             )),
//         Positioned(
//             left: 0,
//             bottom: 0,
//             child: Container(
//                 height: 150,
//                 // color: Colors.amber,
//                 padding: const EdgeInsetsDirectional.all(1),
//                 child: Image.asset('assets/images/qlogo.png')))
//       ]),
//     );
//   }

//   Expanded titleText({String? title, Color? color, double? fontSize}) =>
//       Expanded(
//           flex: 2,
//           child: Center(
//               child: Text(
//             title ?? 'N/A',
//             style: TextStyle(
//                 color: color ?? Colors.white, fontSize: fontSize ?? 50),
//           )));

//   Path drawPath({
//     double? x1,
//     double? y1,
//     double? x2,
//     double? y2,
//   }) {
//     final path = Path();
//     path.moveTo(x1!, y1!);
//     path.lineTo(x2!, y2!);
//     return path;
//   }
// }

// class PathPainter extends CustomPainter {
//   Path path;
//   Color color;
//   PathPainter({
//     required this.path,
//     required this.color,
//   });
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 10.0;
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
