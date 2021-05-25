import 'dart:async';
import 'dart:math';
import 'package:sortviz/components/cardView.dart';
import 'package:flutter/material.dart';
import 'package:sortviz/components/barPainter.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TestScreen createState() => _TestScreen();
}

class _TestScreen extends State<TestScreen> {
  Color sortColor = Colors.blue;
  int c = 0;
  List<Color> colors = List.generate(3, (index) => null);

  int s = 0;
  int arraysize = 400;
  var duration = 3000;
  String dropdownValue = "Merge Sort";
  List<int> nums = [];
  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;

  _makeColors() {
    colors[0] = Colors.pink;
    colors[1] = Colors.teal;
    colors[2] = Colors.blue;
  }

  _changeButtonColor() {
    if (c == 3) c = 0;
    sortColor = colors[c++];
  }

  void handleClick(String value) {
    switch (value) {
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
    }
  }

  menu() {}
  randomise() {
    nums.clear();
    for (int i = 0; i < arraysize; i++) {
      nums.add(Random().nextInt(490) + 10);
    }
    _streamController.add(nums);
  }

  // Sorting Algorithms

  // Bubble Sort
  bubblesort() async {
    for (int i = 0; i < nums.length; ++i) {
      for (int j = 0; j < nums.length - i - 1; ++j) {
        if (nums[j] > nums[j + 1]) {
          int temp = nums[j];
          nums[j] = nums[j + 1];
          nums[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: duration));
        _streamController.add(nums);
      }
    }
  }

  // Selection Sort
  selectionSort() async {
    for (int i = 0; i < nums.length; i++) {
      for (int j = i + 1; j < nums.length; j++) {
        if (nums[i] > nums[j]) {
          int temp = nums[j];
          nums[j] = nums[i];
          nums[i] = temp;
        }
        await Future.delayed(Duration(microseconds: duration));
        _streamController.add(nums);
      }
    }
  }

  // Insertion Sort
  insertionSort() async {
    for (int i = 1; i < nums.length; i++) {
      int temp = nums[i];
      int j = i - 1;
      while (j >= 0 && temp < nums[j]) {
        nums[j + 1] = nums[j];
        --j;
        await Future.delayed(Duration(microseconds: duration));
        _streamController.add(nums);
      }
      nums[j + 1] = temp;
      await Future.delayed(Duration(microseconds: duration));
      _streamController.add(nums);
    }
  }

  // Merge Sort
  mergeSort(int leftIndex, int rightIndex) async {
    Future<void> merge(int leftIndex, int middleIndex, int rightIndex) async {
      int leftSize = middleIndex - leftIndex + 1;
      int rightSize = rightIndex - middleIndex;

      List leftList = new List(leftSize);
      List rightList = new List(rightSize);

      for (int i = 0; i < leftSize; i++) leftList[i] = nums[leftIndex + i];
      for (int j = 0; j < rightSize; j++)
        rightList[j] = nums[middleIndex + j + 1];

      int i = 0, j = 0;
      int k = leftIndex;

      while (i < leftSize && j < rightSize) {
        if (leftList[i] <= rightList[j]) {
          nums[k] = leftList[i];
          i++;
        } else {
          nums[k] = rightList[j];
          j++;
        }
        await Future.delayed(Duration(microseconds: duration));
        _streamController.add(nums);
        k++;
      }

      while (i < leftSize) {
        nums[k] = leftList[i];
        i++;
        k++;

        await Future.delayed(Duration(microseconds: duration));
        _streamController.add(nums);
      }

      while (j < rightSize) {
        nums[k] = rightList[j];
        j++;
        k++;

        await Future.delayed(Duration(microseconds: duration));
        _streamController.add(nums);
      }
    }

    if (leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;

      await mergeSort(leftIndex, middleIndex);
      await mergeSort(middleIndex + 1, rightIndex);

      await Future.delayed(Duration(microseconds: duration));

      _streamController.add(nums);

      await merge(leftIndex, middleIndex, rightIndex);
    }
  }

