import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sortviz/components/barPainter.dart';
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
  String dropdownValue = "Merge Sort";
  Stream<List<int>> stream;

  @override
  void initState() {
    super.initState();
    sortingService = SortingService(
      size: 200,
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
    String title;
    switch (s) {
      case 0:
        title = "Merge Sort";
        break;
      case 1:
        title = "Quick Sort";
        break;
      case 2:
        title = "Selection Sort";
        break;
      case 3:
        title = "Bubble Sort";
        break;
      case 4:
        title = "Insertion Sort";
        break;
      case 5:
        title = "Heap Sort";
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text(
          "Sorting Visualiser",
          style: TextStyle(
            fontSize: 19.0,
          ),
        ),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              iconSize: 24,
              onChanged: (String newValue) {
                setState(() {
                  switch (newValue) {
                    case 'Merge Sort':
                      setState(() {
                        s = 0;
                      });
                      break;
                    case 'Quick Sort':
                      setState(() {
                        s = 1;
                        print(s);
                      });
                      break;
                    case 'Selection Sort':
                      setState(() {
                        s = 2;
                        print(s);
                      });
                      break;
                    case 'Bubble Sort':
                      setState(() {
                        s = 3;
                        print(s);
                      });
                      break;
                    case 'Insertion Sort':
                      setState(() {
                        s = 4;
                        print(s);
                      });
                      break;
                    case 'Heap Sort':
                      setState(() {
                        s = 5;
                        print(s);
                      });
                      break;
                  }
                  dropdownValue = newValue;
                });
              },
              items: <String>[
                'Merge Sort',
                'Quick Sort',
                'Selection Sort',
                'Bubble Sort',
                'Insertion Sort',
                'Heap Sort'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            StreamBuilder<List<int>>(
              stream: stream,
              builder: (context, snapshot) {
                List<int> arr = snapshot.data;

                int ind = 0;
                return Row(
                  children: arr.map(
                    (int number) {
                      ind++;
                      return CustomPaint(
                        painter: ArrayBar(
                          sortColor: sortColor,
                          width: MediaQuery.of(context).size.width /
                              sortingService.size,
                          height: number,
                          index: ind,
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height - 190,
                  right: MediaQuery.of(context).size.width - 100),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  elevation: 3,
                  shape: CircleBorder(),
                  padding: EdgeInsets.only(bottom: 16, right: 11),
                  shadowColor: Colors.black,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.format_color_fill,
                    color: sortColor,
                    size: 30,
                  ),
                  onPressed: () => {
                    _changeButtonColor(),
                    setState(() {}),
                  },
                ),
              ),
            ),
          ],
        ),
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
                      onPressed: () async {
                        switch (s) {
                          case 0:
                            await sortingService.mergeSort(
                                0, sortingService.size - 1);
                            break;
                          case 1:
                            await sortingService.quickSort(
                                0, sortingService.size - 1);
                            break;
                          case 2:
                            sortingService.selectionSort();
                            break;
                          case 3:
                            sortingService.bubbleSort();
                            break;
                          case 4:
                            sortingService.insertionSort();
                            break;
                          case 5:
                            await sortingService.heapSort();
                            break;
                        }
                      },
                      child: Text(
                        title,
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
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                      TextBaseline.alphabetic,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      sortingService.size
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 24.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SliderTheme(
                                                  data: SliderTheme.of(context)
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
                                                    value: sortingService.size
                                                        .toDouble(),
                                                    inactiveColor: Colors.white,
                                                    onChanged: (double value) {
                                                      setState(() {
                                                        sortingService.size =
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
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                      TextBaseline.alphabetic,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      sortingService.duration
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 24.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      " µs",
                                                      style: TextStyle(
                                                        fontSize: 25.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SliderTheme(
                                                  data: SliderTheme.of(context)
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
                                                    inactiveColor: Colors.white,
                                                    onChanged: (double value) {
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
  }
}
