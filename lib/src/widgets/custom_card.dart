import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<List<String>> rows;
  final Widget buttons;
  final Color color;

  CustomCard({this.title, this.rows, this.buttons, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      color: color,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              Divider(),
              SizedBox(
                height: 10.0,
              ),

              Column(
                children: rows.map((rowData) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${rowData[0]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${rowData[1]}')
                        // Flexible(
                        //   child: Text('${rowData[1]}'),
                        // )
                      ],
                    ),
                  );
                }).toList(),
              ),

              // TODO: Uncomment this row

              SizedBox(
                height: 10,
              ),

              Divider(),

              buttons,
            ],
          ),
        ),
      ),
    );
  }
}
