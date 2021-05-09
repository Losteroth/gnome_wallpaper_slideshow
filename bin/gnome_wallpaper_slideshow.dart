import 'dart:io';
import 'package:xml/xml.dart';

void main(List<String> arguments) {
  if (!Directory(arguments[0]).existsSync()) {
    print("Can't find directory");
  } else {
    generateXMLs(arguments);
  }
}

void generateXMLs(List<String> args) {
  var envVars = Platform.environment;
  var slideshowConfig = File(args[0] + '/' + args[1] + '.xml');
  var filesRaw = Directory(args[0]).listSync();
  var files = filesRaw
      .where((element) => (element.path.toString().endsWith('.jpg') |
          element.path.toString().endsWith('.png') |
          element.path.toString().endsWith('.xcf') |
          element.path.toString().endsWith('.svg')))
      .toList();

  if (files.isNotEmpty) {
    final slideshowXmlBuilder = XmlBuilder();
    final gnomeBackgroundProretiesXmlBuilder = XmlBuilder();

    slideshowXmlBuilder.processing('xml', 'version="1.0"');
    slideshowXmlBuilder.element('background', nest: () {
      for (var i = 0; i < files.length; i++) {
        slideshowXmlBuilder.element('static', nest: () {
          slideshowXmlBuilder.element('duration', nest: double.parse(args[2]));
          slideshowXmlBuilder.element('file', nest: files[i].path.toString());
        });
        slideshowXmlBuilder.element('transition', nest: () {
          slideshowXmlBuilder.element('duration', nest: double.parse(args[3]));
          slideshowXmlBuilder.element('from', nest: files[i].path.toString());
          if (i == files.length - 1) {
            slideshowXmlBuilder.element('to', nest: files[0].path.toString());
          } else {
            slideshowXmlBuilder.element('to', nest: files[i + 1].path.toString());
          }
        });
      }
    });
    slideshowConfig.writeAsStringSync(slideshowXmlBuilder.buildDocument().toXmlString(pretty: true));

    var slideshowListContent = XmlDocument();
    var gnomBackgraundPropertiesDir = Directory(envVars['HOME'] + '/.local/share/gnome-background-properties');
    if (!gnomBackgraundPropertiesDir.existsSync()) gnomBackgraundPropertiesDir.createSync();
    var slideshowList = File(envVars['HOME'] + '/.local/share/gnome-background-properties/slideshow.xml');
    if (slideshowList.existsSync()) {
      slideshowListContent = XmlDocument.parse(slideshowList.readAsStringSync());
      if (!slideshowListContent.firstElementChild.children
          .toList()
          .toString()
          .contains('<name>' + args[1] + '</name>')) {
        gnomeBackgroundProretiesXmlBuilder.element('wallpaper', nest: () {
          gnomeBackgroundProretiesXmlBuilder.element('name', nest: args[1]);
          gnomeBackgroundProretiesXmlBuilder.element('filename', nest: (args[0] + '/' + args[1] + '.xml'));
          gnomeBackgroundProretiesXmlBuilder.element('options', nest: 'zoom');
        });
        slideshowListContent.firstElementChild.children.add(gnomeBackgroundProretiesXmlBuilder.buildFragment());
      }
    } else {
      gnomeBackgroundProretiesXmlBuilder.processing('xml', 'version="1.0" encoding="UTF-8"');
      gnomeBackgroundProretiesXmlBuilder.xml('<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">');
      gnomeBackgroundProretiesXmlBuilder.element('wallpapers', nest: () {
        gnomeBackgroundProretiesXmlBuilder.element('wallpaper', nest: () {
          gnomeBackgroundProretiesXmlBuilder.element('name', nest: args[1]);
          gnomeBackgroundProretiesXmlBuilder.element('filename', nest: (args[0] + '/' + args[1] + '.xml'));
          gnomeBackgroundProretiesXmlBuilder.element('options', nest: 'zoom');
        });
      });
      slideshowListContent = gnomeBackgroundProretiesXmlBuilder.buildDocument();
    }

    slideshowList.writeAsStringSync(slideshowListContent.toXmlString(pretty: true));
  }
}
