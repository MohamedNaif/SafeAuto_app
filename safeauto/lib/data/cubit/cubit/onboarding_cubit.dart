import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'onboarding_state.dart';

class OnBoardingControllerCubit extends Cubit<OnBoardingControllerState> {
  OnBoardingControllerCubit() : super(OnBoardingControllerInitial());
  int currentIndex = 1;
  getIndex(int i) {
    currentIndex = i;
    emit(OnBoardingControllerInitial());
  }
}
