import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traveler Accountant'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.edit),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Scaffold(
                      // color: Colors.amber,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text('Add Group'),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Group Name',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: const MyStatefulWidget(),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  List<Map<int, List>> expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Travel group $index',
      expandedValue: [
        {
          1: ['Wayne', '+500']
        },
        {
          2: ['Yeap', '+300']
        },
        {
          3: ['Cayxin', '+200']
        },
        {
          4: ['Carmen', '+300']
        },
      ],
    );

    // return Text('Wayne $index');
  });
}

// Future<List<Item>> generateItems() async {
//   FirebaseFirestore db = FirebaseFirestore.instance;
//
//   await db.collection("users").get().then((event) {
//     for (var doc in event.docs) {
//       //** get group name
//       for (var group in doc.data()['groups']) {
//         print(group['group_name']);
//
//         //** get group members
//         for (var member in group['group_members']) {
//           print(member);
//
//           //** get member's transactions
//           for (var transaction in member['transactions']) {
//             print(transaction);
//           }
//         }
//       }
//     }
//   });
//
//   return List<Item>.generate(1, (int index) {
//     return Item(
//       headerValue: 'Travel group $index',
//       expandedValue: [
//         {
//           1: ['Wayne', '+500']
//         },
//         {
//           2: ['Yeap', '+300']
//         },
//         {
//           3: ['Cayxin', '+200']
//         },
//         {
//           4: ['Carmen', '+300']
//         },
//       ],
//     );
//
//     // return Text('Wayne $index');
//   });
// }

// TODO: display all the data
Future<String> readdb() async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  await db.collection("users").get().then((event) {
    for (var doc in event.docs) {
      //** get group name
      for (var group in doc.data()['groups']) {
        print(group['group_name']);

        //** get group members
        for (var member in group['group_members']) {
          print(member);

          //** get member's transactions
          for (var transaction in member['transactions']) {
            print(transaction);
          }
        }
      }
    }
  });

  return '';
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                item.headerValue,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          body: Column(
            children: [
              ElevatedButton(onPressed: () => readdb(), child: Text('read db')),
              for (var traveler in item.expandedValue)
                ListTile(
                  title: Text(traveler
                      .map((key, value) => MapEntry(key, value[0]))
                      .values
                      .toString()),
                  trailing: Text(
                    traveler
                        .map((key, value) => MapEntry(key, value[1]))
                        .values
                        .toString(),
                    style: const TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return Scaffold(
                          // color: Colors.amber,
                          body: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(traveler
                                    .map(
                                        (key, value) => MapEntry(key, value[0]))
                                    .values
                                    .toString()),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Description...',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: '0.00',
                                          ),
                                          textAlign: TextAlign.center,
                                          validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Please enter the amount';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          DatePicker.showDateTimePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime(2018, 3, 5),
                                              onChanged: (date) {
                                            print('change $date');
                                          }, onConfirm: (date) {
                                            print('confirm $date');
                                          },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.en);
                                        },
                                        child: const Text(
                                          'Date Time Picker',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Submit'),
                                      ),
                                    ],
                                  ),
                                ),
                                DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Date',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Description',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Amount',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: const <DataRow>[
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text('25-09-2022')),
                                        DataCell(Text('Baskin Robin')),
                                        DataCell(Text('20.50')),
                                        DataCell(Icon(Icons.edit)),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text('24-09-2022')),
                                        DataCell(Text('Baskin Robin')),
                                        DataCell(Text('10.50')),
                                        DataCell(Icon(Icons.edit)),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text('23-09-2022')),
                                        DataCell(Text('Starbucks')),
                                        DataCell(Text('12.21')),
                                        DataCell(Icon(Icons.edit)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
