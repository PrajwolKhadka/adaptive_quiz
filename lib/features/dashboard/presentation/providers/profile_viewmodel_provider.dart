import 'package:adaptive_quiz/features/dashboard/presentation/state/profile_state.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/view_model/profile_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileViewModelProvider =
NotifierProvider<ProfileViewModel, ProfileState>(
      () => ProfileViewModel(),
);
