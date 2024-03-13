// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EmailContent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailContent _$EmailContentFromJson(Map<String, dynamic> json) => EmailContent()
  ..from = json['from'] as String?
  ..emailTextRaw = json['emailTextRaw'] as String?
  ..subject = json['subject'] as String?
  ..date = json['date'] as String?
  ..elementType = json['elementType'] as String?;

Map<String, dynamic> _$EmailContentToJson(EmailContent instance) =>
    <String, dynamic>{
      'from': instance.from,
      'emailTextRaw': instance.emailTextRaw,
      'subject': instance.subject,
      'date': instance.date,
      'elementType': instance.elementType,
    };
