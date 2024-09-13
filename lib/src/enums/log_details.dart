enum LogDetails {
  compact,
  detailed,
  full,
  none,
  ;

  bool get isCompact => this == LogDetails.compact;

  bool get isDetailed => this == LogDetails.detailed;

  bool get isFull => this == LogDetails.full;

  bool get isNone => this == LogDetails.none;
}
