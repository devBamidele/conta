import 'dart:io';

import 'package:conta/utils/extensions.dart';
import 'package:conta/utils/services/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../custom_value_color_anim.dart';

///
/// The [ImageGridTile] widget is used to display an image preview within a grid layout,
/// such as a grid view or a grid-like container. It applies a circular border radius
/// to the image and ensures the image covers the available space within the tile.
///
/// The [mediaUrl] parameter is required and specifies the URL of the image to be displayed.
class ImageGridTile extends StatefulWidget {
  /// The URL of the image to be displayed within the tile.
  final String mediaUrl;

  /// Creates an [ImageGridTile].
  ///
  /// The [mediaUrl] parameter is required.
  /// The [storageDirectory] parameter specifies the directory to use for storing the downloaded images.
  const ImageGridTile({
    Key? key,
    required this.mediaUrl,
  }) : super(key: key);

  @override
  State<ImageGridTile> createState() => _ImageGridTileState();
}

class _ImageGridTileState extends State<ImageGridTile> {
  String? localImagePath;
  late String storageDirectory;
  late String fileName;

  @override
  Future<void> initState() async {
    super.initState();

    fileName = widget.mediaUrl.getFileName();

    storageDirectory = StorageManager.storageDirectory!;

    _checkLocalFile();
  }

  Future<void> _checkLocalFile() async {
    final storageDir = Directory(storageDirectory);
    final localFile = File('${storageDir.path}/$fileName');

    if (await localFile.exists()) {
      setState(() {
        localImagePath = localFile.path;
      });
    } else {
      _downloadAndSaveImage();
    }
  }

  Future<void> _downloadAndSaveImage() async {
    final response = await http.get(Uri.parse(widget.mediaUrl));

    final storageDir =
        await Directory(storageDirectory).create(recursive: true);

    final localFile = await File('${storageDir.path}/$fileName')
        .writeAsBytes(response.bodyBytes);

    setState(() {
      localImagePath = localFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: localImagePath != null
          ? Image.file(
              File(localImagePath!),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: customValueColorAnim(),
              ),
            ),
    );
  }
}
/*
CachedNetworkImage(
                imageUrl: widget.mediaUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                // Widget to display in case of loading error
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    valueColor: customValueColorAnim(),
                  ),
                ),
              ),
 */
