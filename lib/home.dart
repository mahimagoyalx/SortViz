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
  Color sortColor = Colors.blue;
  int c = 0;
  List<Color> colors;
  SortingService sortingService = SortingService();
  int s = 0;
  Sort sortingType = Sort.MERGE_SORT;

  @override
  void initState() {
    super.initState();
    colors = [Colors.pink, Colors.teal, Colors.blue];
  }

  @override
  void dispose() {
    sortingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget changeColorButton = FloatingActionButton(
      onPressed: () => setState(() {
        sortColor = colors[c++ % 3];
      }),
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
          max: 1000,
          min: 2,
          onChanged: onArraySizeChanged,
        );

    Widget durationSlider({@required ValueChanged<double> onDurationChange}) =>
        ValueSlider(
          title: "Duration",
          param: "µs",
          value: sortingService.duration.toDouble(),
          max: 5000,
          min: 1,
          onChanged: onDurationChange,
        );

    void showSettings() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: arraySizeSlider(
                      onArraySizeChanged: (double value) {
                        setState(() {
                          sortingService.size = value.round();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: durationSlider(
                      onDurationChange: (double value) {
                        setState(() {
                          sortingService.duration = value.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          });
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

    Widget shuffleButton = IconButton(
      onPressed: sortingService.randomise,
      icon: Icon(
        Icons.shuffle,
        size: 24,
        color: Colors.white,
      ),
    );

    Widget settingsButton = IconButton(
      onPressed: showSettings,
      icon: Icon(
        Icons.settings,
        size: 24,
        color: Colors.white,
      ),
    );

    return Material(
      child: StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            floatingActionButton: changeColorButton,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            appBar: appBar,
            body: LayoutBuilder(
              builder: (context, constrains) {
                sortingService.height = constrains.biggest.height.toInt();

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: shuffleButton,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: settingsButton,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
