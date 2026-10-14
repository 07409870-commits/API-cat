# Cat Belt

Flutter app for CC 105 "Pick Your Own API". Uses the free, keyless
[Cat Facts API](https://catfact.ninja).

| Screen | Widget | Endpoint |
|---|---|---|
| The Order | FutureBuilder | `GET /breeds?limit=30` (fetched once, Retry button) |
| The Belt | StreamBuilder | `GET /fact` (random, polled every 5 s) |

## Run
```
flutter create .      # generates android/ios/etc. (keeps lib/ and pubspec.yaml)
flutter pub get
flutter run
```

## Design notes
- `CatApi._getJson` applies an 8 s timeout, checks `statusCode == 200`, and
  converts every failure into an `ApiException`.
- The stream yields errors as values (`FactResult.failed`) instead of throwing,
  so one failed fetch never ends it; it recovers when the network returns.
- Futures/streams are created in `initState`, never in `build`.
