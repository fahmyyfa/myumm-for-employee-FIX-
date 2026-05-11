class ObeJurnalItem {
  final String refId;
  final String date;
  final String room;
  final String time;
  final String topic;
  final String subTopic;
  final int presentCount;
  final int absentCount;

  ObeJurnalItem({
    required this.refId,
    required this.date,
    required this.room,
    required this.time,
    required this.topic,
    required this.subTopic,
    required this.presentCount,
    required this.absentCount,
  });
}
