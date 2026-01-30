class ProfileState {
  final bool isLoading;
  final String? error;
  final String? fullName;
  final String? email;
  final String? className;
  final String? imageUrl;
  final String? localImagePath;

  ProfileState({
    required this.isLoading,
    this.error,
    this.fullName,
    this.email,
    this.className,
    this.imageUrl,
    this.localImagePath,
  });

  factory ProfileState.initial() => ProfileState(isLoading: false);

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    String? fullName,
    String? email,
    String? className,
    String? imageUrl,
    String? localImagePath,
    bool clearLocalPath = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      className: className ?? this.className,
      imageUrl: imageUrl ?? this.imageUrl,
      // localImagePath: localImagePath ?? this.localImagePath,
      localImagePath: clearLocalPath
          ? null
          : (localImagePath ?? this.localImagePath),
    );
  }
}
