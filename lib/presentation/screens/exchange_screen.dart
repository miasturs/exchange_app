import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/exchange_rate_provider.dart';

class ExchangeScreen extends ConsumerWidget {
  const ExchangeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRates = ref.watch(exchangeRateProvider('MXN'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de cambio · MXN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(exchangeRateProvider('MXN')),
            tooltip: 'Refrescar',
          ),
        ],
      ),
      body: asyncRates.when(
        // ⏳ Estado de carga
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Consultando exchangerate-api...'),
            ],
          ),
        ),

        // ⚠️ Estado de error (mensaje específico por tipo)
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(exchangeRateProvider('MXN')),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),

        // ✅ Estado de éxito
        data: (rates) => RefreshIndicator(
          onRefresh: () async =>
              ref.refresh(exchangeRateProvider('MXN').future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Cabecera
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Base: ${rates.base}',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Actualizado: ${DateFormat.yMMMd().add_Hm().format(rates.date)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${rates.rates.length} divisas disponibles',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              // Lista de tasas
              ...rates.sortedRates.map(
                (entry) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        entry.key.substring(0, 1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(entry.key),
                    trailing: Text(
                      entry.value.toStringAsFixed(6),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
