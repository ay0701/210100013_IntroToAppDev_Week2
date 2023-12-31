import 'package:flutter/material.dart';

void main() {
  runApp(BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String username = "Trafalgar D Water Law";
  double totalBalance = 0.0;

  List<WidgetData> widgets = [];

  void _showAddEntryDialog() {
    String entryName = "";
    String category = "+";
    double value = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("NEW EXPENSE"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (text) {
                  entryName = text;
                },
                decoration: InputDecoration(labelText: "Expense Name"),
              ),
              DropdownButtonFormField<String>(
                value: category,
                onChanged: (newValue) {
                  setState(() {
                    category = newValue!;
                  });
                },
                items: ["+", "-"]
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: "Category"),
              ),
              TextField(
                onChanged: (text) {
                  value = double.tryParse(text) ?? 0.0;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Amount"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widgets.add(
                    WidgetData(
                      entryName: entryName,
                      category: category,
                      amount: category == "+" ? value : -value,
                    ),
                  );
                  totalBalance += category == "+" ? value : -value;
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Budget Tracker")),
      backgroundColor: const Color.fromARGB(143, 0, 0, 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome back, $username!"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WidgetListPage(widgets: widgets),
                  ),
                );
              },
              child: TotalWidget(totalBalance: totalBalance),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class TotalWidget extends StatelessWidget {
  final double totalBalance;

  TotalWidget({required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Total"),
            SizedBox(height: 10),
            Text(
              totalBalance.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetListPage extends StatelessWidget {
  final List<WidgetData> widgets;

  WidgetListPage({required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget List")),
      backgroundColor: const Color.fromARGB(143, 0, 0, 0),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          WidgetData widgetData = widgets[index];
          return ListTile(
            title: Text(widgetData.entryName),
            subtitle: Text(widgetData.amount.toString()),
            leading:
                Icon(widgetData.category == "+" ? Icons.add : Icons.remove),
          );
        },
      ),
    );
  }
}

class WidgetData {
  final String entryName;
  final String category;
  final double amount;

  WidgetData({
    required this.entryName,
    required this.category,
    required this.amount,
  });
}
