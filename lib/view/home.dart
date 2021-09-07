import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sortviz/components/bar.dart';
import 'package:sortviz/components/value_slider.dart';
import 'package:sortviz/service/sorting_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double MAX_DURATION = 100;
  static const double MIN_DURATION = 0;
  static const int MAX_ARRAY_SIZE = 100;
  static const int MIN_ARRAY_SIZE = 2;
  Color sortColor = Colors.blue;
  int c = 0;
  List<Color> colors = [Colors.pink, Colors.teal, Colors.blue];
  SortingService sortingService = SortingService();
  Sort sortingType = Sort.MERGE_SORT;
  double height = -1;
  String? dropval = "Merge Sort";

  @override
  void dispose() {
    sortingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget changeColorButton = FloatingActionButton(
      onPressed: () {
        sortColor = colors[c++ % 3];
        // if (sortingService.pause) {
        setState(() {});
        // }
      },
      backgroundColor: Colors.white,
      child: Icon(
        Icons.format_color_fill,
        color: sortColor,
      ),
    );

    void changeSort(String? val) {
      setState(() {
        dropval = val;
        Sort.values.forEach((element) {
          if (element.name == val) {
            sortingType = element;
          }
        });
      });
      sortingService.shuffle();
    }

    final List<String> sortingtypes = [
      'Merge Sort',
      'Quick Sort',
      'Selection Sort',
      'Bubble Sort',
      'Insertion Sort',
      'Heap Sort'
    ];

    Widget sortSelector() {
      return Flexible(
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
              selectedItemBuilder: (_) {
                return sortingtypes
                    .map((e) => Container(
                          alignment: Alignment.center,
                          child: Text(
                            e,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))
                    .toList();
              },
              hint: Text("Change Algo"),
              value: dropval,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              iconSize: 30,
              elevation: 16,
              style: TextStyle(color: Colors.white, fontSize: 16.5),
              onChanged: changeSort,
              items: sortingtypes.map((String v) {
                return new DropdownMenuItem<String>(
                  value: v,
                  child: new Text(
                    v,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            )),
          ));
    }

    AppBar appBar = AppBar(
      backgroundColor: Color(0xFF202124),
      brightness: Brightness.dark,
      elevation: 4,
      title: Text(
        "Sorting Visualiser",
        style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
      actions: [sortSelector()],
    );

    Widget arraySizeSlider(
            {required ValueChanged<double> onArraySizeChanged}) =>
        ValueSlider(
          title: "Array Size",
          value: sortingService.size.toDouble(),
          max: MAX_ARRAY_SIZE.toDouble(),
          min: MIN_ARRAY_SIZE.toDouble(),
          onChanged: onArraySizeChanged,
          backgroundColor: sortColor,
        );

    Widget durationSlider({required ValueChanged<double> onDurationChange}) =>
        ValueSlider(
          title: "Duration",
          param: "ms",
          value: sortingService.duration.toDouble(),
          max: MAX_DURATION,
          min: MIN_DURATION,
          onChanged: onDurationChange,
          backgroundColor: sortColor,
        );

    void showSettings() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    arraySizeSlider(
                      onArraySizeChanged: (double value) {
                        setState(() {
                          sortingService.size = value.round();
                        });
                      },
                    ),
                    durationSlider(
                      onDurationChange: (double value) {
                        setState(() {
                          sortingService.duration = value.round();
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    Widget sortButton = InkWell(
      onTap: () {
        if (sortingService.pause) {
          sortingService.sort(sortingType);
        }
      },
      child: Center(
        child: Text(
          sortingType.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    Widget iconButton(
            {required VoidCallback onPressed, required IconData icon}) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
          ),
        );

    Widget shuffleButton = iconButton(
      onPressed: sortingService.shuffle,
      icon: Icons.shuffle,
    );

    Widget settingsButton = iconButton(
      onPressed: showSettings,
      icon: Icons.settings,
    );

    return Material(
      child: Scaffold(
        floatingActionButton: changeColorButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: appBar,
        body: LayoutBuilder(
          builder: (context, constrains) {
            sortingService.height = constrains.biggest.height.toInt();

            if (height != constrains.biggest.height) {
              height = constrains.biggest.height;
              sortingService.shuffle();
            }

            return StreamBuilder<List<int?>>(
              stream: sortingService.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                List<int?>? arr = snapshot.data;
                double barWidth =
                    constrains.biggest.width / sortingService.size;
                List<Widget> bars = List.generate(
                  sortingService.size,
                  (index) => Bar(
                    index: index,
                    height: arr![index]!,
                    width: barWidth,
                    color: sortColor,
                  ),
                ).toList();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bars,
                );
              },
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: appBar.preferredSize.height,
            child: Row(
              children: [
                Expanded(
                  child: sortButton,
                ),
                shuffleButton,
                settingsButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
