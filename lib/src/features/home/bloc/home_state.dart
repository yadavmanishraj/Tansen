// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

enum HomeStatus {
  loading,
  loaded,
  error,
}

final class HomeState  {
  final HomeStatus homeStatus;
  final Map<String, List<BaseModel>>? data;

  const HomeState({
    this.homeStatus = HomeStatus.loading,
    this.data,
  });

  HomeState copyWith({
    HomeStatus? homeStatus,
    Map<String, List<BaseModel>>? data,
  }) {
    return HomeState(
      homeStatus: homeStatus ?? this.homeStatus,
      data: data ?? this.data,
    );
  }
}
