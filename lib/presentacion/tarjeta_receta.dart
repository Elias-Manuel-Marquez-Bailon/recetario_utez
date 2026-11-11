import 'package:flutter/material.dart';

import '../dominio/receta.dart';

class TarjetaReceta extends StatelessWidget {
  const TarjetaReceta({super.key, required this.receta});

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(receta.nombre, style: Theme.of(context).textTheme.titleMedium),
            Text('${receta.cocina} · ${receta.dificultad.etiqueta}'),
            const SizedBox(height: 4),
            Text(
              'Tiempo: ${receta.tiempoTotal} min · Porciones: ${receta.porciones}',
            ),
            Text('Calificación: ${receta.calificacion.toStringAsFixed(1)}'),
            if (receta.esRapida) ...[
              const SizedBox(height: 4),
              const Chip(label: Text('Rápida')),
            ],
          ],
        ),
      ),
    );
  }
}
