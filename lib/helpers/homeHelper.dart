//Packages Imports
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

//Config Imports
import '../config/urls.dart';

//Pages Impors
import './objects.dart';
import './authHelper.dart';

class CWUseChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CWUseChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer:
          charts.LineRendererConfig(includeArea: true, stacked: false),
      domainAxis: charts.DateTimeAxisSpec(
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
              day: charts.TimeFormatterSpec(
                  format: 'dd/MM', transitionFormat: 'dd/MM'))),
    );
  }
}

class CWCoordinate {
  final DateTime timeStamp;
  final int requisitions;
  CWCoordinate(this.timeStamp, this.requisitions);
}

class ChartHelper {
  static List<CWCoordinate> successCoordinates = List();
  static List<CWCoordinate> warningCoordinates = List();
  static List<CWCoordinate> errorCoordinates = List();
  static List<CWCoordinate> pendingCoordinates = List();
  static List<CWCoordinate> totalCoordinates = List();

  static int countSucesso = 0;
  static int countAviso = 0;
  static int countErro = 0;
  static int countPendente = 0;
  static int countTotal = 0;

  static String successPercents;
  static String warningPercents;
  static String errorPercents;
  static String pendingPercents;

  static DateTime date;
  static Category category;
  static Platform platform;
  static Court court;

  static String dataLabel;
  static String categoriaLabel;
  static String plataformaLabel;
  static String tribunalLabel;

  static Future<bool> getData() async {
    debugPrint('Entrou na getData');
    DateTime now = date == null ? DateTime.now() : date;
    DateTime lastDayDateTime = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 0)
        : DateTime(now.year + 1, 1, 0);
    DateTime firstDayDateTime = DateTime(now.year, now.month);

    Map<String, String> params;

    if (category == null) {
      params = {
        'inicio': firstDayDateTime.toString(),
        'fim': lastDayDateTime.toString(),
      };
    } else if (platform == null) {
      params = {
        'inicio': firstDayDateTime.toString(),
        'fim': lastDayDateTime.toString(),
        'categoria': category.value
      };
    } else if (court == null) {
      params = {
        'inicio': firstDayDateTime.toString(),
        'fim': lastDayDateTime.toString(),
        'categoria': category.value,
        'plataforma': platform.value,
      };
    } else {
      params = {
        'inicio': firstDayDateTime.toString(),
        'fim': lastDayDateTime.toString(),
        'categoria': category.value,
        'plataforma': platform.value,
        'tribunal': court.value
      };
    }

    Map<String, String> authPrefs = await AuthHelper.getAuthPreferences();
    String tokenType = authPrefs['tokenType'];
    String token = authPrefs['token'];
    String refreshToken = authPrefs['refreshToken'];

    Map<String, String> header = {'Authorization': '$tokenType $token'};

    var uri = Uri.http(UrlHelper.apiUrl, '/consumo', params);
    debugPrint('Url de Consumo: ' + uri.toString());
    http.Response response = await http.get(uri, headers: header);

    debugPrint('GetData status ' + response.statusCode.toString());

