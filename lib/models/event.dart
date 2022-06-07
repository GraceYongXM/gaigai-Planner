class Event {
  late int? id;

  Event(
    this.id,
  );

  Event.fromMap(dynamic obj) {
    id = obj['id'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
    };
  }
}
