//Packages Imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

//Pages Imports
import '../helpers/homeHelper.dart';
import '../helpers/objects.dart';
import './home.dart';

class DialogContent extends StatefulWidget {
  DialogContent({
    Key key,
    this.context,
    this.categories,
    this.selectedDateHome,
  }) : super(key: key);

  final BuildContext context;
  final List<Category> categories;
  final DateTime selectedDateHome;

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  Category _selectedCategory;
  Platform _selectedPlatform;
  Court _selectedCourt;
  DateTime _selectedDateDialog;

  @override
  void initState() {
    super.initState();

    _selectedDateDialog =
        ChartHelper.date == null ? DateTime.now() : ChartHelper.date;

    var c = ChartHelper.category == null
        ? widget.categories[0]
        : widget.categories
            .singleWhere((item) => item.value == ChartHelper.category.value);

    _selectedCategory = c;

    if (c.platforms != null && c.platforms.length > 0) {
      var p = ChartHelper.platform == null
          ? c.platforms[0]
          : c.platforms
              .singleWhere((item) => item.value == ChartHelper.platform.value);
      _selectedPlatform = p;

      if (p.courts != null && p.courts.length > 0) {
        var t = ChartHelper.court == null
            ? p.courts[0]
            : p.courts
                .singleWhere((item) => item.value == ChartHelper.court.value);
        _selectedCourt = t;
      }
    }
  }

  _getContent() {
    if (widget.categories.length == 0) {
      return Container();
    }

    void _onChangeCategory(Category newCategoryItem) {
      setState(() {
        this._selectedCourt = null;
        this._selectedPlatform = null;
        this._selectedCategory = newCategoryItem;
      });
    }

    void _onChangePlatform(Platform newPlatformItem) {
      setState(() {
        this._selectedCourt = null;
        this._selectedPlatform = newPlatformItem;
      });
    }

    void _onChangeCourt(Court newcourtItem) {
      setState(() {
        this._selectedCourt = newcourtItem;
      });
    }

    Container _buildCategoryComboBox(
        String hint, List<Category> list, Function onChange, Category value) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: DropdownButton<Category>(
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                elevation: 1,
                isExpanded: true,
                hint: Text(hint),
                items: list.map((Category item) {
                  return DropdownMenuItem<Category>(
                    value: item,
                    child: Text(item.label),
                  );
                }).toList(),
                onChanged: onChange,
                value: value,
              ),
            ),
          ],
        ),
      );
    }

    Container _buildPlatformComboBox(
        String hint, List<Platform> list, Function onChange, Platform value) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: DropdownButton<Platform>(
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                elevation: 1,
                isExpanded: true,
                hint: Text(hint),
                items: list.map((Platform item) {
                  return DropdownMenuItem<Platform>(
                    value: item,
                    child: Text(item.label),
                  );
                }).toList(),
                onChanged: onChange,
                value: value,
              ),
            ),
          ],
        ),
      );
    }

    Container _buildCourtComboBox(
        String hint, List<Court> list, Function onChange, Court value) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: DropdownButton<Court>(
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                elevation: 1,
                isExpanded: true,
                hint: Text(hint),
                items: list.map((Court item) {
                  return DropdownMenuItem<Court>(
                    value: item,
                    child: Text(item.label),
                  );
                }).toList(),
                onChanged: onChange,
                value: value,
              ),
            ),
          ],
        ),
      );
    }

    Container _buildSelectDateButton() {
      DateTime selectedDate;
      this._selectedDateDialog == null
          ? selectedDate = widget.selectedDateHome
          : selectedDate = this._selectedDateDialog;
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Builder(
              builder: (context) => Container(
                    height: 40.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      elevation: 2.0,
                      color: Theme.of(context).accentColor,
                      child: Row(children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          selectedDate.month.toString() +
                              '/' +
                              selectedDate.year.toString(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16.0),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 20.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                      ]),
                      onPressed: () {
                        showMonthPicker(
                                context: context, initialDate: selectedDate)
                            .then((DateTime date) => setState(() {
                                  this._selectedDateDialog = date;
                                }));
                      },
                    ),
                  ),
            ),
          ],
        ),
      );
    }

    _getFilters() {
      ChartHelper.date = this._selectedDateDialog;
      ChartHelper.category = this._selectedCategory;
      ChartHelper.platform = this._selectedPlatform;
      ChartHelper.court = this._selectedCourt;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Home()));
    }

    return Expanded(
      flex: 1,
      child: Column(
        children: <Widget>[
          _buildSelectDateButton(),
          _buildCategoryComboBox('Categoria', widget.categories,
              _onChangeCategory, _selectedCategory),
          _selectedCategory == null || _selectedCategory.platforms.length == 0
              ? SizedBox(
                  height: 68.0,
                )
              : _buildPlatformComboBox(
                  'Plataforma',
                  _selectedCategory.platforms,
                  _onChangePlatform,
                  _selectedPlatform),
          _selectedPlatform == null || _selectedPlatform.courts.length == 0
              ? SizedBox(
                  height: 68.0,
                )
              : _buildCourtComboBox('Tribunal', _selectedPlatform.courts,
                  _onChangeCourt, _selectedCourt),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: RaisedButton(
                    elevation: 2.0,
                    color: Color.fromRGBO(68, 81, 86, 1.0),
                    child: Text(
                      'VISUALIZAR',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: _getFilters,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}