    if (response.statusCode == 200 || response.statusCode == 202) {
      var body = json.decode(response.body);
      var data = body['data'];

      dataLabel = data['inicio'];
      categoriaLabel = data['categoria'];
      plataformaLabel = data['plataforma'];
      tribunalLabel = data['tribunal'];

      List<dynamic> dias = data['dias'] as List;
      List<dynamic> sucessoArray = List();
      List<dynamic> avisoArray = List();
      List<dynamic> erroArray = List();
      List<dynamic> pendenteArray = List();
      List<dynamic> totalArray = List();

      dias.forEach((dia) {
        sucessoArray.add([dia['data'], dia['sucesso']]);
        avisoArray.add([dia['data'], dia['aviso']]);
        erroArray.add([dia['data'], dia['erro']]);
        pendenteArray.add([dia['data'], dia['pendente']]);
        totalArray.add([dia['data'], dia['contagem']]);
      });

      successCoordinates = ChartHelper.mapResponse(sucessoArray, 'Sucesso');
      warningCoordinates = ChartHelper.mapResponse(avisoArray, 'Aviso');
      errorCoordinates = ChartHelper.mapResponse(erroArray, 'Erro');
      pendingCoordinates = ChartHelper.mapResponse(pendenteArray, 'Pendente');
      totalCoordinates = ChartHelper.mapResponse(totalArray, 'Total');

      successPercents = ChartHelper.mapStatistics('Sucesso');
      warningPercents = ChartHelper.mapStatistics('Aviso');
      errorPercents = ChartHelper.mapStatistics('Erro');
      pendingPercents = ChartHelper.mapStatistics('Pendente');

      return false;
    } else if (response.statusCode == 401) {
      bool success = await AuthHelper.refreshToken(refreshToken);
      if (success) {
        debugPrint('Retrying getData()');
        return getData();
      } else {
        return null;
      }
    }
    return true;
  }

  static String formatSubtitleLabel(
      String categoria, String plataforma, String tribunal) {
    if (categoria != null && plataforma != null && tribunal != null) {
      return '$categoria / $plataforma / $tribunal';
    }
    if (categoria != null && plataforma != null && tribunal == null) {
      return '$categoria / $plataforma';
    }
    if (categoria != null && plataforma == null && tribunal == null) {
      return '$categoria';
    }
    return '-';
  }

  static Future<List<Category>> getPlatforms() async {
    debugPrint('Entrou na getPlatforms');

    Map<String, String> authPrefs = await AuthHelper.getAuthPreferences();
    String tokenType = authPrefs['tokenType'];
    String token = authPrefs['token'];
    String refreshToken = authPrefs['refreshToken'];

    Map<String, String> header = {'Authorization': '$tokenType $token'};

    var uri = Uri.http(UrlHelper.apiUrl, '/v1/available');
    debugPrint(uri.toString());
    http.Response response = await http.get(uri, headers: header);

    debugPrint('getPlatforms status ' + response.statusCode.toString());

    if (response.statusCode == 200 || response.statusCode == 202) {
      var body = json.decode(response.body);
      var data = body['data'] as List;
      List<Category> categories = List();
      categories.add(Category('Todas', '', List()));
      data.forEach((category) {
        List<Platform> p = List();
        var platforms = category['platforms'] == null
            ? null
            : category['platforms'] as List;
        if (platforms != null) {
          p.add(Platform('Todas', '', List()));
          platforms.forEach((platform) {
            List<Court> s = List();
            var searches = platform['searches'] == null
                ? null
                : platform['searches'] as List;
            if (searches != null) {
              s.add(Court('Todos', ''));
              searches.forEach((search) {
                s.add(Court(search['description'], search['search']));
              });
            }
            p.add(Platform(platform['description'], platform['platform'], s));
          });
        }
        categories
            .add(Category(category['description'], category['category'], p));
      });
      return categories;
    } else if (response.statusCode == 401) {
      bool success = await AuthHelper.refreshToken(refreshToken);
      if (success) {
        debugPrint('Retrying getPlatforms()');
        return getPlatforms();
      } else {
        return null;
      }
    }
    return null;
  }

  static List<charts.Series<CWCoordinate, DateTime>> plotChart() {
    var array = [
      ChartHelper.buildChart('Sucesso', successCoordinates),
      ChartHelper.buildChart('Aviso', warningCoordinates),
      ChartHelper.buildChart('Erro', errorCoordinates),
      ChartHelper.buildChart('Pendente', pendingCoordinates),
      ChartHelper.buildChart('Total', totalCoordinates),
    ];
    return array;
  }

  static String mapStatistics(String type) {
    switch (type) {
      case 'Sucesso':
        return ((countSucesso / countTotal) * 100).toStringAsFixed(2);
      case 'Aviso':
        return ((countAviso / countTotal) * 100).toStringAsFixed(2);
      case 'Erro':
        return ((countErro / countTotal) * 100).toStringAsFixed(2);
      case 'Pendente':
        return ((countPendente / countTotal) * 100).toStringAsFixed(2);
    }
    return null;
  }

  static void count(String type, int value) {
    switch (type) {
      case 'Sucesso':
        countSucesso += value;
        break;
      case 'Aviso':
        countAviso += value;
        break;
      case 'Erro':
        countErro += value;
        break;
      case 'Pendente':
        countPendente += value;
        break;
      case 'Total':
        countTotal += value;
        break;
    }
  }

  static List<CWCoordinate> mapResponse(List list, String type) {
    List<CWCoordinate> result = List();
    list.forEach((item) {
      count(type, item[1]);
      result.add(CWCoordinate(DateTime.parse(item[0]), item[1]));
    });
    return result;
  }

  static charts.Series<CWCoordinate, DateTime> buildChart(
      String id, List<CWCoordinate> list) {
    var cor = charts.MaterialPalette.gray.shadeDefault;
    switch (id) {
      case 'Sucesso':
        cor = charts.MaterialPalette.green.shadeDefault;
        break;
      case 'Aviso':
        cor = charts.MaterialPalette.yellow.shadeDefault;
        break;
      case 'Erro':
        cor = charts.MaterialPalette.red.shadeDefault;
        break;
      case 'Pendente':
        cor = charts.MaterialPalette.blue.shadeDefault;
        break;
    }
    return charts.Series<CWCoordinate, DateTime>(
      id: id,
      colorFn: (_, __) => cor,
      domainFn: (CWCoordinate coordinate, _) => coordinate.timeStamp,
      measureFn: (CWCoordinate coordinate, _) => coordinate.requisitions,
      data: list,
    );
  }
}
