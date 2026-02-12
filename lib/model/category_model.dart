class Category {
  final int? id;
  final String name;
  bool isSelected;

  Category({this.id, required this.name, this.isSelected = false});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      isSelected: map['isSelected'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'isSelected': isSelected ? 1 : 0};
  }
}
