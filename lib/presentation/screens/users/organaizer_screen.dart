import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizerScreen extends StatefulWidget {
  const OrganizerScreen({super.key});

  @override
  _OrganizerScreenState createState() => _OrganizerScreenState();
}

class _OrganizerScreenState extends State<OrganizerScreen> {
  late Future<Map<String, int>> _data;

  Future<Map<String, int>> getRegisteredData() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('stringRegisteredData');

    if (cachedData != null) {
      Map<String, dynamic> jsonData = jsonDecode(cachedData);
      return jsonData.map((key, value) => MapEntry(key, value as int));
    } else {
      throw Exception("No hay datos almacenados.");
    }
  }

  @override
  void initState() {
    super.initState();
    
    _data = getRegisteredData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF001D3D),
          title: const Text(
            'Estadísticas de Eventos',
            style: TextStyle(
              color: Color(0xFFFFC300),
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, int>>(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final dataMap = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Participación en Eventos',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value >= 0 && value < dataMap.length) {
                                    return Text(
                                      dataMap.keys.elementAt(value.toInt()),
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: dataMap.entries
                              .toList()
                              .asMap()
                              .map((index, entry) => MapEntry(
                                    index,
                                    BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value.toDouble(),
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ))
                              .values
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No hay datos disponibles.'));
              }
            },
          ),
        ));
  }
  
  
}
