class EmailContent {
  String? from;
  String? emailTextRaw;
  String? subject;
  String? date; //TODO Rethink?

  @override
  String toString() {
    return "From : ${from!} subject : ${subject!} ";
  }
}
