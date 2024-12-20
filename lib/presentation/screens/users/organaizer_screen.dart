import 'dart:convert';

import 'package:eventify_flutter/models/category.dart';
import 'package:eventify_flutter/providers/event_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizerScreen extends StatefulWidget {
  const OrganizerScreen({super.key});

  @override
  _OrganizerScreenState createState() => _OrganizerScreenState();
}

class _OrganizerScreenState extends State<OrganizerScreen> {
  Map<String, int> dataMap = {};
  String? _selectedCategory;
  Future<List<Category>>? _categories;
  EventServices eventServices = new EventServices();

  Future<Map<String, int>> getRegisteredData(String? categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    String? stringRegisteredCounts = prefs.getString('stringRegisteredCounts');

    if (stringRegisteredCounts != null) {
      Map<String, dynamic> tempMap = jsonDecode(stringRegisteredCounts);
      Map<int, int> registeredCounts = Map<int, int>.from(
          tempMap.map((key, value) => MapEntry(int.parse(key), value as int)));

      return await eventServices.fetchRegisteredCountByMonth(
        registeredCounts,
        categoryId,
      );
    } else {
      throw Exception("No hay datos almacenados.");
    }
  }

  Future<void> updateData(String? categoryName) async {
    Map<String, int> updatedData = await getRegisteredData(categoryName);
    setState(() {
      dataMap = updatedData;
      _selectedCategory = categoryName;
    });
  }

  @override
  void initState() {
    super.initState();

    _categories = eventServices.fetchCategories();
    updateData(null);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                FutureBuilder<List<Category>>(
                  future: _categories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final categories = snapshot.data!;
                      return DropdownButton<String>(
                        value: _selectedCategory,
                        hint: const Text('Selecciona una categoría'),
                        items: categories
                            .map((category) => DropdownMenuItem(
                                  value: category.name,
                                  child: Text(category.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            updateData(value);
                          }
                        },
                      );
                    } else {
                      return const Text('No hay categorías disponibles.');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    updateData(null);
                  },
                ),
              ]),
              FutureBuilder<Map<String, int>>(
                future: Future.value(dataMap),
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
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 400,
                            child: BarChart(
                              BarChartData(
                                gridData: FlGridData(
                                    show: true,
                                    getDrawingHorizontalLine: (value) {
                                      return const FlLine(
                                        color: Colors.black,
                                        strokeWidth: 1,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return const FlLine(
                                        color: Colors.black,
                                        strokeWidth: 1,
                                      );
                                    }),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value >= 0 &&
                                            value < dataMap.length) {
                                          return Text(
                                            dataMap.keys
                                                .elementAt(value.toInt()),
                                            style:
                                                const TextStyle(fontSize: 10),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value % 1 == 0) {
                                          return Text(
                                            value.toString(),
                                            style:
                                                const TextStyle(fontSize: 10),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
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
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                        child: Text('No hay datos disponibles.'));
                  }
                },
              ),
            ],
          ),
        ));
  }
}
