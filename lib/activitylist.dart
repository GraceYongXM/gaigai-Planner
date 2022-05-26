import 'package:flutter/material.dart';

import './dbhelper.dart';
import './activity.dart';
import './native_datatable.dart';

class ActivityListPage extends StatefulWidget {
  const ActivityListPage({Key? key}) : super(key: key);

  @override
  State<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    var dbHelper = DBHelper();
    List<Activity> _activityList = await dbHelper.getActivity();
    setState(() {
      activityList = _activityList;
    });
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void _sort<T>(
      Comparable<T> getField(Activity d), int columnIndex, bool ascending) {
    activityList.sort((Activity a, Activity b) {
      if (!ascending) {
        final Activity c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<Activity> activityList = [];
  int _rowsOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggested List of Activities'),
      ),
      body: NativeDataTable.builder(
        rowsPerPage: _rowsPerPage,
        itemCount: activityList?.length ?? 0,
        firstRowIndex: _rowsOffset,
        handleNext: () async {
          setState(() {
            _rowsOffset += _rowsPerPage;
          });

          await new Future.delayed(new Duration(seconds: 3));
          setState(() {
            activityList += [
              Activity(4, 'New Item 4', 'type', 'location', 24, 4.0),
              Activity(5, 'New Item 5', 'type', 'location', 24, 4.0),
              Activity(6, 'New Item 6', 'type', 'location', 24, 4.0),
            ];
          });
        },
        handlePrevious: () {
          setState(() {
            _rowsOffset -= _rowsPerPage;
          });
        },
        itemBuilder: (int index) {
          final Activity activity = activityList[index];
          return DataRow.byIndex(
              index: index,
              selected: activity.selected,
              onSelectChanged: (value) {
                if (activity.selected != value) {
                  setState(() {
                    activity.selected = value;
                  });
                }
              },
              cells: <DataCell>[
                DataCell(Text('${activity.id}')),
                DataCell(Text('${activity.name}')),
                DataCell(Text('${activity.type}')),
                DataCell(Text('${activity.location}')),
                DataCell(Text('${activity.cost.toStringAsFixed(2)}')),
                DataCell(Text('${activity.travelTime.toStringAsFixed(0)}')),
              ]);
        },
        header: const Text('Data Management'),
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        onRefresh: () async {
          await new Future.delayed(new Duration(seconds: 3));
          setState(() {
            getData();
          });
          return null;
        },
        onRowsPerPageChanged: (int? value) {
          int updatedValue = 0;
          if (value == null) {
            updatedValue = PaginatedDataTable.defaultRowsPerPage;
          } else {
            updatedValue = value;
          }
          setState(() {
              _rowsPerPage = updatedValue;
            });
          print("New Rows: $value");
        },
        // mobileItemBuilder: (BuildContext context, int index) {
        //   final i = _desserts[index];
        //   return ListTile(
        //     title: Text(i?.name),
        //   );
        // },
        onSelectAll: (bool? value) {
          for (var row in activityList) {
            setState(() {
              row.selected = value;
            });
          }
        },
        rowCountApproximate: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
        selectedActions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                if (activityList !null) {
                  for (var item in activityList ?.where((d) => d?.selected ?? false) ?.toSet() ?.toList()) {
                  activityList.remove(item);
                }
              }});
            },
          ),
        ],
        columns: <DataColumn>[
          DataColumn(
              label: const Text('Dessert (100g serving)'),
              onSort: (int columnIndex, bool ascending) =>
                  _sort<String>((Activity a) => a.name, columnIndex, ascending)),
          DataColumn(
              label: const Text('Type of Activity'),
              tooltip:
                  'The total amount of food energy in the given serving size.',
              onSort: (int columnIndex, bool ascending) => _sort<String>(
                  (Activity d) => d.type, columnIndex, ascending)),
          DataColumn(
              label: const Text('Cost (\$)'),
              numeric: true,
              onSort: (int columnIndex, bool ascending) =>
                  _sort<num>((Activity d) => d.cost, columnIndex, ascending))
        ],
      ),
    );
  }
}

/* child: Text('activityList.length: ' + activityList.length.toString())
child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(15),
                child: Text('hi' + activityList[index].name),
              );
            },
            separatorBuilder: (context, index) => Divider(
                  height: 0.5,
                  color: Colors.purple,
                ),
            itemCount: activityList == null ? 0 : activityList.length),
            */
