import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offer_today/pages/dashboard/dashboard_state.dart';

class DashboardPageCubit extends Cubit<DashboardPageState> {
  DashboardPageState localData;
  DashboardPageCubit() : super(DashboardPageState(selectedTab: 0));

  void onItemTapped() {
    emit(DashboardPageState(selectedTab: 2));
  }
}
