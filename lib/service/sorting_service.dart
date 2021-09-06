import 'dart:async';
import 'dart:math';

enum Sort {
  MERGE_SORT,
  QUICK_SORT,
  SELECTION_SORT,
  BUBBLE_SORT,
  INSERTION_SORT,
  HEAP_SORT
}

extension SortExtension on Sort {
  String get name {
    return this
        .toString()
        .split(".")[1]
        .split("_")
        .map((str) => str.toLowerCase())
        .map((str) => str[0].toUpperCase() + str.substring(1))
        .join(" ");
  }
}

class SortingService {
  bool _pause = true;
  int _size = 50;
  int _height;
  int duration = 40;
  final List<int> arr = [];
  final StreamController<List<int>> _streamController =
      StreamController<List<int>>();

  Stream<List<int>> get stream => _streamController.stream;

  bool get pause => _pause;

  set size(int size) {
    this._size = size;
    shuffle();
  }

  int get size => _size;

  set height(int height) {
    this._height = height;
  }

  void dispose() {
    _streamController.close();
  }

  shuffle() {
    _pause = true;

    arr.clear();

    for (int i = 0; i < _size; i++) {
      arr.add(Random().nextInt(_height - 40) + 20);
    }

    _streamController.add(arr);
  }

  void sort(Sort sort) async {
    _pause = false;

    switch (sort) {
      case Sort.MERGE_SORT:
        await mergeSort(0, _size - 1);
        break;
      case Sort.QUICK_SORT:
        await quickSort(0, _size - 1);
        break;
      case Sort.SELECTION_SORT:
        await selectionSort();
        break;
      case Sort.BUBBLE_SORT:
        await bubbleSort();
        break;
      case Sort.INSERTION_SORT:
        await insertionSort();
        break;
      case Sort.HEAP_SORT:
        await heapSort();
        break;
    }

    _pause = true;
  }

  // Sorting Algorithms

  /// Bubble Sort
  bubbleSort() async {
    for (int i = 0; i < arr.length; ++i) {
      for (int j = 0; j < arr.length - i - 1; ++j) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }

        if (!_pause) {
          await Future.delayed(Duration(milliseconds: duration))
              .then((_) => _streamController.add(arr));
        } else {
          return;
        }
      }
    }
  }

  /// Selection Sort
  selectionSort() async {
    for (int i = 0; i < arr.length; i++) {
      for (int j = i + 1; j < arr.length; j++) {
        if (arr[i] > arr[j]) {
          int temp = arr[j];
          arr[j] = arr[i];
          arr[i] = temp;
        }

        if (!_pause) {
          await Future.delayed(Duration(milliseconds: duration))
              .then((_) => _streamController.add(arr));
        } else {
          return;
        }
      }
    }
  }

  /// Insertion Sort
  insertionSort() async {
    for (int i = 1; i < arr.length; i++) {
      int temp = arr[i];
      int j = i - 1;

      while (j >= 0 && temp < arr[j]) {
        arr[j + 1] = arr[j];
        --j;

        if (!_pause) {
          await Future.delayed(Duration(milliseconds: duration))
              .then((_) => _streamController.add(arr));
        } else {
          return;
        }
      }

      arr[j + 1] = temp;

      if (!_pause) {
        await Future.delayed(Duration(milliseconds: duration))
            .then((_) => _streamController.add(arr));
      } else {
        return;
      }
    }
  }

  /// Merge Sort
  mergeSort(int leftIndex, int rightIndex) async {
    Future<void> merge(int leftIndex, int middleIndex, int rightIndex) async {
      int leftSize = middleIndex - leftIndex + 1;
      int rightSize = rightIndex - middleIndex;

      List<int> leftList = List.generate(leftSize, (index) => null);
      List<int> rightList = List.generate(rightSize, (index) => null);

      for (int i = 0; i < leftSize; i++) {
        leftList[i] = arr[leftIndex + i];
      }

      for (int j = 0; j < rightSize; j++) {
        rightList[j] = arr[middleIndex + j + 1];
      }

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

        k++;

        if (!_pause) {
          await Future.delayed(Duration(milliseconds: duration))
              .then((_) => _streamController.add(arr));
        } else {
          return;
        }
      }

      while (i < leftSize) {
        arr[k] = leftList[i];
        i++;
        k++;

        if (!_pause) {
          await Future.delayed(Duration(milliseconds: duration))
              .then((_) => _streamController.add(arr));
        } else {
          return;
        }
      }

      while (j < rightSize) {
        arr[k] = rightList[j];
        j++;
        k++;

        if (!_pause) {
          await Future.delayed(Duration(milliseconds: duration))
              .then((_) => _streamController.add(arr));
        } else {
          return;
        }
      }
    }

    if (!_pause && leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;

      await mergeSort(leftIndex, middleIndex);

      if (!_pause) {
        await mergeSort(middleIndex + 1, rightIndex);
      }

      if (!_pause) {
        await Future.delayed(Duration(milliseconds: duration))
            .then((_) => _streamController.add(arr));
      }

      if (!_pause) {
        await merge(leftIndex, middleIndex, rightIndex);
      }
    }
  }

  /// Quick Sort
  quickSort(int leftIndex, int rightIndex) async {
    Future<int> _partition(int left, int right) async {
      int p = (left + (right - left) / 2).toInt();

      var temp = arr[p];
      arr[p] = arr[right];
      arr[right] = temp;

      if (!_pause) {
        await Future.delayed(Duration(milliseconds: duration))
            .then((_) => _streamController.add(arr));
      } else {
        return Future.value(0);
      }

      int cursor = left;

      for (int i = left; i < right; i++) {
        if (cf(arr[i], arr[right]) <= 0) {
          var temp = arr[i];
          arr[i] = arr[cursor];
          arr[cursor] = temp;
          cursor++;

          if (!_pause) {
            await Future.delayed(Duration(milliseconds: duration))
                .then((_) => _streamController.add(arr));
          } else {
            break;
          }
        }
      }

      temp = arr[right];
      arr[right] = arr[cursor];
      arr[cursor] = temp;

      if (!_pause) {
        await Future.delayed(Duration(milliseconds: duration))
            .then((_) => _streamController.add(arr));
      }

      return cursor;
    }

    if (!_pause && leftIndex < rightIndex) {
      int p = await _partition(leftIndex, rightIndex);

      if (!_pause) {
        await quickSort(leftIndex, p - 1);
      }

      if (!_pause) {
        await quickSort(p + 1, rightIndex);
      }
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

  /// Heap Sort
  heapSort() async {
    for (int i = arr.length ~/ 2; i >= 0; i--) {
      if (!_pause) {
        await heapify(arr, arr.length, i);
      } else {
        break;
      }
    }

    for (int i = arr.length - 1; i >= 0; i--) {
      int temp = arr[0];
      arr[0] = arr[i];
      arr[i] = temp;

      if (!_pause) {
        await heapify(arr, i, 0);
      } else {
        break;
      }
    }
  }

  heapify(List<int> arr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && arr[l] > arr[largest]) {
      largest = l;
    }

    if (r < n && arr[r] > arr[largest]) {
      largest = r;
    }

    if (largest != i) {
      int temp = arr[i];
      arr[i] = arr[largest];
      arr[largest] = temp;
      heapify(arr, n, largest);
    }

    if (!_pause) {
      await Future.delayed(Duration(milliseconds: duration))
          .then((_) => _streamController.add(arr));
    } else {
      return;
    }
  }
}
