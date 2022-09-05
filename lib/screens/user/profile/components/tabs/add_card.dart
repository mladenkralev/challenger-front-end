import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/global_constants.dart';
import 'package:challenger/notifications/notificationManager.dart';
import 'package:challenger/screens/user/profile/components/occurrence_switcher.dart';
import 'package:challenger/time/occurrences.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCard extends StatefulWidget {
  final Function(Challenge) notifyParent;

  AddCard(this.notifyParent);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final occurrences = [
    OccurrencesTransformer.transformToString(Occurrences.DAY),
    OccurrencesTransformer.transformToString(Occurrences.WEEK),
    OccurrencesTransformer.transformToString(Occurrences.MONTH)
  ];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Widget> _buildOccurrenceItems() {
    return occurrences.map((val) => OccurrenceSwitcher(title: val)).toList();
  }

  int occurrencesIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        child: SingleChildScrollView(
          child: Card(
            child: Container(
              child: new Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      height: 40,
                      child: new LayoutBuilder(builder: (context, constraint) {
                        return new Icon(Icons.fitness_center,
                            size: constraint.biggest.height);
                      }),
                    ),
                    title: Text(
                      "Challenge Card",
                      style: TextStyle(fontSize: GlobalConstants.cardTitleSize),
                    ),
                    subtitle: Text("Select the desired fields"),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 0),
                      child: Text(
                        'Challenges title',
                        style: TextStyle(
                            fontSize: GlobalConstants.h1Size,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 0, right: 10, bottom: 0),
                    child: Center(
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new TextField(
                              maxLines: 1,
                              maxLength: 25,
                              controller: titleController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter challenge\'s title',
                                hintStyle: TextStyle(
                                  fontSize: GlobalConstants.h2Size,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 1, right: 10, bottom: 1),
                      child: Text(
                        'Challenge me every:',
                        style: TextStyle(
                            fontSize: GlobalConstants.h1Size,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ),
                  DirectSelect(
                      itemExtent: 40.0,
                      selectedIndex: occurrencesIndex,
                      child: OccurrenceSwitcher(
                        isForList: false,
                        title: occurrences[occurrencesIndex],
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          occurrencesIndex = index;
                        });
                      },
                      items: _buildOccurrenceItems()),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 0),
                      child: Text(
                        'Challenge me with:',
                        style: TextStyle(
                            fontSize: GlobalConstants.h1Size,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 0, right: 10, bottom: 0),
                    child: Center(
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new TextField(
                              maxLines: 3,
                              controller: descriptionController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'What challenge should be performed',
                                hintStyle: TextStyle(
                                  fontSize: GlobalConstants.h2Size,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      TextButton(
                        child: const Text("Decline"),
                        onPressed: () {},
                      ),
                      TextButton(
                        child: const Text("Accept"),
                        onPressed: () {
                          NotificationManager.instance(context)
                              .showNotification();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                          widget.notifyParent(new Challenge(
                              null,
                              titleController.text,
                              descriptionController.text,
                              OccurrencesTransformer.getEnumOccurrences(
                                  occurrences[occurrencesIndex]),
                              null,
                              null,
                              100,
                              null));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
