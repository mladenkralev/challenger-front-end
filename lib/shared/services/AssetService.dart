import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/services/ChallengeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/UserManager.dart';

class AssetService {
  late UserManager userManager;
  final challengeService = locator<ChallengeService>();

  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  ImageProvider getImage(int? id) {
    var image = Image.network(BACKEND_AUTH_SERVICE + '/api/v1/blobs/' + id.toString());

    return image.image;
  }
}

