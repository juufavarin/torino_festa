import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:torino_festa/model/event.dart';

class EventItem extends StatelessWidget {
  final Event event;

  const EventItem({required this.event, super.key});

  // Função para abrir o link no navegador
  Future<void> _launchURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    String formattedDateRange =
        DateFormat('dd/MM/yyyy HH:mm').format(event.startDate) +
        ' - ' +
        DateFormat('HH:mm').format(event.endDate);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(formattedDateRange, style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          InkWell(
            onTap: () => _launchURL(event.link),
            child: Text(
              event.link,
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
