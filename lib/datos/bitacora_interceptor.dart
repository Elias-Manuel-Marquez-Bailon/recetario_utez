import 'dart:developer' as developer;

import 'package:dio/dio.dart';

const _llaveReloj = 'bitacora_reloj';

/// Registra cada petición sin datos sensibles: solo método, ruta (path),
/// código, tipo de error y tiempo. Nunca la query ni el cuerpo.
class BitacoraInterceptor extends Interceptor {
  BitacoraInterceptor({void Function(String linea)? escribir})
      : _escribir = escribir ?? ((linea) => developer.log(linea, name: 'bitacora'));

  final void Function(String linea) _escribir;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_llaveReloj] = Stopwatch()..start();
    _escribir('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final o = response.requestOptions;
    _escribir('← ${response.statusCode} ${o.method} ${o.path} (${_ms(o)} ms)');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final o = err.requestOptions;
    final codigo = err.response?.statusCode;
    final textoCodigo = codigo == null ? '' : ' $codigo';
    _escribir('✗ ${err.type.name}$textoCodigo ${o.method} ${o.path} (${_ms(o)} ms)');
    handler.next(err);
  }

  int _ms(RequestOptions o) {
    final reloj = o.extra[_llaveReloj];
    return reloj is Stopwatch ? reloj.elapsedMilliseconds : 0;
  }
}
