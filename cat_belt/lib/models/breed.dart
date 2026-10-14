/// One cat breed from GET https://catfact.ninja/breeds
class Breed {
  final String name;
  final String country;
  final String origin;
  final String coat;
  final String pattern;

  const Breed({
    required this.name,
    required this.country,
    required this.origin,
    required this.coat,
    required this.pattern,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      name: json['breed'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      coat: json['coat'] as String? ?? '',
      pattern: json['pattern'] as String? ?? '',
    );
  }
}
