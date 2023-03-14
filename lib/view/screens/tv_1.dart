// import 'package:flutter/material.dart';

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
//                     titleText(title: 'COUNTER'),
//                     titleText(title: 'TOKEN'),
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
