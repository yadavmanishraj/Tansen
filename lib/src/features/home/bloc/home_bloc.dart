import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muisc_repository/muisc_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MusicRepository _musicRepository;
  HomeBloc(this._musicRepository) : super(const HomeState()) {
    on<HomeEventInitial>((event, emit) async {
      try {
        final data = await _musicRepository.getHome();
        emit(HomeState(data: data, homeStatus: HomeStatus.loaded));
      } catch (e) {
        emit(state.copyWith(homeStatus: HomeStatus.error));
      }
    });

    add(HomeEventInitial());
  }
}
