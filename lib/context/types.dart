import 'package:json_annotation/json_annotation.dart';
import 'package:syphon/global/values.dart';

part 'types.g.dart';

///
/// Store Context
///
/// Helps select specifically addressed hot cache and cold storage
/// to load user account data from to redux store
///
/// allows multiaccount feature to be domain logic independent
///
@JsonSerializable()
class AppContext {
  static const DEFAULT = '';
  static const ALL_CONTEXT_KEY = '${Values.appLabel}@context-all';
  static const CURRENT_CONTEXT_KEY = '${Values.appLabel}@context-current';

  final String current;
  final String pinHash;

  AppContext({
    this.current = DEFAULT,
    this.pinHash = DEFAULT,
  });

  Map<String, dynamic> toJson() => _$AppContextToJson(this);
  factory AppContext.fromJson(Map<String, dynamic> json) => _$AppContextFromJson(json);
}
