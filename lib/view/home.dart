import 'package:flutter/material.dart';
import 'package:sortviz/components/bar.dart';
import 'package:sortviz/components/value_slider.dart';
import 'package:sortviz/service/sorting_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double MAX_DURATION = 50000;
  static const double MIN_DURATION = 0;
  static const double MAX_ARRAY_SIZE = 1000;
  static const double MIN_ARRAY_SIZE = 2;
  Color sortColor = Colors.blue;
  int c = 0;
  List<Color> colors = [Colors.pink, Colors.teal, Colors.blue];
  SortingService sortingService = SortingService();
  Sort sortingType = Sort.MERGE_SORT;
  double height = -1;

  @override
  void dispose() {
    sortingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget changeColorButton = FloatingActionButton(
      // Intentionally disabling it, makes sense right?
      onPressed: () {
        sortColor = colors[c++ % 3];

        if (sortingService.pause) {
          setState(() {});
        }
      },
      backgroundColor: Colors.white,
      child: Icon(
        Icons.format_color_fill,
        color: sortColor,
      ),
    );

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

    AppBar appBar = AppBar(
      elevation: 4,
      title: Text(
        "Sorting Visualiser",
        style: TextStyle(
          fontSize: 19.0,
        ),
      ),
      actions: [sortSelector()],
    );

    Widget arraySizeSlider(
            {@required ValueChanged<double> onArraySizeChanged}) =>
        ValueSlider(
          title: "Array Size",
          value: sortingService.size.toDouble(),
          max: MAX_ARRAY_SIZE,
          min: MIN_ARRAY_SIZE,
          onChanged: onArraySizeChanged,
          backgroundColor: sortColor,
        );

    Widget durationSlider({@required ValueChanged<double> onDurationChange}) =>
        ValueSlider(
          title: "Duration",
          param: "µs",
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
        sortingService.sort(sortingType);
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
            {@required VoidCallback onPressed, @required IconData icon}) =>
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

            return StreamBuilder<List<int>>(
              stream: sortingService.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                List<int> arr = snapshot.data;
                double barWidth =
                    constrains.biggest.width / sortingService.size;
                List<Widget> bars = List.generate(
                  sortingService.size,
                      (index) => Bar(
                    index: index,
                    height: arr[index],
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
