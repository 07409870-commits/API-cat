/// One random fact from GET https://catfact.ninja/fact
class CatFact {
  final String fact;
  final int length;

  const CatFact({required this.fact, required this.length});

  factory CatFact.fromJson(Map<String, dynamic> json) {
    return CatFact(
      fact: json['fact'] as String? ?? '',
      length: json['length'] as int? ?? 0,
    );
  }
}
