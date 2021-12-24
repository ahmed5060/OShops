// ignore_for_file: file_names, prefer_typing_uninitialized_variables

part of 'api_services_cubit.dart';

@immutable
abstract class ApiServicesStates {}

class ApiServicesInitialState extends ApiServicesStates {}

class SuccessResetPasswordState extends ApiServicesStates {
  final message;
  SuccessResetPasswordState({required this.message});
}

class FailedRestPasswordState extends ApiServicesStates {
  final error;
  FailedRestPasswordState({required this.error});
}

class EditProfileSuccessState extends ApiServicesStates {
  final String message;
  EditProfileSuccessState({required this.message});
}

class EditProfileUnSuccessState extends ApiServicesStates {
  final String error;
  EditProfileUnSuccessState({required this.error});
}

class SuccessAddAdressState extends ApiServicesStates {
  final String message;
  SuccessAddAdressState({required this.message});
}

class UnSucessAddedAdderessState extends ApiServicesStates {
  final String error;
  UnSucessAddedAdderessState({required this.error});
}

class UserInfoLoadingSate extends ApiServicesStates {}

class UserInfoLoadedState extends ApiServicesStates {
  final data;
  UserInfoLoadedState({required this.data});
}

class UserInfoUnLoadedState extends ApiServicesStates {
  final String error;
  UserInfoUnLoadedState({required this.error});
}

class SearchItemFoundState extends ApiServicesStates {
  final List<Map<String, dynamic>> items;
  SearchItemFoundState({required this.items});
}

class SearchItemNotFoundState extends ApiServicesStates {
  final String error;
  SearchItemNotFoundState({required this.error});
}
