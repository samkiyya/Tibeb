class BookCardHelpers {
  static String formatReadingTime(int minutes) {
    if (minutes < 60) return '~$minutes min left';

    if (minutes < 1440) {
      final hours = (minutes / 60).floor();
      final mins = minutes % 60;
      if (mins == 0) return '~$hours hr left';
      return '~$hours hr $mins min left';
    }

    final days = (minutes / 1440).floor();
    return '~$days day${days > 1 ? 's' : ''} left';
  }

  static String formatLastRead(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return 'Read ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Read ${diff.inHours}h ago';
    if (diff.inDays < 7) return 'Read ${diff.inDays}d ago';

    return 'Read on ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}