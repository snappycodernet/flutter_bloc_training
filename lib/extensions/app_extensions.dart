import 'package:flutter/material.dart';
import 'package:testing_bloc_course/widgets/iterable_list_view.dart';

extension ToListView<T> on Iterable<T> {
  Widget toListView() => IterableListView(iterable: this);
}