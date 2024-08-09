import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:despesas/screens/TelaGrafico.dart';
import 'package:despesas/database/dao/despesasdao.dart';

class TelaCalendario extends StatefulWidget {
  @override
  _TelaCalendarioState createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Future<List<Map<String, dynamic>>>? _despesasFuture;
    Map icones = {
    "Casa": Icons.home,
    "Alimentação" : Icons.local_pizza,
    "Saúde" : Icons.health_and_safety,
    "Tranporte": Icons.emoji_transportation,
    "Presentes": Icons.card_giftcard_sharp,
    "Outros": Icons.add,
    };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("images/logo.png"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Calendário de Despesas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TableCalendar(
                  locale: 'pt_BR',
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  availableCalendarFormats: {
                    CalendarFormat.month: 'Mês',
                    CalendarFormat.week: 'Semana',
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) async {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      String formattedDate =
                          "${selectedDay.day.toString().padLeft(2, '0')}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.year}";
                      _despesasFuture = selectData(formattedDate);
                    });
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    weekendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    selectedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 241, 240),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _despesasFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Erro: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text("Nenhuma despesa encontrada."));
                      } else {
                        return ListView(
                          controller: scrollController,
                          children: snapshot.data!.map((item) {
                            return ListTile(
                              title: Text(" ${item['descricao']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19)),
                                  subtitle: Text("${item['data']}",
                                      style: TextStyle(fontSize: 15)),
                                  leading: const Icon(Icons.access_alarm),
                                  trailing: Text("R\$ ${item['valor']}",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 17)),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50.0,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaCalendario()));
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  size: 40.0,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TelaGrafico()));
                },
                icon: Icon(
                  Icons.bar_chart,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
