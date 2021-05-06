import 'dart:io';
import 'package:xml/xml.dart';

void main(List<String> arguments) {
  if (!Directory(arguments[0]).existsSync()) {
    print("Can't find directory");
  } else {
    generateXML(arguments);
  }
}

void generateXML(List<String> args) {
  var files = Directory(args[0]).listSync();
  var file = File(args[0] + '/' + args[1] + '.xml');

  if (files.isNotEmpty) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('background', nest: () {
      for (var i = 0; i < files.length; i++) {
        builder.element('static', nest: () {
          builder.element('duration', nest: double.parse(args[2]));
          builder.element('file', nest: files[i].toString().replaceAll('File: ', ''));
        });
        builder.element('transition', nest: () {
          builder.element('duration', nest: double.parse(args[3]));
          builder.element('from', nest: files[i].toString().replaceAll('File: ', ''));
          if (i == files.length - 1) {
            builder.element('to', nest: files[0].toString().replaceAll('File: ', ''));
          } else {
            builder.element('to', nest: files[i + 1].toString().replaceAll('File: ', ''));
          }
        });
      }
    });
    if (file.existsSync()) {
      file.openWrite();
    } else {
      file.createSync();
      file.openWrite();
    }
    file.writeAsStringSync(builder.buildDocument().toXmlString());
  }
}
