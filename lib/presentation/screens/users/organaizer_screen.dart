import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OrganizerScreen extends StatefulWidget {
  final Map<String, int> data;

  const OrganizerScreen({super.key, required this.data});

  @override
  _OrganizerScreenState createState() => _OrganizerScreenState();
}

class _OrganizerScreenState extends State<OrganizerScreen> {
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
                  titlesData: const FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.from(widget.data.entries)
            .asMap()
            .map((index, entry) => MapEntry(
                  index,
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.toDouble(),
                        color: Color(Colors.blue as int)
                        )
                    ],
                  ),
                ))
            .values
            .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}