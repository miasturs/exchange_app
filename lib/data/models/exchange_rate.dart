class ExchangeRate {
  final String base;
  final DateTime date;
  final Map<String, double> rates;

  ExchangeRate({
    required this.base,
    required this.date,
    required this.rates,
  });

  /// Parsea el JSON de exchangerate-api.com
  /// Ejemplo: { "base": "MXN", "date": "2024-01-15", "rates": { "USD": 0.059, ... } }
  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final rawRates = json['rates'] as Map<String, dynamic>? ?? {};
    return ExchangeRate(
      base: json['base'] as String? ?? 'MXN',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      rates: rawRates.map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }

  /// Acceso seguro a una tasa concreta
  double? rateFor(String currency) => rates[currency.toUpperCase()];

  /// Lista ordenada alfabéticamente para mostrar en UI
  List<MapEntry<String, double>> get sortedRates {
    final list = rates.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return list;
  }
}
