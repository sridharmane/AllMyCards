import 'package:all_my_cards/utils/credit_card_utils.dart';
import 'package:all_my_cards/utils/date_utils.dart';
import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  StatusBar({
    this.paymentDate,
    this.statementDate,
    @required this.today,
    this.cellSize = const Size(15.0, 5),
    this.cellSizeToday = const Size(3.0, 25.0),
  }) : this.list = List.generate(DateUtils.daysInMonth(today.month), (i) {
          var d = i + 1;
          if (d == paymentDate) {
            return StatusColors.paymentDate;
          } else if (d == statementDate) {
            return StatusColors.statementDate;
          } else {
            if (paymentDate < statementDate) {
              if (d < paymentDate - 4) {
                return StatusColors.use;
              } else if (d < paymentDate) {
                return StatusColors.alert;
              } else if (d > paymentDate && d < statementDate) {
                return StatusColors.doNotUse;
              } else if (d > statementDate) {
                return StatusColors.use;
              } else {
                return StatusColors.doNotUse;
              }
            } else {
              if (d > statementDate && d < paymentDate - 4) {
                return StatusColors.use;
              } else if (d < statementDate || d > paymentDate) {
                return StatusColors.doNotUse;
              } else {
                return StatusColors.alert;
              }
            }
          }
        });

  final int paymentDate;
  final int statementDate;
  final DateTime today;
  final Size cellSize;
  final Size cellSizeToday;
  final List<Color> list;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double _cellWidth = constraints.maxWidth / list.length;
        double padLeft = (today.day - 1) * _cellWidth;
        double padRight =
            (DateUtils.daysInMonth(today.month) - today.day) * _cellWidth;

        padLeft += (_cellWidth - cellSizeToday.width) / 2;
        padRight += (_cellWidth - cellSizeToday.width) / 2;
        List<Widget> cells = [];
        for (var i = 0; i < list.length; i++) {
          cells.add(Container(
            height: cellSize.height,
            width: _cellWidth,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: list[i],
            ),
          ));
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var status in list) ...[
                    Container(
                      height: cellSize.height,
                      width: _cellWidth,
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: status,
                      ),
                    ),
                  ]
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              clipBehavior: Clip.antiAlias,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // color: Colors.yellow,
                  height: cellSize.height,
                  width: padLeft,
                ),
                Container(
                  height: cellSizeToday.height,
                  width: cellSizeToday.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Container(
                  // color: Colors.lime,
                  height: cellSize.height,
                  width: padRight,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
