import 'package:cry/common/application_context.dart';
import 'package:cry/cry_data_table.dart';
import 'package:cry/cry_image_upload.dart';
import 'package:cry/cry_button.dart';
import 'package:cry/cry_tree_table.dart';
import 'package:cry/form/cry_input.dart';
import 'package:cry/form/cry_select.dart';
import 'package:cry/form/cry_select_date.dart';
import 'package:cry/form1/cry_input.dart' as cryInput1;
import 'package:cry/form1/cry_select.dart' as crySelect1;
import 'package:cry/model/order_item_model.dart';
import 'package:cry/model/page_model.dart';
import 'package:cry/model/request_body_api.dart';
import 'package:cry/model/response_body_api.dart';
import 'package:cry/model/test_tree_model.dart';
import 'package:cry/utils/http_util.dart';
import 'package:cry/utils/treeUtil.dart';
import 'package:cry/vo/select_option_vo.dart';
import 'package:cry/vo/tree_vo.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApplicationContext.instance.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cry Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cry Demo Home Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DemoButton(),
            DemoImageUpload(),
            DemoForm(),
            DemoTreeTable(),
            DemoDataTable(),
          ],
        ),
      ),
    );
  }
}

class DemoDataTable extends StatefulWidget {
  @override
  _DemoDataTableState createState() => _DemoDataTableState();
}

class _DemoDataTableState extends State<DemoDataTable> {
  PageModel page = PageModel(orders: [OrderItemModel(column: 'update_time')], size: 5);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    CryDataTable table = CryDataTable(
      title: 'User List',
      page: this.page,
      columns: [
        DataColumn(label: Text('name')),
        DataColumn(label: Text('createTime')),
      ],
      getCells: (Map m) {
        return [
          DataCell(Text(m['name'] ?? '--')),
          DataCell(Text(m['createTime'] ?? '--')),
        ];
      },
    );

    return table;
  }

  _loadData() async {
    ResponseBodyApi responseBodyApi = await HttpUtil.post('/userInfo/page', data: RequestBodyApi(page: page).toMap());
    this.page = PageModel.fromMap(responseBodyApi.data);
    setState(() {});
  }
}

class DemoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var button = CryButton(
      iconData: Icons.save,
      label: 'testButton',
      onPressed: () {
        print('testButton');
      },
    );
    return button;
  }
}

class DemoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var input = CryInput(label: 'testInput');
    var input1 = cryInput1.CryInput(label: 'testInput1');
    var dateSelect = CrySelectDate(
      context,
      label: 'testSelectDate',
    );
    var select = CrySelect(
      label: 'testSelect',
      dataList: [
        SelectOptionVO(label: '1', value: 'a'),
        SelectOptionVO(label: '2', value: 'b'),
      ],
    );
    var select1 = crySelect1.CrySelect(
      label: 'testSelect1',
      dataList: [
        SelectOptionVO(label: '1', value: 'a'),
        SelectOptionVO(label: '2', value: 'b'),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dateSelect,
        input,
        select,
        Wrap(
          children: [
            input1,
            select1,
          ],
        ),
      ],
    );
  }
}

class DemoImageUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imageUpload = CryImageUpload(
      updateAreaSize: 200,
      updateAreaDefault: Icon(Icons.person, size: 200),
      onUpload: (imageBytes) {
        print('onUpload');
      },
    );
    return imageUpload;
  }
}

class DemoTreeTable extends StatefulWidget {
  @override
  _DemoTreeTableState createState() => _DemoTreeTableState();
}

class _DemoTreeTableState extends State<DemoTreeTable> {
  var data = TreeUtil.toTreeVOList([
    TestTreeModel(id: '0', c1: 'c1-value0', c2: 'c2-value0'),
    TestTreeModel(id: '1', pid: '0', c1: 'c1-value1', c2: 'c2-value1'),
    TestTreeModel(id: '11', pid: '1', c1: 'c11-value11', c2: 'c2-value11'),
    TestTreeModel(id: '2', pid: '0', c1: 'c1-value2', c2: 'c2-value2'),
  ]);

  @override
  Widget build(BuildContext context) {
    List<CryTreeTableColumnData> columnData = [
      CryTreeTableColumnData('列1', (TestTreeModel v) => v.c1),
      CryTreeTableColumnData('列2', (TestTreeModel v) => v.c2),
    ];

    var treeTable = CryTreeTable(
      columnData: columnData,
      data: data,
      onSelected: (TreeVO<TestTreeModel> v) {
        this.setState(() {});
      },
    );
    return treeTable;
  }
}
