import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:html/dom_parsing.dart';
import 'package:intl/intl.dart';


class Visitor extends TreeVisitor {
  String result = '';
  @override
  void visitText(Text node) {
    if (node.data.trim().isNotEmpty) {
      result += node.data.trim();
    }
  }

  @override
  void visitElement(Element node) {
    if (isVoidElement(node.localName)) {
      //Void element do nothing
    } else {
      visitChildren(node);
    }
  }

  @override
  void visitChildren(Node node) {
    for (var child in node.nodes) {
      visit(child);
    }
  }
}
