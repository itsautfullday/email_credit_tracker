class EmailContent {
  String? from;
  String? to;
  String? emailTextRaw;

  @override
  String toString() {
    return "From : ${from!} to: ${to!} email; ${emailTextRaw!}";
  }
}
