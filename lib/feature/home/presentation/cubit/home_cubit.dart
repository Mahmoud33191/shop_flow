import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/feature/home/presentation/cubit/home_states.dart';

class HomeCubit extends Cubit<ProductsState> {
  HomeCubit() : super(ProductsInitial());
  void fetchProducts() {
    emit(ProductsLoading());
  }

}