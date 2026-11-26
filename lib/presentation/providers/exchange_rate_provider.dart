import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/exchange_rate.dart';
import '../../data/services/exchange_rate_service.dart';

final exchangeRateServiceProvider =
    Provider<ExchangeRateService>((ref) => ExchangeRateService());

/// FutureProvider familia: permite pedir cualquier base (MXN, USD, EUR...)
final exchangeRateProvider =
    FutureProvider.family<ExchangeRate, String>((ref, base) async {
  final service = ref.watch(exchangeRateServiceProvider);
  return service.getLatest(base: base);
});
