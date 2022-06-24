import 'package:equatable/equatable.dart';

class CategorySettingsModel extends Equatable {
  final bool askHistory;
  final bool askGeography;
  final bool askScience;
  final bool askSports;
  final bool askMedicine;
  final bool askLiterature;
  final bool askCelebrities;
  final bool askFood;
  final bool askMusic;
  final bool askArts;

  const CategorySettingsModel({
    required this.askHistory,
    required this.askGeography,
    required this.askScience,
    required this.askSports,
    required this.askMedicine,
    required this.askLiterature,
    required this.askCelebrities,
    required this.askFood,
    required this.askMusic,
    required this.askArts,
  });

  @override
  List<Object?> get props => [
        askHistory,
        askGeography,
        askScience,
        askSports,
        askMedicine,
        askLiterature,
        askCelebrities,
        askFood,
        askMusic,
        askArts,
      ];
}
