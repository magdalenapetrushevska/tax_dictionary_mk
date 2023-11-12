class Entry{
  final String id;
  final String name;
  final String? definition;

  Entry({
    required this.id,
    required this.name,
    required this.definition,
  });

  @override
  String toString() {
    return 'Activity(id: $id, name: $name, definition: $definition)';
  }

}
