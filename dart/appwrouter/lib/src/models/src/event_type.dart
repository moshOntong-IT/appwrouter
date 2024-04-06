/// Event type from Appwrite Function triggered by event
enum EventType {
  /// Create event type
  create(code: 'create'),

  /// Read event type
  update(code: 'update'),

  /// Delete event type
  delete(code: 'delete');

  const EventType({required this.code});

  /// The code of the EventType
  final String code;

  /// Parsing from String code to EventType
  static EventType fromCode(String code) {
    switch (code) {
      case 'create':
        return EventType.create;
      case 'update':
        return EventType.update;
      case 'delete':
        return EventType.delete;
      default:
        throw Exception('Unknown EventType code: $code');
    }
  }
}
