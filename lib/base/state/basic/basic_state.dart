import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'basic_state.g.dart';

enum UiState { initial, loading, successful, error, empty, cancelled }

extension UiStateX on UiState {
  bool get isInitial => this == UiState.initial;

  bool get isLoading => this == UiState.loading;

  bool get isSuccessful => this == UiState.successful;

  bool get isError => this == UiState.error;

  bool get isEmpty => this == UiState.empty;

  bool get isCancelled => this == UiState.cancelled;
}

enum UserAuthState { authenticated, unauthenticated }

extension UserAuthStateX on UserAuthState {
  bool get isAuthenticated => this == UserAuthState.authenticated;

  bool get isUnauthenticated => this == UserAuthState.unauthenticated;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BasicState extends Equatable {
  final UiState uiState;
  final String? message;

  const BasicState({
    this.uiState = UiState.initial,
    this.message,
  });

  factory BasicState.fromJson(Map<String, dynamic> json) =>
      _$BasicStateFromJson(json);

  Map<String, dynamic> toJson() => _$BasicStateToJson(this);

  BasicState copyWith({
    UiState? uiState,
    String? message,
  }) {
    return BasicState(
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [uiState, message];
}
