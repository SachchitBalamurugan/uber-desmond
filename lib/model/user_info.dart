class UserInfoModel {
  final double weight;
  final double height;
  final double muscleMass;
  final double abs;
  final String name;
  final String email;
  final int age;

  UserInfoModel({
    required this.weight,
    required this.height,
    this.name = '',
    this.email = '',
    this.age = 0,
    double? muscleMass,
    double? abs,
  })  : muscleMass = muscleMass ?? _calculateMuscleMass(weight, height),
        abs = abs ?? _calculateAbs(weight, height);

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    double weight = (json['weight'] ?? 0).toDouble();
    double height = (json['height'] ?? 0).toDouble();

    return UserInfoModel(
      weight: weight,
      height: height,
      muscleMass: json['muscleMass']?.toDouble(),
      abs: json['abs']?.toDouble(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      age: (json['age'] ?? 0).toInt(),
    );
  }

  static double _calculateMuscleMass(double weight, double height) {
    // Boer formula for muscle mass calculation
    return (0.407 * weight) + (0.267 * height) - 19.2;
  }

  static double _calculateAbs(double weight, double height) {
    // Estimate abs using a simplified formula for BMI relevance
    return weight / ((height / 100) * (height / 100));
  }
}
