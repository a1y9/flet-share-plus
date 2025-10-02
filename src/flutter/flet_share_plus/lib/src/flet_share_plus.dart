import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// The main class now extends flet.FletControl
class SharePlusControl extends flet.FletControl {
  
  // The new, simpler constructor
  SharePlusControl({required super.parent, required super.id, required super.type});

  // The factory method, which used to be in create_control.dart, is now here
  static SharePlusControl create(Control? parent, String id, String? type) =>
      SharePlusControl(parent: parent, id: id, type: type);

  // This is a non-visual control, so the build method returns an empty widget
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  // This method replaces the old subscribeMethods/handleMethodCall system
  @override
  Future<String?> callMethod(
      String methodName, Map<String, dynamic> args) async {
    switch (methodName) {
      case "share_text":
        return _handleShareText(args);
      case "share_files":
        return _handleShareFiles(args);
      case "share_uri":
        return _handleShareUri(args);
      default:
        // Let the base class handle any other methods
        return super.callMethod(methodName, args);
    }
  }

  // --- The sharing logic methods remain mostly the same ---

  Future<String?> _handleShareText(Map<String, dynamic> args) async {
    final text = args["text"]?.toString() ?? "";
    final subject = args["subject"]?.toString() ?? "";

    try {
      final result = await Share.share(
        text,
        subject: subject,
      );

      _handleShareResult(result);
      return result.status.name;
    } catch (e) {
      debugPrint("Share error: $e");
      return "error: $e";
    }
  }

  Future<String?> _handleShareFiles(Map<String, dynamic> args) async {
    final filePaths = (args["filePaths"]?.toString() ?? "")
        .split(",")
        .where((path) => path.isNotEmpty)
        .toList();
    final text = args["text"]?.toString() ?? "";

    if (filePaths.isEmpty) {
      return "error: No files to share";
    }

    try {
      final files = filePaths.map((path) => XFile(path)).toList();
      final result = await Share.shareXFiles(
        files,
        text: text,
      );

      _handleShareResult(result);
      return result.status.name;
    } catch (e) {
      debugPrint("Share files error: $e");
      return "error: $e";
    }
  }

  Future<String?> _handleShareUri(Map<String, dynamic> args) async {
    final uriString = args["uri"]?.toString() ?? "";

    if (uriString.isEmpty) {
      return "error: URI is empty";
    }

    try {
      final uri = Uri.parse(uriString);
      final result = await Share.shareUri(uri);

      _handleShareResult(result);
      return result.status.name;
    } catch (e) {
      debugPrint("Share URI error: $e");
      return "error: $e";
    }
  }

  void _handleShareResult(ShareResult result) {
    if (result.status == ShareResultStatus.success) {
      // Use the inherited 'backend' property to trigger events
      backend.triggerControlEvent(id, "share_completed", result.raw);
    } else if (result.status == ShareResultStatus.dismissed) {
      backend.triggerControlEvent(id, "share_dismissed", result.raw);
    }
  }
}