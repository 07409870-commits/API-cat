import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/breed.dart';
import '../models/cat_fact.dart';

/// A readable error that screens can show directly.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class CatApi {
  static const _base = 'https://catfact.ninja';
  static const _timeout = Duration(seconds: 8);

  /// Shared GET: timeout + status check + JSON decode.
  /// Every failure becomes an [ApiException] so nothing crashes the app.
  Future<Map<String, dynamic>> _getJson(String path) async {
    try {
      final response =
          await http.get(Uri.parse('$_base$path')).timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException('Server replied with status ${response.statusCode}.');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw ApiException('Unexpected response format.');
      }
      return decoded;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('The request timed out. Check your connection.');
    } on SocketException {
      throw ApiException('No internet connection.');
    } on http.ClientException {
      throw ApiException('No internet connection.');
    } on FormatException {
      throw ApiException('Could not read the server response.');
    } catch (_) {
      throw ApiException('Something went wrong.');
    }
  }

  /// Screen 1: fetched once.
  Future<List<Breed>> fetchBreeds({int limit = 30}) async {
    final json = await _getJson('/breeds?limit=$limit');
    final list = json['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => Breed.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Screen 2: one random fact (different each call).
  Future<CatFact> fetchFact() async {
    final json = await _getJson('/fact');
    return CatFact.fromJson(json);
  }

  /// Emits a fact every [every]. A failed fetch is emitted as a stream
  /// *value* (a [FactResult] with an error), never thrown, so the stream
  /// keeps running and recovers when the network comes back.
  Stream<FactResult> factStream(
      {Duration every = const Duration(seconds: 5)}) async* {
    while (true) {
      try {
        yield FactResult.ok(await fetchFact());
      } on ApiException catch (e) {
        yield FactResult.failed(e.message);
      }
      await Future.delayed(every);
    }
  }
}

/// Either a fact or an error message, so errors don't close the stream.
class FactResult {
  final CatFact? fact;
  final String? error;

  const FactResult.ok(CatFact this.fact) : error = null;
  const FactResult.failed(String this.error) : fact = null;
}
