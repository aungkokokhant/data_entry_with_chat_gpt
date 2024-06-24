import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Table with Filters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TablePage(),
    );
  }
}

// Globally accessible data list
List<Map<String, String>> data = [
  {
    'number': '1',
    'time': '08:00 AM',
    'customerName': 'John Doe',
    'reason': 'Payment',
    'date': '2023-06-21',
    'accountType': 'KPay',
    'receivedAccount': 'Aung Ko',
    'amount': '1000',
    'transactionId': 'TX123456789',
    'balance': '5000',
    'channel': 'Viber',
    'status': 'Cash In',
  },
  {
    'number': '2',
    'time': '09:00 AM',
    'customerName': 'Jane Smith',
    'reason': 'Refund',
    'date': '2023-06-22',
    'accountType': 'Wave',
    'receivedAccount': 'Mg Mg',
    'amount': '500',
    'transactionId': 'TX987654321',
    'balance': '4500',
    'channel': 'Messenger',
    'status': 'Cash Out',
  },
  // Add more demo data here...
];

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  String? reasonFilter;
  DateTime? startDate;
  DateTime? endDate;
  String? accountTypeFilter;
  String? receivedAccountFilter;
  String? statusFilter;

  List<Map<String, String>> get filteredData {
    return data.where((row) {
      if (reasonFilter != null && row['reason'] != reasonFilter) {
        return false;
      }
      if (accountTypeFilter != null && row['accountType'] != accountTypeFilter) {
        return false;
      }
      if (receivedAccountFilter != null && row['receivedAccount'] != receivedAccountFilter) {
        return false;
      }
      if (statusFilter != null && row['status'] != statusFilter) {
        return false;
      }
      if (startDate != null && DateTime.parse(row['date']!).isBefore(startDate!)) {
        return false;
      }
      if (endDate != null && DateTime.parse(row['date']!).isAfter(endDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  double get totalAmount {
    double sum = 0.0;
    for (var row in filteredData) {
      sum += double.parse(row['amount']!);
    }
    return sum;
  }

  double get totalBalance {
    double sum = 0.0;
    for (var row in filteredData) {
      sum += double.parse(row['balance']!);
    }
    return sum;
  }

  void refreshTable() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Table Page'),
      ),
      body: Column(
        children: [
          buildFilters(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Number')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Reason')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Account Type')),
                    DataColumn(label: Text('Received Account')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Transaction ID')),
                    DataColumn(label: Text('Balance')),
                    DataColumn(label: Text('Channel')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: filteredData.map((row) {
                    return DataRow(cells: [
                      DataCell(Text(row['number']!)),
                      DataCell(Text(row['time']!)),
                      DataCell(Text(row['customerName']!)),
                      DataCell(Text(row['reason']!)),
                      DataCell(Text(row['date']!)),
                      DataCell(Text(row['accountType']!)),
                      DataCell(Text(row['receivedAccount']!)),
                      DataCell(Text(row['amount']!)),
                      DataCell(Text(row['transactionId']!)),
                      DataCell(Text(row['balance']!)),
                      DataCell(Text(row['channel']!)),
                      DataCell(Text(row['status']!)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Amount: $totalAmount'),
                Text('Total Balance: $totalBalance'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataEntryPage(status: 'Cash In')),
              );
              refreshTable();
            },
            child: Icon(Icons.arrow_downward),
            tooltip: 'Cash In',
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataEntryPage(status: 'Cash Out')),
              );
              refreshTable();
            },
            child: Icon(Icons.arrow_upward),
            tooltip: 'Cash Out',
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Reason'),
                  value: reasonFilter,
                  items: ['Payment', 'Refund'].map((reason) {
                    return DropdownMenuItem(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      reasonFilter = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Account Type'),
                  value: accountTypeFilter,
                  items: ['KPay', 'Wave'].map((accountType) {
                    return DropdownMenuItem(
                      value: accountType,
                      child: Text(accountType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      accountTypeFilter = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Received Account'),
                  value: receivedAccountFilter,
                  items: ['Aung Ko', 'Mg Mg', 'Ko Zaw'].map((receivedAccount) {
                    return DropdownMenuItem(
                      value: receivedAccount,
                      child: Text(receivedAccount),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      receivedAccountFilter = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Status'),
                  value: statusFilter,
                  items: ['Cash In', 'Cash Out'].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Start Date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        startDate = pickedDate;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: startDate == null ? '' : startDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'End Date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        endDate = pickedDate;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: endDate == null ? '' : endDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}

class DataEntryPage extends StatefulWidget {
  final String status;

  DataEntryPage({required this.status});

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  final _formKey = GlobalKey<FormState>();
  String? reason;
  DateTime? date;
  TimeOfDay? time;
  String? accountType;
  String? receivedAccount;
  String customerName = '';
  String amount = '';
  String transactionId = '';
  String balance = '';
  String channel = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Entry (${widget.status})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                onChanged: (value) {
                  setState(() {
                    customerName = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Reason'),
                value: reason,
                items: ['Payment', 'Refund'].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    reason = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      date = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: date == null ? '' : date!.toLocal().toString().split(' ')[0],
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Time'),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      time = pickedTime;
                    });
                  }
                },
                controller: TextEditingController(
                  text: time == null ? '' : time!.format(context),
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Account Type'),
                value: accountType,
                items: ['KPay', 'Wave'].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    accountType = value;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Received Account'),
                value: receivedAccount,
                items: ['Aung Ko', 'Mg Mg', 'Ko Zaw'].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    receivedAccount = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Transaction ID'),
                onChanged: (value) {
                  setState(() {
                    transactionId = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Balance'),
                onChanged: (value) {
                  setState(() {
                    balance = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Channel'),
                onChanged: (value) {
                  setState(() {
                    channel = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add the data to the global list
                    data.add({
                      'number': (data.length + 1).toString(),
                      'time': time!.format(context),
                      'customerName': customerName,
                      'reason': reason!,
                      'date': date!.toLocal().toString().split(' ')[0],
                      'accountType': accountType!,
                      'receivedAccount': receivedAccount!,
                      'amount': amount,
                      'transactionId': transactionId,
                      'balance': balance,
                      'channel': channel,
                      'status': widget.status,
                    });
                    // Go back to the table page
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
