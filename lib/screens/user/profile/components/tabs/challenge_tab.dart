import 'package:challenger/time/occurrences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OccurrencesTabBar extends StatefulWidget {
  final Function(Occurrences) notifyParent;

  const OccurrencesTabBar(this.notifyParent);

  @override
  _OccurrencesTabBarState createState() => _OccurrencesTabBarState();
}

class _OccurrencesTabBarState extends State<OccurrencesTabBar>
    with SingleTickerProviderStateMixin {

  final List<Tab> occurrenceTabs = <Tab>[
    Tab(
      text: "Daily",
      icon: Icon(Icons.today),
    ),
    Tab(text: "Weekly", icon: Icon(Icons.date_range)),
    Tab(text: "Monthly", icon: Icon(Icons.history_edu))
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: occurrenceTabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          widget.notifyParent(Occurrences.DAY);
          break;
        case 1:
          widget.notifyParent(Occurrences.WEEK);
          break;
        case 2:
          widget.notifyParent(Occurrences.MONTH);
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: TabBar(
        // The number of tabs / content sections to display.
        controller: _tabController,
        tabs: occurrenceTabs, // Complete this code in the next step.
      ),
    );
  }
}
