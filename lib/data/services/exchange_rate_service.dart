import 'package:dio/dio.dart';
import '../models/exchange_rate.dart';

/// Excepciones de dominio para que la UI muestre mensajes específicos
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
  @override
  String toString() => message;
}

class ExchangeRateService {
  final Dio _dio;

  ExchangeRateService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://api.exchangerate-api.com/v4',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Accept': 'application/json'},
            ));

  Future<ExchangeRate> getLatest({String base = 'MXN'}) async {
    try {
      final response = await _dio.get('/latest/$base');
      return ExchangeRate.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // Timeout
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(
            'Timeout al conectar con el servidor. Verifica tu conexión.');
      }
      // Sin conexión
      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No hay conexión a internet.');
      }
      // Errores HTTP
      final status = e.response?.statusCode;
      if (status == 404) {
        throw NotFoundException('Divisa "$base" no encontrada (404).');
      }
      if (status != null && status >= 500) {
        throw ServerException(
            'Error del servidor ($status). Intenta más tarde.');
      }
      // Otros errores HTTP (400, 401, 403, etc.)
      throw NetworkException(
          'Error de red (${status ?? 'desconocido'}): ${e.message}');
    } catch (e) {
      // Error de parseo u otro
      throw NetworkException('Error inesperado: $e');
    }
  }
}
