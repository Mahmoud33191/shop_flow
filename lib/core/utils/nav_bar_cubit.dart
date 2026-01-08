import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  // Start at the first tab (index 0)
  NavigationCubit() : super(0);

  void updateIndex(int index) => emit(index);
}