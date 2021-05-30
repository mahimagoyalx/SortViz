import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sortviz/components/bar.dart';
import 'package:sortviz/components/cardView.dart';
import 'package:sortviz/service/sorting_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color sortColor = Colors.blue;
  int c = 0;
  List<Color> colors;
  SortingService sortingService;
  int s = 0;
  Sort sortingType = Sort.MERGE_SORT;
  Stream<List<int>> stream;

  @override
  void initState() {
    super.initState();
    sortingService = SortingService(
      size: 2,
      microsecondDuration: 500,
    );

    stream = sortingService.stream;
    colors = [Colors.pink, Colors.teal, Colors.blue];
  }

  @override
  void dispose() {
    sortingService.dispose();
    super.dispose();
  }

  _changeButtonColor() {
    if (c == 3) c = 0;
    sortColor = colors[c++];
  }

  @override
  Widget build(BuildContext context) {
    void changeSort(Sort sort) {
      setState(() {
        sortingType = sort;
      });
    }

    List<DropdownMenuItem<Sort>> sorts = Sort.values
        .map((sort) => DropdownMenuItem<Sort>(
              value: sort,
              child: Text(sort.name),
            ))
        .toList();

    Widget sortSelector() {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          iconSize: 24,
          onChanged: changeSort,
          items: sorts,
        ),
      );
    }

    return Material(
      child: StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                _changeButtonColor(),
                setState(() {}),
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.format_color_fill,
                color: sortColor,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            appBar: AppBar(
              elevation: 4,
              title: Text(
                "Sorting Visualiser",
                style: TextStyle(
                  fontSize: 19.0,
                ),
              ),
              actions: [sortSelector()],
            ),
            body: StreamBuilder<List<int>>(
              stream: stream,
              builder: (context, snapshot) {
                List<int> arr = snapshot.data;

                return LayoutBuilder(
                  builder: (context, constrains) {
                    double width =
                        constrains.biggest.width / sortingService.size;
                    List<Widget> bars = List.generate(
                      sortingService.size,
                      (index) => Bar(
                        index: index,
                        height: arr[index],
                        width: width,
                        color: sortColor,
                      ),
                    ).toList();

                    return Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: bars,
                      ),
                    );
                  },
                );
              },
            ),
            bottomNavigationBar: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: BottomAppBar(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          height: 55,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () {
                              sortingService.sort(sortingType);
                            },
                            child: Text(
                              sortingType.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 75,
                          height: 55,
                          child: TextButton(
                            style: TextButton.styleFrom(primary: Colors.white),
                            onPressed: sortingService.randomise,
                            child: Icon(
                              Icons.shuffle,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 75,
                          height: 55,
                          child: TextButton(
                            style: TextButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              setState(
                                () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (builder) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Container(
                                            height: 315,
                                            child: ListView(
                                              padding: const EdgeInsets.all(4),
                                              children: <Widget>[
                                                CardView(
                                                  Colors.blue,
                                                  130,
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        "Array Size",
                                                        style: TextStyle(
                                                          fontSize: 24.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .baseline,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            sortingService.size
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 24.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SliderTheme(
                                                        data: SliderTheme.of(
                                                                context)
                                                            .copyWith(
                                                          activeTrackColor:
                                                              Colors.black,
                                                          thumbColor:
                                                              Color(0xFFEB1555),
                                                          overlayColor:
                                                              Color(0x29EB1555),
                                                          overlayShape:
                                                              RoundSliderOverlayShape(
                                                                  overlayRadius:
                                                                      20.0),
                                                          thumbShape:
                                                              RoundSliderThumbShape(
                                                                  enabledThumbRadius:
                                                                      10.0),
                                                        ),
                                                        child: Slider(
                                                          max: 500,
                                                          min: 5,
                                                          value: sortingService
                                                              .size
                                                              .toDouble(),
                                                          inactiveColor:
                                                              Colors.white,
                                                          onChanged:
                                                              (double value) {
                                                            setState(() {
                                                              sortingService
                                                                      .size =
                                                                  value.round();
                                                              sortingService
                                                                  .randomise();
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                CardView(
                                                  Colors.blue,
                                                  130,
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        "Duration",
                                                        style: TextStyle(
                                                          fontSize: 24.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .baseline,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            sortingService
                                                                .duration
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 24.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            " µs",
                                                            style: TextStyle(
                                                              fontSize: 25.0,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SliderTheme(
                                                        data: SliderTheme.of(
                                                                context)
                                                            .copyWith(
                                                          activeTrackColor:
                                                              Colors.black,
                                                          thumbColor:
                                                              Color(0xFFEB1555),
                                                          overlayColor:
                                                              Color(0x29EB1555),
                                                          overlayShape:
                                                              RoundSliderOverlayShape(
                                                                  overlayRadius:
                                                                      20.0),
                                                          thumbShape:
                                                              RoundSliderThumbShape(
                                                                  enabledThumbRadius:
                                                                      10.0),
                                                        ),
                                                        child: Slider(
                                                          max: 5000,
                                                          min: 1,
                                                          value: sortingService
                                                              .duration
                                                              .toDouble(),
                                                          inactiveColor:
                                                              Colors.white,
                                                          onChanged:
                                                              (double value) {
                                                            setState(() {
                                                              sortingService
                                                                      .duration =
                                                                  value.round();
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.settings,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
