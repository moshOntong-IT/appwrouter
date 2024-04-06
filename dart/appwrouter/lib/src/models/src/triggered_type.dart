/// TriggeredType enum
enum TriggeredType {
  /// event
  event(code: 'event'),

  /// http
  http(code: 'http'),

  /// schedule
  schedule(code: 'schedule');

  const TriggeredType({required this.code});

  /// The code of the TriggeredType
  final String code;

  /// Parsing from String code to TriggeredType
  static TriggeredType fromCode(String code) {
    switch (code) {
      case 'event':
        return TriggeredType.event;
      case 'http':
        return TriggeredType.http;
      case 'schedule':
        return TriggeredType.schedule;
      default:
        throw Exception('Unknown TriggeredType code: $code');
    }
  }
}
