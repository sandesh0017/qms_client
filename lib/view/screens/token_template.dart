import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TokenTemplate extends StatefulWidget {
  const TokenTemplate({super.key});

  @override
  State<TokenTemplate> createState() => _TokenTemplateState();
}

class _TokenTemplateState extends State<TokenTemplate> {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat xdate = DateFormat('yyyy-MM-dd');
    final String date = xdate.format(now);
    String time = DateFormat("hh:mm:ss").format(now);
    return Container(
      child: Column(
        children: [
          const Text('''यातायात व्यवस्था कार्यालय\n
सवारी चालक अनुमतिपत्र'''),
          const Text('''पोखरा, गण्डकी प्रदेश, नेपाल
'''),
          Text('DateTime : $date $time'),
          const Text('तपाईंको टोकन नम्बर'),
          const Text('CS-102'),
          const Text('Cash'),
          const Text('धन्यवाद !!!'),
        ],
      ),
    );
  }
}
