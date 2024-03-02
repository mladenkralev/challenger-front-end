import 'package:calendar_view/calendar_view.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeCalendar extends StatelessWidget {
  final double _padding = 32.0;

  @override
  Widget build(BuildContext context) {
    double cardsSizeHeight = MediaQuery.of(context).size.height * 0.5;
    double cardsSizeWidth = MediaQuery.of(context).size.width * 0.5 * 0.85;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: cardsSizeWidth,
        height: cardsSizeHeight,
        color: Colors.indigo,
        child: Padding(
          padding: EdgeInsets.all(_padding),
          child: Container(
            child: Center(
                child: CalendarControllerProvider(
                    controller: EventController(),
                    child: MonthView(
                      controller: EventController(),
                      // to provide custom UI for month cells.
                      cellBuilder: (date, events, isToday, isInMonth) {
                        // Return your widget to display as month cell.
                        if (isToday) {
                          return getCardDate(
                              Colors.blueAccent, date.day.toString());
                        }

                        if (!isInMonth) {
                          return getCardDate(
                              Colors.white24, date.day.toString());
                        }
                        return getCardDate(Colors.white60, date.day.toString());
                      },
                      headerBuilder: (date) {
                        return Container(
                          color: Colors.redAccent,
                        );
                      },
                      minMonth: DateTime(1990),
                      maxMonth: DateTime(2050),
                      initialMonth: DateTime.now(),
                      width: cardsSizeWidth,
                      cellAspectRatio: 3,
                      onPageChange: (date, pageIndex) =>
                          print("$date, $pageIndex"),
                      onCellTap: (events, date) {
                        // Implement callback when user taps on a cell.
                        print(events);
                      },
                      startDay: WeekDays.sunday,
                      // To change the first day of the week.
                      // This callback will only work if cellBuilder is null.
                      onEventTap: (event, date) => print(event),
                      onDateLongPress: (date) => print(date),
                    ))),
          ),
        ),
      ),
    );
  }

  Widget getCardDate(Color colorOfContainer, String text) {
    return Container(
        color: colorOfContainer,
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: WebGlobalConstants.h1Size)),
        ));
  }
}
