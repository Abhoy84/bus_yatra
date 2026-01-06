class Ticket {
  String busname,
      start,
      end,
      id,
      seat,
      date,
      time,
      amount,
      status,
      username,
      busid,
      userid;
  final DateTime? timestamp;

  Ticket({
    required this.busname,
    required this.start,
    required this.end,
    required this.id,
    required this.seat,
    required this.date,
    required this.time,
    required this.amount,
    required this.status,
    required this.username,
    required this.busid,
    required this.userid,
    this.timestamp,
  });
}
