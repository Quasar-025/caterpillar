enum AlertLevel { info, attention, action, critical }

extension AlertLevelX on AlertLevel {
  String get label => switch (this) {
    AlertLevel.info => 'INFO',
    AlertLevel.attention => 'ATTENTION',
    AlertLevel.action => 'ACTION',
    AlertLevel.critical => 'CRITICAL',
  };

  int get rank => index;
}
