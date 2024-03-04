import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'UserManager.dart';

class AssetService {
  late UserManagerService userManager;
  final challengeService = locator<AssignedChallengeService>();

  static String HTTP_BACKEND_SERVICE = "http://localhost:8080";
  static String ASSET_SUFFIX = "/api/v1/blobs/";

  Map<int, Image> inMemoryImages = {};

  AssetService() {
    if (kIsWeb) {
      //web
      HTTP_BACKEND_SERVICE = "http://localhost:8080";
    } else {
      //phone
      HTTP_BACKEND_SERVICE = "http://10.0.2.2:8080";
    }
  }

  CachedNetworkImageProvider getImage(int? id) {

    var url = HTTP_BACKEND_SERVICE + ASSET_SUFFIX + id.toString();

    CachedNetworkImageProvider imageProvider = new CachedNetworkImageProvider(url);

    return imageProvider;
  }

  Image getImageFromInMemory(int? id) {
    return inMemoryImages[id]!;
  }
}
