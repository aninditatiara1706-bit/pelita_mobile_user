class AiMessageModel {
  final String role;
  final String text;

  const AiMessageModel({required this.role, required this.text});

  bool get isUser => role == 'user';
}
