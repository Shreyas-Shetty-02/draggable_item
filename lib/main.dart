import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon) {
              return DraggableIcon(icon: icon);
            },
          ),
        ),
      ),
    );
  }
}

/// A draggable icon widget.
class DraggableIcon extends StatelessWidget {
  final IconData icon;

  const DraggableIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Draggable<IconData>(
      data: icon,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(minWidth: 48),
          height: 48,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blueAccent,
          ),
          child: Center(child: Icon(icon, color: Colors.white)),
        ),
      ),
      childWhenDragging: Container(), // Empty container when dragging
      child: DragTarget<IconData>(
        onAccept: (data) {
          // Handle the icon drop
          Dock.of(context)?.moveItem(data, icon);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            constraints: const BoxConstraints(minWidth: 48),
            height: 48,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.primaries[icon.hashCode % Colors.primaries.length],
            ),
            child: Center(child: Icon(icon, color: Colors.white)),
          );
        },
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  static _DockState<T>? of<T>(BuildContext context) {
    return context.findAncestorStateOfType<_DockState<T>>();
  }

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  void moveItem(T draggedItem, T targetItem) {
    setState(() {
      final draggedIndex = _items.indexOf(draggedItem);
      final targetIndex = _items.indexOf(targetItem);

      // Swap items
      if (draggedIndex != -1 && targetIndex != -1) {
        _items[draggedIndex] = targetItem;
        _items[targetIndex] = draggedItem;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.map(widget.builder).toList(),
      ),
    );
  }
}
