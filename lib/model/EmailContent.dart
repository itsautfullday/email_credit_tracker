class EmailContent {
  String? from;
  String? emailTextRaw;
  String? subject;
  String? date;
  String? elementType;

  @override
  String toString() {
    return "From : ${from!} subject : ${subject!} date: ${date} type: ${elementType!} email ";
  }
}
