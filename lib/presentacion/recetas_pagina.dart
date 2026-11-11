import 'package:flutter/material.dart';

import 'recetas_view_model.dart';
import 'tarjeta_receta.dart';

class RecetasPagina extends StatefulWidget {
  const RecetasPagina({super.key, required this.vm});

  final RecetasViewModel vm;

  @override
  State<RecetasPagina> createState() => _RecetasPaginaState();
}

class _RecetasPaginaState extends State<RecetasPagina> {
  final _controlador = TextEditingController();

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _buscar() => widget.vm.buscar(_controlador.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetario UTEZ')),
      body: ListenableBuilder(
        listenable: widget.vm,
        builder: (context, _) {
          final vm = widget.vm;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      key: const Key('busqueda'),
                      controller: _controlador,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _buscar(),
                      decoration: const InputDecoration(
                        labelText: '¿Qué receta buscas?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      key: const Key('buscar'),
                      onPressed: vm.cargando ? null : _buscar,
                      child: const Text('Buscar recetas'),
                    ),
                  ],
                ),
              ),
              Expanded(child: _contenido(vm)),
            ],
          );
        },
      ),
    );
  }

  Widget _contenido(RecetasViewModel vm) {
    return switch (vm.estado) {
      RecetasInicial() => const _Centro(
          child: Text('Escribe una receta o déjalo vacío y toca Buscar recetas.'),
        ),
      RecetasCargando() => const _Centro(child: CircularProgressIndicator()),
      RecetasVacias(:final busqueda) => _Centro(
          child: Text(
            busqueda.isEmpty
                ? 'No hay recetas disponibles.'
                : 'No encontramos recetas para "$busqueda".',
          ),
        ),
      RecetasFallidas(:final mensaje) => _Centro(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(mensaje, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: vm.reintentar,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      RecetasListas(:final recetas, :final total) => Column(
          children: [
            Text(
              'Mostrando ${recetas.length} de $total recetas · Rápidas: ${vm.rapidas}',
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: recetas.length,
                itemBuilder: (context, i) => TarjetaReceta(receta: recetas[i]),
              ),
            ),
          ],
        ),
    };
  }
}

class _Centro extends StatelessWidget {
  const _Centro({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      );
}
