import '../dominio/receta.dart';

Dificultad dificultadDesdeTexto(Object? valor) {
  return switch (valor) {
    'Easy' => Dificultad.facil,
    'Medium' => Dificultad.media,
    'Hard' => Dificultad.dificil,
    _ => Dificultad.desconocida,
  };
}

Receta recetaDesdeJson(Map<String, dynamic> json) {
  return switch (json) {
    {
      'id': int id,
      'name': String nombre,
      'cuisine': String cocina,
      'prepTimeMinutes': int minutosPreparacion,
      'cookTimeMinutes': int minutosCoccion,
      'servings': int porciones,
      'rating': num calificacion,
    } =>
      Receta(
        id: id,
        nombre: nombre,
        cocina: cocina,
        dificultad: dificultadDesdeTexto(json['difficulty']),
        minutosPreparacion: minutosPreparacion,
        minutosCoccion: minutosCoccion,
        porciones: porciones,
        calificacion: calificacion.toDouble(),
        etiquetas: _listaDeTextos(json, 'tags'),
        ingredientes: _listaDeTextos(json, 'ingredients'),
      ),
    _ => throw const FormatException('Receta con formato inesperado'),
  };
}

PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  return switch (json) {
    {'recipes': List lista, 'total': int total} => PaginaRecetas(
        recetas: [
          for (final elemento in lista)
            if (elemento is Map<String, dynamic>)
              recetaDesdeJson(elemento)
            else
              throw const FormatException('Elemento de recipes no es objeto'),
        ],
        total: total,
      ),
    _ => throw const FormatException('Página con formato inesperado'),
  };
}

/// Lista de textos opcional: si falta, lista vacía; si viene mal, error.
List<String> _listaDeTextos(Map<String, dynamic> json, String llave) {
  final valor = json[llave];
  if (valor == null) return const [];
  if (valor is! List) throw FormatException('$llave no es una lista');
  final textos = <String>[];
  for (final elemento in valor) {
    if (elemento is! String) throw FormatException('$llave trae algo que no es texto');
    textos.add(elemento);
  }
  return textos;
}
