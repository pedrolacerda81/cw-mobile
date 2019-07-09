// Packages Imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// Pages Imports
import '../helpers/homeHelper.dart';
import '../helpers/authHelper.dart';
import '../helpers/objects.dart';
import '../helpers/widgets.dart';
import './filterDialog.dart';
import './auth.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

//TODO: receber dados do grafico
class _HomeState extends State<Home> {
  bool isLoading = true;

  List<Category> _categories = List();

  DateTime _selectedDateHome = DateTime.now();

  Map<String, String> authPrefs;
  Map<String, String> userData;

  static SizedBox _buildPreLabelContainer(
      double height, double size, Color initColorParam, Color endColorParam) {
    Color initColorGradient;
    Color endColorGradient;
    double boxWidth;
    double boxHeight;

    initColorGradient = initColorParam;
    endColorGradient = endColorParam;
    boxWidth = size;
    boxHeight = height;

    return SizedBox(
      height: boxHeight,
      width: boxWidth,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(colors: [
            initColorGradient,
            endColorGradient,
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
        ),
      ),
    );
  }

  Widget sucessoPercent = _buildPreLabelContainer(
      8.0, 35.0, Colors.greenAccent[100], Colors.greenAccent[700]);
  Widget avisoPercent = _buildPreLabelContainer(
      8.0, 35.0, Colors.yellowAccent[100], Colors.amberAccent[400]);
  Widget erroPercent = _buildPreLabelContainer(
      8.0, 35.0, Colors.redAccent[100], Colors.redAccent);
  Widget pendentePercent = _buildPreLabelContainer(
      8.0, 35.0, Colors.blueAccent[100], Colors.blueAccent[400]);

  Widget sucessoTotal =
      _buildPreLabelContainer(8.0, 20.0, Colors.grey[350], Colors.grey[600]);
  Widget avisoTotal =
      _buildPreLabelContainer(8.0, 20.0, Colors.grey[350], Colors.grey[600]);
  Widget erroTotal =
      _buildPreLabelContainer(8.0, 20.0, Colors.grey[350], Colors.grey[600]);
  Widget pendenteTotal =
      _buildPreLabelContainer(8.0, 20.0, Colors.grey[350], Colors.grey[600]);

  Widget mainTitle =
      _buildPreLabelContainer(12.0, 80.0, Colors.grey[350], Colors.grey[600]);
  Widget mainSubtitle =
      _buildPreLabelContainer(8.0, 120.0, Colors.grey[350], Colors.grey[600]);

  @override
  void initState() {
    debugPrint('Entrou no initState da Home');
    bool redirect = false;
    super.initState();

    AuthHelper.getAuthPreferences().then((Map<String, String> authprefs) {
      this.authPrefs = authprefs;
    });

    AuthHelper.getUserData().then((Map<String, String> userdata) {
      this.userData = userdata;
    });

    ChartHelper.getPlatforms().then((categories) {
      if (!redirect) {
        if (categories != null) {
          setState(() {
            _categories = categories;
          });
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => Auth()));
        }
      }
    });

    ChartHelper.getData().then((value) {
      if (value == null) {
        redirect = true;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Auth()));
      } else {
        if (!redirect) {
          setState(() {
            isLoading = value;

            var currentDate = ChartHelper.dataLabel == null
                ? DateTime.now()
                : DateTime.parse(ChartHelper.dataLabel);
            var month = DateFormat.MMMM('pt_BR');
            var year = DateFormat('y');
            var formatedMonth = month.format(currentDate);
            var upperCaseMonth =
                '${formatedMonth[0].toUpperCase()}${formatedMonth.substring(1)}';
            String subtitle = ChartHelper.formatSubtitleLabel(
                ChartHelper.categoriaLabel,
                ChartHelper.plataformaLabel,
                ChartHelper.tribunalLabel);

            mainTitle = Text(
              'Consumo de $upperCaseMonth de ${year.format(currentDate)}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            );
            mainSubtitle =
                Text(subtitle, style: TextStyle(color: Colors.grey[400]));

            sucessoPercent = Text(
              '${ChartHelper.successPercents} %',
              style: TextStyle(
                  color: Colors.greenAccent[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            );
            avisoPercent = Text(
              '${ChartHelper.warningPercents} %',
              style: TextStyle(
                  color: Colors.amberAccent[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            );
            erroPercent = Text(
              '${ChartHelper.errorPercents} %',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            );
            pendentePercent = Text(
              '${ChartHelper.pendingPercents} %',
              style: TextStyle(
                  color: Colors.blueAccent[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            );

            String _formatTotalValue(int value) {
              final formatter = NumberFormat("#,###,###,###");
              String formatedValue = formatter.format(value);
              String replacedValueString = formatedValue.replaceAll(',', '.');
              return replacedValueString;
            }

            sucessoTotal = Text(
              _formatTotalValue(ChartHelper.countSucesso),
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            );
            avisoTotal = Text(
              _formatTotalValue(ChartHelper.countAviso),
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            );
            erroTotal = Text(
              _formatTotalValue(ChartHelper.countErro),
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            );
            pendenteTotal = Text(
              _formatTotalValue(ChartHelper.countPendente),
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            );
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var chart = isLoading
        ? Center(
            child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                )))
        : CWUseChart(ChartHelper.plotChart());

    Widget chartWidget = Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.grey[100],
      child: SizedBox(
        height: 350.0,
        child: chart,
      ),
    );

    ListTile _buildStatsListTile(String title, Widget percent, Widget total) {
      return ListTile(
        title: Text(
          title,
          style:
              TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            percent,
            SizedBox(
              height: 5.0,
            ),
            total,
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Capturaweb', style: TextStyle(letterSpacing: 0.5)),
      ),
      drawer: this.userData == null
          ? CapturaDrawer.buildLoadingDrawer(context)
          : CapturaDrawer.buildDrawer(
              context, userData['name'], userData['email']),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.0, top: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: mainTitle,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: mainSubtitle,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 35.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _showFilters(context);
                    },
                  ),
                ],
              ),
              chartWidget,
              SizedBox(
                height: 4.0,
              ),
              _buildStatsListTile('Sucesso', sucessoPercent, sucessoTotal),
              Divider(),
              _buildStatsListTile('Aviso', avisoPercent, avisoTotal),
              Divider(),
              _buildStatsListTile('Erro', erroPercent, erroTotal),
              Divider(),
              _buildStatsListTile('Pendente', pendentePercent, pendenteTotal),
            ],
          ),
        ),
      ),
    );
  }

  _showFilters(context) async {
    await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 390,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            color: Theme.of(context).primaryColor),
                        child: ListTile(
                          title: Text(
                            'Dashboard de Consumo',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Informe os dados para visualizar a dashboard',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DialogContent(
                    context: context,
                    categories: _categories,
                    selectedDateHome: _selectedDateHome,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
