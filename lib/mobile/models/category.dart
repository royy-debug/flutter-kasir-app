class Category {
  final int categoryId;
  final String name;

  const Category({required this.categoryId, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json['category_id'] as int,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'name': name,
      };
}