  // Quick Sort
  quickSort(int leftIndex, int rightIndex) async {
    Future<int> _partition(int left, int right) async {
      int p = (left + (right - left) / 2).toInt();

      var temp = nums[p];
      nums[p] = nums[right];
      nums[right] = temp;
      await Future.delayed(Duration(microseconds: duration));

      _streamController.add(nums);

      int cursor = left;

      for (int i = left; i < right; i++) {
        if (cf(nums[i], nums[right]) <= 0) {
          var temp = nums[i];
          nums[i] = nums[cursor];
          nums[cursor] = temp;
          cursor++;

          await Future.delayed(Duration(microseconds: duration));

          _streamController.add(nums);
        }
      }

      temp = nums[right];
      nums[right] = nums[cursor];
      nums[cursor] = temp;

      await Future.delayed(Duration(microseconds: duration));

      _streamController.add(nums);

      return cursor;
    }

    if (leftIndex < rightIndex) {
      int p = await _partition(leftIndex, rightIndex);

      await quickSort(leftIndex, p - 1);

      await quickSort(p + 1, rightIndex);
    }
  }

  cf(int a, int b) {
    if (a < b) {
      return -1;
    } else if (a > b) {
      return 1;
    } else {
      return 0;
    }
  }

  // Heap Sort
  heapSort() async {
    for (int i = nums.length ~/ 2; i >= 0; i--) {
      await heapify(nums, nums.length, i);
      _streamController.add(nums);
    }
    for (int i = nums.length - 1; i >= 0; i--) {
      int temp = nums[0];
      nums[0] = nums[i];
      nums[i] = temp;
      await heapify(nums, i, 0);
      _streamController.add(nums);
    }
  }

  heapify(List<int> arr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && arr[l] > arr[largest]) largest = l;

    if (r < n && arr[r] > arr[largest]) largest = r;

    if (largest != i) {
      int temp = nums[i];
      nums[i] = nums[largest];
      nums[largest] = temp;
      heapify(arr, n, largest);
    }
    await Future.delayed(Duration(microseconds: duration));
  }

  @override
  void initState() {
    super.initState();
    _makeColors();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
    randomise();
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
          backgroundColor: Colors.black,
          title: Text(
            "Sorting Visualiser",
            style: TextStyle(
              fontSize: 19.0,
            ),
          ),
          actions: <Widget>[
            new DropdownButtonHideUnderline(
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
              StreamBuilder<Object>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    int ind = 0;
                    return Row(
                      children: nums.map((int number) {
                        ind++;
                        return CustomPaint(
                          painter: ArrayBar(
                            sortColor: sortColor,
                            width:
                                MediaQuery.of(context).size.width / arraysize,
                            height: number,
                            index: ind,
                          ),
                        );
                      }).toList(),
                    );
                  }),
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
                      padding: EdgeInsets.only(bottom: 16, right: 8),
                      shadowColor: Colors.black),
                  // color: Colors.white,
                  // padding: EdgeInsets.all(7),
                  // shape: CircleBorder(),
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
                color: Colors.black,
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
                              await mergeSort(0, arraysize - 1);
                              break;
                            case 1:
                              await quickSort(0, arraysize - 1);
                              break;
                            case 2:
                              selectionSort();
                              break;
                            case 3:
                              bubblesort();
                              break;
                            case 4:
                              insertionSort();
                              break;
                            case 5:
                              await heapSort();
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
                        onPressed: randomise,
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
                          setState(() {
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
                                                      arraysize.toString(),
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
                                                    value: arraysize.toDouble(),
                                                    inactiveColor: Colors.white,
                                                    onChanged: (double value) {
                                                      setState(() {
                                                        arraysize =
                                                            value.round();
                                                        randomise();
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
                                                      duration.toString(),
                                                      style: TextStyle(
                                                        fontSize: 24.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ms",
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
                                                    value: duration.toDouble(),
                                                    inactiveColor: Colors.white,
                                                    onChanged: (double value) {
                                                      setState(() {
                                                        duration =
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
                                  });
                                });
                          });
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
        ));
  }
}
