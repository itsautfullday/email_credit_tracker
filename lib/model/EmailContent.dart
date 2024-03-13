import 'package:json_annotation/json_annotation.dart';
part 'EmailContent.g.dart';

@JsonSerializable()
class EmailContent {
  String? from;
  String? emailTextRaw;
  String? subject;
  String? date;
  String? elementType;

  EmailContent();

  @override
  String toString() {
    return "From : ${from!} subject : ${subject!} date: ${date} type: ${elementType!} email ";
  }

  factory EmailContent.fromJson(Map<String, dynamic> json) =>
      _$EmailContentFromJson(json);

  Map<String, dynamic> toJson() => _$EmailContentToJson(this);
}
