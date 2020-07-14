class TaskModel {
  final int id;
  final bool checked;
  final String description;

  TaskModel({
    this.id,
    this.description,
    this.checked = false
  });

  TaskModel copyWith({
    int id,
    bool checked,
    String description
  }) {
    return TaskModel(
      id: id ?? this.id,
      checked: checked ?? this.checked,
      description: description ?? this.description
    );
  }
}