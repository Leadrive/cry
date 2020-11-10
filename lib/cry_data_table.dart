import 'package:flutter/material.dart';

import 'model/page_model.dart';

class CryDataTable extends StatefulWidget {
  CryDataTable({
    Key key,
    this.title = '',
    this.columns,
    this.page,
    this.getCells,
    this.onPageChanged,
    this.onSelectChanged,
    this.availableRowsPerPage,
    this.selectable,
  }) : super(key: key);
  final String title;
  final List<int> availableRowsPerPage;
  final List<DataColumn> columns;
  final Function getCells;
  final Function onPageChanged;
  final Function onSelectChanged;
  final Function selectable;
  final PageModel page;

  @override
  CryDataTableState createState() => CryDataTableState();
}

class CryDataTableState extends State<CryDataTable> {
  _DS _ds = _DS();

  @override
  void initState() {
    super.initState();
    _ds._getCells = widget.getCells;
    _ds._onSelectChanged = widget.onSelectChanged;
    _ds._selectable = widget.selectable;
    _ds.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    PageModel page = widget.page ?? PageModel();
    _ds._page = page;
    _ds.reload();
    var result = PaginatedDataTable(
      header: Text(widget.title),
      rowsPerPage: page.size,
      availableRowsPerPage: widget.availableRowsPerPage ?? [5, 10, 20, 50],
      onPageChanged: (firstRowIndex) {
        int current = (firstRowIndex / page.size + 1) as int;
        return widget.onPageChanged(page.size, current);
      },
      onRowsPerPageChanged: (int value) {
        return widget.onPageChanged(value, 1);
      },
      columns: widget.columns ?? [DataColumn(label: Text(''))],
      source: _ds,
      showCheckboxColumn: true,
    );
    return result;
  }

  List<Map> getSelectedList(PageModel page) {
    return (page ?? widget.page)?.records?.where((v) => v['selected'] ?? false)?.toList() ?? [];
  }
}

class _DS extends DataTableSource {
  PageModel _page = PageModel();
  Function _getCells;
  Function _onSelectChanged;
  Function _selectable;

  reload() {
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    var dataIndex = index - _page.size * (_page.current - 1);

    if (dataIndex >= _page.records.length) {
      return null;
    }
    Map m = _page.records[dataIndex];

    List<DataCell> cells = _getCells == null ? [] : _getCells(m);
    bool selected = m['selected'] ?? false;
    return DataRow.byIndex(
      index: index,
      cells: cells,
      selected: selected,
      onSelectChanged: (this._selectable == null ? true : this._selectable(m))
          ? (v) {
              m['selected'] = v;
              if (_onSelectChanged != null) {
                _onSelectChanged(m);
              } else {
                notifyListeners();
              }
            }
          : null,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _page.total;

  @override
  int get selectedRowCount => (_page?.records?.where((v) => v['selected'] ?? false)?.length) ?? 0;
}
