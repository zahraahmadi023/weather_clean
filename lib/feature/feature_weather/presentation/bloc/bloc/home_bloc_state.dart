part of 'home_bloc_bloc.dart';

class HomeState {
  CwStatuse cwStatuse;
  FwStatus fwStatus;
  HomeState({
    required this.cwStatuse,
    required this.fwStatus
  });
  HomeState copyWith({
    CwStatuse? newWStatuse  ,
    FwStatus ? newFStatuse, 
  }) {

    return HomeState(
      cwStatuse: newWStatuse ?? cwStatuse,
      fwStatus:newFStatuse ?? fwStatus
      );
  }
}
