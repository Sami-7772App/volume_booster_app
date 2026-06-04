class VolumeModel {
  final String title;
  final String icon;
  final int volume;
  final int maxVolume;
  
  VolumeModel({
    required this.title,
    required this.icon,
    required this.volume,
    required this.maxVolume,
  });
  
  double get percentage => (volume / maxVolume) * 100;
  
  VolumeModel copyWith({
    String? title,
    String? icon,
    int? volume,
    int? maxVolume,
  }) {
    return VolumeModel(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      volume: volume ?? this.volume,
      maxVolume: maxVolume ?? this.maxVolume,
    );
  }
}