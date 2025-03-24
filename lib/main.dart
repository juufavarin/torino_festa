import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:torino_festa/model/event.dart';
import 'package:geodesy/geodesy.dart';
import 'package:torino_festa/ui/event_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torino Festa via',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 241, 246, 91),
        ),
      ),
      home: const MyHomePage(title: 'Torino Festa via'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController controller = MapController();
  List<Event>? events;
  Event? selectedEVent;

  final double zoom = 15;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    LatLng? centerPoint;
    LatLng? initialPoint;
    LatLng? endPoint;

    if (selectedEVent != null) {
      initialPoint = LatLng(
        double.parse(selectedEVent!.latInitial),
        double.parse(selectedEVent!.longInitial),
      );

      endPoint = LatLng(
        double.parse(selectedEVent!.latEnd),
        double.parse(selectedEVent!.longEnd),
      );

      centerPoint = Geodesy().midPointBetweenTwoGeoPoints(
        initialPoint,
        endPoint,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:
          events == null
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 2,
                      child: ListView.builder(
                        itemCount: events!.length,
                        itemBuilder: (context, index) {
                          Event event = events![index];
                          return GestureDetector(
                            onTap: () {
                              initialPoint = LatLng(
                                double.parse(event.latInitial),
                                double.parse(event.longInitial),
                              );

                              endPoint = LatLng(
                                double.parse(event.latEnd),
                                double.parse(event.longEnd),
                              );

                              centerPoint = Geodesy()
                                  .midPointBetweenTwoGeoPoints(
                                    initialPoint!,
                                    endPoint!,
                                  );
                              controller.move(centerPoint!, zoom);
                              setState(() {
                                selectedEVent = event;
                              });
                            },

                            child: EventItem(event: event),
                          );

                        
                        },
                      ),
                    ),
                    Container(
                      width: screenWidth / 2,
                      height: screenHeight,
                      child: FlutterMap(
                        mapController: controller,
                        options: MapOptions(
                          maxZoom: 100,
                          minZoom: 10,
                          initialZoom: zoom,
                          initialCenter: LatLng(45.064038, 7.679946),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          initialPoint != null
                              ? PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: [initialPoint!, endPoint!],
                                    strokeWidth: 4.0,
                                    color: Colors.blue,
                                  ),
                                ],
                              )
                              : SizedBox.shrink(),
                          initialPoint != null
                              ? MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: initialPoint!,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40.0,
                                    ),
                                  ),
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: endPoint!,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40.0,
                                    ),
                                  ),
                                ],
                              )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Future<void> loadEvents() async {
    String jsonString = await rootBundle.loadString('assets/data/data.json');
    final decodedString = json.decode(jsonString);

    setState(() {
      events =
          (decodedString['event'] as List)
              .map((eventData) => Event.fromJson(eventData))
              .toList();
      events!.sort((a, b) => a.startDate.compareTo(b.startDate));
    });
  }
}
