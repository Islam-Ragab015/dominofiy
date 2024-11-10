import 'package:flutter/material.dart';
import 'package:dominoes_score_calc/presentation/pages/history_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScoreBoardPage extends StatefulWidget {
  const ScoreBoardPage({super.key});

  @override
  _ScoreBoardPageState createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends State<ScoreBoardPage> {
  int teamAScore = 0;
  int teamBScore = 0;
  int teamARounds = 0;
  int teamBRounds = 0;

  List<List<int>> teamAHistory = [];
  List<List<int>> teamBHistory = [];

  final _scoreControllerA = TextEditingController();
  final _scoreControllerB = TextEditingController();
  final _teamNameControllerA = TextEditingController(text: "راضي");
  final _teamNameControllerB = TextEditingController(text: "عيد");

  void _addScore(int score, bool isTeamA) {
    setState(() {
      if (isTeamA) {
        teamAScore += score;
        teamAHistory.add([score]);

        // Check if team A is about to win with no points for team B
        if (teamAScore >= 85 && teamAScore < 101 && teamBScore == 0) {
          _showDialog(
              "${_teamNameControllerA.text} قرب يكسب و ${_teamNameControllerB.text} مفيش عنده نقاط لسه");
        }

        // Check if team A wins the round while team B has no points
        if (teamAScore >= 101) {
          teamARounds++;
          if (teamBScore == 0) {
            _showDialog(
                "${_teamNameControllerA.text} كسب الجولة دي و ${_teamNameControllerB.text} طلع أبيض 😂");
          }
          teamAScore = 0;
          teamBScore = 0;
        }
      } else {
        teamBScore += score;
        teamBHistory.add([score]);

        // Check if team B is about to win with no points for team A
        if (teamBScore >= 85 && teamBScore < 101 && teamAScore == 0) {
          _showDialog(
              "${_teamNameControllerB.text} قرب يكسب و ${_teamNameControllerA.text} مفيش عنده نقاط لسه");
        }

        // Check if team B wins the round while team A has no points
        if (teamBScore >= 101) {
          teamBRounds++;
          if (teamAScore == 0) {
            _showDialog(
                "${_teamNameControllerB.text} كسب الجولة دي و ${_teamNameControllerA.text} طلع أبيض 😂");
          }
          teamAScore = 0;
          teamBScore = 0;
        }
      }
    });
  }

  void _undoLast(bool isTeamA) {
    setState(() {
      if (isTeamA && teamAHistory.isNotEmpty) {
        int lastScore = teamAHistory.last.first;
        if (teamAScore - lastScore >= 0) {
          teamAScore -= lastScore;
          teamAHistory.removeLast();
        }
      } else if (!isTeamA && teamBHistory.isNotEmpty) {
        int lastScore = teamBHistory.last.first;
        if (teamBScore - lastScore >= 0) {
          teamBScore -= lastScore;
          teamBHistory.removeLast();
        }
      }
    });
  }

  void _resetScores() {
    setState(() {
      teamAScore = 0;
      teamBScore = 0;
      teamARounds = 0;
      teamBRounds = 0;
      teamAHistory.clear();
      teamBHistory.clear();
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.tealAccent.shade400,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // New method to show a dialog instead of using a toast
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          elevation: 10,
          backgroundColor: Colors.teal.shade900, // Teal background color
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.tealAccent,
                  size: 40,
                ),
                const SizedBox(height: 20),
                const Text(
                  "خلي بالك",
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "تمام",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _teamNameInput(TextEditingController controller, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.tealAccent),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(8.0),
          ),
          textAlign: TextAlign.center,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _teamScoreCard(int score) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.tealAccent.shade400, Colors.tealAccent.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              ' :النتيجة',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundsCounter(String teamName, int rounds) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$rounds: الجولات ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addScoreSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _scoreInput(_scoreControllerA, true),
        _scoreInput(_scoreControllerB, false),
      ],
    );
  }

  Widget _scoreInput(TextEditingController controller, bool isTeamA) {
    return Column(
      children: [
        Container(
          width: 120,
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'ادخل النتيجة',
              labelStyle: TextStyle(color: Colors.tealAccent),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12.0),
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (controller.text.isEmpty) {
              _showError('من فضلك اكتب قيمة');
              return;
            }
            int? score = int.tryParse(controller.text);
            if (score == null || score <= 0) {
              _showError('من فضلك اكتب رقم أكبر من صفر');
              return;
            }
            _addScore(score, isTeamA);
            controller.clear();
          },
          icon: const Icon(Icons.add),
          label: const Text('ضيف'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _undoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _undoButton(true),
        _undoButton(false),
      ],
    );
  }

  Widget _undoButton(bool isTeamA) {
    return ElevatedButton.icon(
      onPressed: () {
        _undoLast(isTeamA);
      },
      icon: const Icon(Icons.undo),
      label: Text(isTeamA ? 'تراجع' : 'تراجع'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent.shade400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildResetButton(Size screenSize) {
    return Container(
      width: screenSize.width * 0.5,
      height: screenSize.height * 0.1,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: _resetScores,
        child: const Text(
          'إرجاع النقاط',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('نقاط الدومينو'),
        backgroundColor: Colors.tealAccent.shade400,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(
                    teamAHistory: teamAHistory,
                    teamBHistory: teamBHistory,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.02,
          horizontal: screenSize.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _teamNameInput(_teamNameControllerA, "اسم الفريق"),
                _teamNameInput(_teamNameControllerB, "اسم الفريق"),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _teamScoreCard(teamAScore),
                _teamScoreCard(teamBScore),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _roundsCounter(_teamNameControllerA.text, teamARounds),
                _roundsCounter(_teamNameControllerB.text, teamBRounds),
              ],
            ),
            const SizedBox(height: 10),
            _addScoreSection(),
            const SizedBox(height: 10),
            _undoSection(),
            const SizedBox(height: 20),
            _buildResetButton(screenSize),
          ],
        ),
      ),
    );
  }
}
