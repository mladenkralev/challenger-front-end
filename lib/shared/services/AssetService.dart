import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'UserManager.dart';

class AssetService {
  late UserManagerService userManager;
  final challengeService = locator<AssignedChallengeService>();

  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  Map<int, Image> inMemoryImages = {};

  CachedNetworkImageProvider getImage(int? id) {

    var url = BACKEND_AUTH_SERVICE + '/api/v1/blobs/' + id.toString();

    // CachedNetworkImage cachedNetworkImage = new CachedNetworkImage(
    //   imageUrl: url,
    //   imageBuilder: (context, imageProvider) => Container(
    //     height: 100,
    //     width: 100,
    //     decoration: new BoxDecoration(
    //         image: new DecorationImage(
    //           colorFilter: new ColorFilter.mode(
    //               Colors.black.withOpacity(0.5), BlendMode.dstATop),
    //           fit: BoxFit.cover,
    //           image: imageProvider,
    //         ),
    //         borderRadius: BorderRadius.circular(25)),
    //   ),
    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
    //       CircularProgressIndicator(value: downloadProgress.progress),
    // );
    CachedNetworkImageProvider imageProvider = new CachedNetworkImageProvider(url);

    return imageProvider;
  }

  Image getImageFromInMemory(int? id) {
    return inMemoryImages[id]!;
  }
}
