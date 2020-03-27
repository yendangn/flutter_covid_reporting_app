import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Thông tin Covid - Việt Nam'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = 'https://corona.lmao.ninja/countries/vietnam';

  bool isLoading = false;
  bool isError = false;
  Map<String, dynamic> data;
  Color color = Color(0xFF2A3477);

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: color,
        centerTitle: true,
      ),
      body: Center(
        child: buildContent(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        onPressed: () {
          fetchData();
        },
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (isError) {
      return Container(
        child: Text('Xin lỗi, đã có lỗi xảy ra'),
      );
    }

    if (data == null) {
      return Container();
    }

    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Text(
            'Hôm nay',
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        _buildLine(),
        _buildItem('Tổng số ca nhiễm bệnh mới', data['todayCases'].toString()),
        _buildItem('Tổng số ca tử vọng', data['todayDeaths'].toString()),
        _buildLine(),
        Container(
          padding: EdgeInsets.all(15),
          child: Text(
            'Thống kê',
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold),
          ),
        ),
        _buildLine(),
        _buildItem('Tổng số đã nhiễm bệnh', data['cases'].toString()),
        _buildItem('Tổng số ca tử vong', data['deaths'].toString()),
        _buildItem('Tổng số ca bình phục', data['recovered'].toString()),
        _buildItem('Tổng số đang nhiễm bệnh', data['active'].toString()),
      ],
    );
  }

  ListTile _buildItem(String title, String data) {
    return ListTile(
      title: Text(
        data,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildLine() {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: Colors.grey,
    );
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  void fetchData() async {
    startLoading();

    setState(() {
      isError = false;
    });

    var client = http.Client();

    try {
      var uriResponse = await client.get(url);

      setState(() {
        data = jsonDecode(uriResponse.body);
      });
    } catch (error) {
      setState(() {
        isError = true;
      });
    } finally {
      client.close();
      stopLoading();
    }
  }
}
