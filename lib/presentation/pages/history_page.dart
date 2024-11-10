import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<List<int>> teamAHistory;
  final List<List<int>> teamBHistory;

  const HistoryPage({
    super.key,
    required this.teamAHistory,
    required this.teamBHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score History'),
        backgroundColor: Colors.tealAccent.shade400,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScoreSection('Team A Scores:', teamAHistory),
            const SizedBox(height: 20),
            _buildScoreSection('Team B Scores:', teamBHistory),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection(String title, List<List<int>> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                title: Text(
                  'Round ${index + 1}: ${history[index].first}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                tileColor: Colors.tealAccent.shade100,
                contentPadding: const EdgeInsets.all(10),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            );
          },
        ),
      ],
    );
  }
}
