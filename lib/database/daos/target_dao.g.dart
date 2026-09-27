// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_dao.dart';

// ignore_for_file: type=lint
mixin _$TargetDaoMixin on DatabaseAccessor<AppDatabase> {
  $TargetRangesTableTable get targetRangesTable =>
      attachedDatabase.targetRangesTable;
  $UserProfileTableTable get userProfileTable =>
      attachedDatabase.userProfileTable;
  TargetDaoManager get managers => TargetDaoManager(this);
}

class TargetDaoManager {
  final _$TargetDaoMixin _db;
  TargetDaoManager(this._db);
  $$TargetRangesTableTableTableManager get targetRangesTable =>
      $$TargetRangesTableTableTableManager(
        _db.attachedDatabase,
        _db.targetRangesTable,
      );
  $$UserProfileTableTableTableManager get userProfileTable =>
      $$UserProfileTableTableTableManager(
        _db.attachedDatabase,
        _db.userProfileTable,
      );
}
