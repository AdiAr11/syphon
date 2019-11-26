import "package:Tether/global/themes.dart";

class SettingsStore {
  final ThemeType theme;

  const SettingsStore({this.theme = ThemeType.LIGHT});

  @override
  int get hashCode => theme.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsStore &&
          runtimeType == other.runtimeType &&
          theme == other.theme;

  @override
  String toString() {
    return '{theme: $theme}';
  }
}
