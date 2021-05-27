import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';

class SortingService {
  SortingService({@required int size, @required int microsecondDuration})
      : this._size = size,
        this._duration = microsecondDuration,
        assert(size != null),
        assert(microsecondDuration != null) {
    randomise();
  }

  int _size;
  int _duration;
  final List<int> arr = [];
  final StreamController<List<int>> _streamController =
      StreamController<List<int>>();

  int get size => _size;

  set size(int value) {
    _size = value;
  }

  int get duration => _duration;

  set duration(int value) {
    _duration = value;
  }

  Stream<List<int>> get stream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }

  randomise() {
    arr.clear();
    for (int i = 0; i < _size; i++) {
      arr.add(Random().nextInt(490) + 10);
    }
    _streamController.add(arr);
  }

  // Sorting Algorithms

  // Bubble Sort
  void bubbleSort() async {
    for (int i = 0; i < arr.length; ++i) {
      for (int j = 0; j < arr.length - i - 1; ++j) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: _duration));
        _streamController.add(arr);
      }
    }
  }

  // Selection Sort
  selectionSort() async {
    for (int i = 0; i < arr.length; i++) {
      for (int j = i + 1; j < arr.length; j++) {
        if (arr[i] > arr[j]) {
          int temp = arr[j];
          arr[j] = arr[i];
          arr[i] = temp;
        }
        await Future.delayed(Duration(microseconds: _duration));
        _streamController.add(arr);
      }
    }
  }

  // Insertion Sort
  insertionSort() async {
    for (int i = 1; i < arr.length; i++) {
      int temp = arr[i];
      int j = i - 1;
      while (j >= 0 && temp < arr[j]) {
        arr[j + 1] = arr[j];
        --j;
        await Future.delayed(Duration(microseconds: _duration));
        _streamController.add(arr);
      }
      arr[j + 1] = temp;
      await Future.delayed(Duration(microseconds: _duration));
      _streamController.add(arr);
    }
  }

  // Merge Sort
  mergeSort(int leftIndex, int rightIndex) async {
    Future<void> merge(int leftIndex, int middleIndex, int rightIndex) async {
      int leftSize = middleIndex - leftIndex + 1;
      int rightSize = rightIndex - middleIndex;

      List<int> leftList = List.generate(leftSize, (index) => null);
      List<int> rightList = List.generate(rightSize, (index) => null);

      for (int i = 0; i < leftSize; i++) leftList[i] = arr[leftIndex + i];
      for (int j = 0; j < rightSize; j++)
        rightList[j] = arr[middleIndex + j + 1];

      int i = 0, j = 0;
      int k = leftIndex;

      while (i < leftSize && j < rightSize) {
        if (leftList[i] <= rightList[j]) {
          arr[k] = leftList[i];
          i++;
        } else {
          arr[k] = rightList[j];
          j++;
        }
        await Future.delayed(Duration(microseconds: _duration));
        _streamController.add(arr);
        k++;
      }

      while (i < leftSize) {
        arr[k] = leftList[i];
        i++;
        k++;

        await Future.delayed(Duration(microseconds: _duration));
        _streamController.add(arr);
      }

      while (j < rightSize) {
        arr[k] = rightList[j];
        j++;
        k++;

        await Future.delayed(Duration(microseconds: _duration));
        _streamController.add(arr);
      }
    }

    if (leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;

      await mergeSort(leftIndex, middleIndex);
      await mergeSort(middleIndex + 1, rightIndex);

      await Future.delayed(Duration(microseconds: _duration));

      _streamController.add(arr);

      await merge(leftIndex, middleIndex, rightIndex);
    }
  }

  // Quick Sort
  quickSort(int leftIndex, int rightIndex) async {
    Future<int> _partition(int left, int right) async {
      int p = (left + (right - left) / 2).toInt();

      var temp = arr[p];
      arr[p] = arr[right];
      arr[right] = temp;
      await Future.delayed(Duration(microseconds: _duration));

      _streamController.add(arr);

      int cursor = left;

      for (int i = left; i < right; i++) {
        if (cf(arr[i], arr[right]) <= 0) {
          var temp = arr[i];
          arr[i] = arr[cursor];
          arr[cursor] = temp;
          cursor++;

          await Future.delayed(Duration(microseconds: _duration));

          _streamController.add(arr);
        }
      }

      temp = arr[right];
      arr[right] = arr[cursor];
      arr[cursor] = temp;

      await Future.delayed(Duration(microseconds: _duration));

      _streamController.add(arr);

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
    for (int i = arr.length ~/ 2; i >= 0; i--) {
      await heapify(arr, arr.length, i);
      _streamController.add(arr);
    }
    for (int i = arr.length - 1; i >= 0; i--) {
      int temp = arr[0];
      arr[0] = arr[i];
      arr[i] = temp;
      await heapify(arr, i, 0);
      _streamController.add(arr);
    }
  }

  heapify(List<int> arr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && arr[l] > arr[largest]) largest = l;

    if (r < n && arr[r] > arr[largest]) largest = r;

    if (largest != i) {
      int temp = arr[i];
      arr[i] = arr[largest];
      arr[largest] = temp;
      heapify(arr, n, largest);
    }
    await Future.delayed(Duration(microseconds: _duration));
  }
}
