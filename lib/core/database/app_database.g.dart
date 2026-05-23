// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarColorMeta = const VerificationMeta(
    'avatarColor',
  );
  @override
  late final GeneratedColumn<String> avatarColor = GeneratedColumn<String>(
    'avatar_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialsMeta = const VerificationMeta(
    'initials',
  );
  @override
  late final GeneratedColumn<String> initials = GeneratedColumn<String>(
    'initials',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatarColor,
    initials,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_color')) {
      context.handle(
        _avatarColorMeta,
        avatarColor.isAcceptableOrUnknown(
          data['avatar_color']!,
          _avatarColorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avatarColorMeta);
    }
    if (data.containsKey('initials')) {
      context.handle(
        _initialsMeta,
        initials.isAcceptableOrUnknown(data['initials']!, _initialsMeta),
      );
    } else if (isInserting) {
      context.missing(_initialsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatarColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_color'],
      )!,
      initials: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initials'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  final String id;
  final String name;
  final String avatarColor;
  final String initials;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Player({
    required this.id,
    required this.name,
    required this.avatarColor,
    required this.initials,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['avatar_color'] = Variable<String>(avatarColor);
    map['initials'] = Variable<String>(initials);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      name: Value(name),
      avatarColor: Value(avatarColor),
      initials: Value(initials),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarColor: serializer.fromJson<String>(json['avatarColor']),
      initials: serializer.fromJson<String>(json['initials']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatarColor': serializer.toJson<String>(avatarColor),
      'initials': serializer.toJson<String>(initials),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Player copyWith({
    String? id,
    String? name,
    String? avatarColor,
    String? initials,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Player(
    id: id ?? this.id,
    name: name ?? this.name,
    avatarColor: avatarColor ?? this.avatarColor,
    initials: initials ?? this.initials,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Player copyWithCompanion(PlayersCompanion data) {
    return Player(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarColor: data.avatarColor.present
          ? data.avatarColor.value
          : this.avatarColor,
      initials: data.initials.present ? data.initials.value : this.initials,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('initials: $initials, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, avatarColor, initials, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarColor == this.avatarColor &&
          other.initials == this.initials &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> avatarColor;
  final Value<String> initials;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarColor = const Value.absent(),
    this.initials = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayersCompanion.insert({
    required String id,
    required String name,
    required String avatarColor,
    required String initials,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       avatarColor = Value(avatarColor),
       initials = Value(initials),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Player> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatarColor,
    Expression<String>? initials,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarColor != null) 'avatar_color': avatarColor,
      if (initials != null) 'initials': initials,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? avatarColor,
    Value<String>? initials,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarColor: avatarColor ?? this.avatarColor,
      initials: initials ?? this.initials,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarColor.present) {
      map['avatar_color'] = Variable<String>(avatarColor.value);
    }
    if (initials.present) {
      map['initials'] = Variable<String>(initials.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('initials: $initials, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EndMode, String> endMode =
      GeneratedColumn<String>(
        'end_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EndMode>($GamesTable.$converterendMode);
  static const VerificationMeta _scoreLimitMeta = const VerificationMeta(
    'scoreLimit',
  );
  @override
  late final GeneratedColumn<int> scoreLimit = GeneratedColumn<int>(
    'score_limit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalRoundsMeta = const VerificationMeta(
    'totalRounds',
  );
  @override
  late final GeneratedColumn<int> totalRounds = GeneratedColumn<int>(
    'total_rounds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentRoundMeta = const VerificationMeta(
    'currentRound',
  );
  @override
  late final GeneratedColumn<int> currentRound = GeneratedColumn<int>(
    'current_round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GameStatus>($GamesTable.$converterstatus);
  static const VerificationMeta _winnerIdMeta = const VerificationMeta(
    'winnerId',
  );
  @override
  late final GeneratedColumn<String> winnerId = GeneratedColumn<String>(
    'winner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    endMode,
    scoreLimit,
    totalRounds,
    currentRound,
    status,
    winnerId,
    startedAt,
    finishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('score_limit')) {
      context.handle(
        _scoreLimitMeta,
        scoreLimit.isAcceptableOrUnknown(data['score_limit']!, _scoreLimitMeta),
      );
    }
    if (data.containsKey('total_rounds')) {
      context.handle(
        _totalRoundsMeta,
        totalRounds.isAcceptableOrUnknown(
          data['total_rounds']!,
          _totalRoundsMeta,
        ),
      );
    }
    if (data.containsKey('current_round')) {
      context.handle(
        _currentRoundMeta,
        currentRound.isAcceptableOrUnknown(
          data['current_round']!,
          _currentRoundMeta,
        ),
      );
    }
    if (data.containsKey('winner_id')) {
      context.handle(
        _winnerIdMeta,
        winnerId.isAcceptableOrUnknown(data['winner_id']!, _winnerIdMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      endMode: $GamesTable.$converterendMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}end_mode'],
        )!,
      ),
      scoreLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_limit'],
      ),
      totalRounds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_rounds'],
      ),
      currentRound: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_round'],
      )!,
      status: $GamesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      winnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EndMode, String, String> $converterendMode =
      const EnumNameConverter<EndMode>(EndMode.values);
  static JsonTypeConverter2<GameStatus, String, String> $converterstatus =
      const EnumNameConverter<GameStatus>(GameStatus.values);
}

class Game extends DataClass implements Insertable<Game> {
  final String id;
  final EndMode endMode;
  final int? scoreLimit;
  final int? totalRounds;
  final int currentRound;
  final GameStatus status;
  final String? winnerId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  const Game({
    required this.id,
    required this.endMode,
    this.scoreLimit,
    this.totalRounds,
    required this.currentRound,
    required this.status,
    this.winnerId,
    required this.startedAt,
    this.finishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['end_mode'] = Variable<String>(
        $GamesTable.$converterendMode.toSql(endMode),
      );
    }
    if (!nullToAbsent || scoreLimit != null) {
      map['score_limit'] = Variable<int>(scoreLimit);
    }
    if (!nullToAbsent || totalRounds != null) {
      map['total_rounds'] = Variable<int>(totalRounds);
    }
    map['current_round'] = Variable<int>(currentRound);
    {
      map['status'] = Variable<String>(
        $GamesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || winnerId != null) {
      map['winner_id'] = Variable<String>(winnerId);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      endMode: Value(endMode),
      scoreLimit: scoreLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(scoreLimit),
      totalRounds: totalRounds == null && nullToAbsent
          ? const Value.absent()
          : Value(totalRounds),
      currentRound: Value(currentRound),
      status: Value(status),
      winnerId: winnerId == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerId),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<String>(json['id']),
      endMode: $GamesTable.$converterendMode.fromJson(
        serializer.fromJson<String>(json['endMode']),
      ),
      scoreLimit: serializer.fromJson<int?>(json['scoreLimit']),
      totalRounds: serializer.fromJson<int?>(json['totalRounds']),
      currentRound: serializer.fromJson<int>(json['currentRound']),
      status: $GamesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      winnerId: serializer.fromJson<String?>(json['winnerId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'endMode': serializer.toJson<String>(
        $GamesTable.$converterendMode.toJson(endMode),
      ),
      'scoreLimit': serializer.toJson<int?>(scoreLimit),
      'totalRounds': serializer.toJson<int?>(totalRounds),
      'currentRound': serializer.toJson<int>(currentRound),
      'status': serializer.toJson<String>(
        $GamesTable.$converterstatus.toJson(status),
      ),
      'winnerId': serializer.toJson<String?>(winnerId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
    };
  }

  Game copyWith({
    String? id,
    EndMode? endMode,
    Value<int?> scoreLimit = const Value.absent(),
    Value<int?> totalRounds = const Value.absent(),
    int? currentRound,
    GameStatus? status,
    Value<String?> winnerId = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
  }) => Game(
    id: id ?? this.id,
    endMode: endMode ?? this.endMode,
    scoreLimit: scoreLimit.present ? scoreLimit.value : this.scoreLimit,
    totalRounds: totalRounds.present ? totalRounds.value : this.totalRounds,
    currentRound: currentRound ?? this.currentRound,
    status: status ?? this.status,
    winnerId: winnerId.present ? winnerId.value : this.winnerId,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      endMode: data.endMode.present ? data.endMode.value : this.endMode,
      scoreLimit: data.scoreLimit.present
          ? data.scoreLimit.value
          : this.scoreLimit,
      totalRounds: data.totalRounds.present
          ? data.totalRounds.value
          : this.totalRounds,
      currentRound: data.currentRound.present
          ? data.currentRound.value
          : this.currentRound,
      status: data.status.present ? data.status.value : this.status,
      winnerId: data.winnerId.present ? data.winnerId.value : this.winnerId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('endMode: $endMode, ')
          ..write('scoreLimit: $scoreLimit, ')
          ..write('totalRounds: $totalRounds, ')
          ..write('currentRound: $currentRound, ')
          ..write('status: $status, ')
          ..write('winnerId: $winnerId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    endMode,
    scoreLimit,
    totalRounds,
    currentRound,
    status,
    winnerId,
    startedAt,
    finishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.endMode == this.endMode &&
          other.scoreLimit == this.scoreLimit &&
          other.totalRounds == this.totalRounds &&
          other.currentRound == this.currentRound &&
          other.status == this.status &&
          other.winnerId == this.winnerId &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<String> id;
  final Value<EndMode> endMode;
  final Value<int?> scoreLimit;
  final Value<int?> totalRounds;
  final Value<int> currentRound;
  final Value<GameStatus> status;
  final Value<String?> winnerId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> rowid;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.endMode = const Value.absent(),
    this.scoreLimit = const Value.absent(),
    this.totalRounds = const Value.absent(),
    this.currentRound = const Value.absent(),
    this.status = const Value.absent(),
    this.winnerId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCompanion.insert({
    required String id,
    required EndMode endMode,
    this.scoreLimit = const Value.absent(),
    this.totalRounds = const Value.absent(),
    this.currentRound = const Value.absent(),
    required GameStatus status,
    this.winnerId = const Value.absent(),
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       endMode = Value(endMode),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<Game> custom({
    Expression<String>? id,
    Expression<String>? endMode,
    Expression<int>? scoreLimit,
    Expression<int>? totalRounds,
    Expression<int>? currentRound,
    Expression<String>? status,
    Expression<String>? winnerId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (endMode != null) 'end_mode': endMode,
      if (scoreLimit != null) 'score_limit': scoreLimit,
      if (totalRounds != null) 'total_rounds': totalRounds,
      if (currentRound != null) 'current_round': currentRound,
      if (status != null) 'status': status,
      if (winnerId != null) 'winner_id': winnerId,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCompanion copyWith({
    Value<String>? id,
    Value<EndMode>? endMode,
    Value<int?>? scoreLimit,
    Value<int?>? totalRounds,
    Value<int>? currentRound,
    Value<GameStatus>? status,
    Value<String?>? winnerId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int>? rowid,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      endMode: endMode ?? this.endMode,
      scoreLimit: scoreLimit ?? this.scoreLimit,
      totalRounds: totalRounds ?? this.totalRounds,
      currentRound: currentRound ?? this.currentRound,
      status: status ?? this.status,
      winnerId: winnerId ?? this.winnerId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (endMode.present) {
      map['end_mode'] = Variable<String>(
        $GamesTable.$converterendMode.toSql(endMode.value),
      );
    }
    if (scoreLimit.present) {
      map['score_limit'] = Variable<int>(scoreLimit.value);
    }
    if (totalRounds.present) {
      map['total_rounds'] = Variable<int>(totalRounds.value);
    }
    if (currentRound.present) {
      map['current_round'] = Variable<int>(currentRound.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $GamesTable.$converterstatus.toSql(status.value),
      );
    }
    if (winnerId.present) {
      map['winner_id'] = Variable<String>(winnerId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('endMode: $endMode, ')
          ..write('scoreLimit: $scoreLimit, ')
          ..write('totalRounds: $totalRounds, ')
          ..write('currentRound: $currentRound, ')
          ..write('status: $status, ')
          ..write('winnerId: $winnerId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamePlayersTable extends GamePlayers
    with TableInfo<$GamePlayersTable, GamePlayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamePlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES players (id)',
    ),
  );
  static const VerificationMeta _seatIndexMeta = const VerificationMeta(
    'seatIndex',
  );
  @override
  late final GeneratedColumn<int> seatIndex = GeneratedColumn<int>(
    'seat_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
    'total_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _displayNameSnapshotMeta =
      const VerificationMeta('displayNameSnapshot');
  @override
  late final GeneratedColumn<String> displayNameSnapshot =
      GeneratedColumn<String>(
        'display_name_snapshot',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    gameId,
    playerId,
    seatIndex,
    totalScore,
    displayNameSnapshot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_players';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamePlayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('seat_index')) {
      context.handle(
        _seatIndexMeta,
        seatIndex.isAcceptableOrUnknown(data['seat_index']!, _seatIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_seatIndexMeta);
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('display_name_snapshot')) {
      context.handle(
        _displayNameSnapshotMeta,
        displayNameSnapshot.isAcceptableOrUnknown(
          data['display_name_snapshot']!,
          _displayNameSnapshotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameSnapshotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId, playerId};
  @override
  GamePlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamePlayer(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      seatIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seat_index'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_score'],
      )!,
      displayNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name_snapshot'],
      )!,
    );
  }

  @override
  $GamePlayersTable createAlias(String alias) {
    return $GamePlayersTable(attachedDatabase, alias);
  }
}

class GamePlayer extends DataClass implements Insertable<GamePlayer> {
  final String gameId;
  final String playerId;
  final int seatIndex;
  final int totalScore;
  final String displayNameSnapshot;
  const GamePlayer({
    required this.gameId,
    required this.playerId,
    required this.seatIndex,
    required this.totalScore,
    required this.displayNameSnapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<String>(gameId);
    map['player_id'] = Variable<String>(playerId);
    map['seat_index'] = Variable<int>(seatIndex);
    map['total_score'] = Variable<int>(totalScore);
    map['display_name_snapshot'] = Variable<String>(displayNameSnapshot);
    return map;
  }

  GamePlayersCompanion toCompanion(bool nullToAbsent) {
    return GamePlayersCompanion(
      gameId: Value(gameId),
      playerId: Value(playerId),
      seatIndex: Value(seatIndex),
      totalScore: Value(totalScore),
      displayNameSnapshot: Value(displayNameSnapshot),
    );
  }

  factory GamePlayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamePlayer(
      gameId: serializer.fromJson<String>(json['gameId']),
      playerId: serializer.fromJson<String>(json['playerId']),
      seatIndex: serializer.fromJson<int>(json['seatIndex']),
      totalScore: serializer.fromJson<int>(json['totalScore']),
      displayNameSnapshot: serializer.fromJson<String>(
        json['displayNameSnapshot'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<String>(gameId),
      'playerId': serializer.toJson<String>(playerId),
      'seatIndex': serializer.toJson<int>(seatIndex),
      'totalScore': serializer.toJson<int>(totalScore),
      'displayNameSnapshot': serializer.toJson<String>(displayNameSnapshot),
    };
  }

  GamePlayer copyWith({
    String? gameId,
    String? playerId,
    int? seatIndex,
    int? totalScore,
    String? displayNameSnapshot,
  }) => GamePlayer(
    gameId: gameId ?? this.gameId,
    playerId: playerId ?? this.playerId,
    seatIndex: seatIndex ?? this.seatIndex,
    totalScore: totalScore ?? this.totalScore,
    displayNameSnapshot: displayNameSnapshot ?? this.displayNameSnapshot,
  );
  GamePlayer copyWithCompanion(GamePlayersCompanion data) {
    return GamePlayer(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      seatIndex: data.seatIndex.present ? data.seatIndex.value : this.seatIndex,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      displayNameSnapshot: data.displayNameSnapshot.present
          ? data.displayNameSnapshot.value
          : this.displayNameSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamePlayer(')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('seatIndex: $seatIndex, ')
          ..write('totalScore: $totalScore, ')
          ..write('displayNameSnapshot: $displayNameSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(gameId, playerId, seatIndex, totalScore, displayNameSnapshot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamePlayer &&
          other.gameId == this.gameId &&
          other.playerId == this.playerId &&
          other.seatIndex == this.seatIndex &&
          other.totalScore == this.totalScore &&
          other.displayNameSnapshot == this.displayNameSnapshot);
}

class GamePlayersCompanion extends UpdateCompanion<GamePlayer> {
  final Value<String> gameId;
  final Value<String> playerId;
  final Value<int> seatIndex;
  final Value<int> totalScore;
  final Value<String> displayNameSnapshot;
  final Value<int> rowid;
  const GamePlayersCompanion({
    this.gameId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.seatIndex = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.displayNameSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamePlayersCompanion.insert({
    required String gameId,
    required String playerId,
    required int seatIndex,
    this.totalScore = const Value.absent(),
    required String displayNameSnapshot,
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId),
       playerId = Value(playerId),
       seatIndex = Value(seatIndex),
       displayNameSnapshot = Value(displayNameSnapshot);
  static Insertable<GamePlayer> custom({
    Expression<String>? gameId,
    Expression<String>? playerId,
    Expression<int>? seatIndex,
    Expression<int>? totalScore,
    Expression<String>? displayNameSnapshot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (playerId != null) 'player_id': playerId,
      if (seatIndex != null) 'seat_index': seatIndex,
      if (totalScore != null) 'total_score': totalScore,
      if (displayNameSnapshot != null)
        'display_name_snapshot': displayNameSnapshot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamePlayersCompanion copyWith({
    Value<String>? gameId,
    Value<String>? playerId,
    Value<int>? seatIndex,
    Value<int>? totalScore,
    Value<String>? displayNameSnapshot,
    Value<int>? rowid,
  }) {
    return GamePlayersCompanion(
      gameId: gameId ?? this.gameId,
      playerId: playerId ?? this.playerId,
      seatIndex: seatIndex ?? this.seatIndex,
      totalScore: totalScore ?? this.totalScore,
      displayNameSnapshot: displayNameSnapshot ?? this.displayNameSnapshot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (seatIndex.present) {
      map['seat_index'] = Variable<int>(seatIndex.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (displayNameSnapshot.present) {
      map['display_name_snapshot'] = Variable<String>(
        displayNameSnapshot.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamePlayersCompanion(')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('seatIndex: $seatIndex, ')
          ..write('totalScore: $totalScore, ')
          ..write('displayNameSnapshot: $displayNameSnapshot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoundsTable extends Rounds with TableInfo<$RoundsTable, Round> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roundNumberMeta = const VerificationMeta(
    'roundNumber',
  );
  @override
  late final GeneratedColumn<int> roundNumber = GeneratedColumn<int>(
    'round_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starterPlayerIdMeta = const VerificationMeta(
    'starterPlayerId',
  );
  @override
  late final GeneratedColumn<String> starterPlayerId = GeneratedColumn<String>(
    'starter_player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finisherPlayerIdMeta = const VerificationMeta(
    'finisherPlayerId',
  );
  @override
  late final GeneratedColumn<String> finisherPlayerId = GeneratedColumn<String>(
    'finisher_player_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    roundNumber,
    starterPlayerId,
    finisherPlayerId,
    startedAt,
    finishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<Round> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('round_number')) {
      context.handle(
        _roundNumberMeta,
        roundNumber.isAcceptableOrUnknown(
          data['round_number']!,
          _roundNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_roundNumberMeta);
    }
    if (data.containsKey('starter_player_id')) {
      context.handle(
        _starterPlayerIdMeta,
        starterPlayerId.isAcceptableOrUnknown(
          data['starter_player_id']!,
          _starterPlayerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_starterPlayerIdMeta);
    }
    if (data.containsKey('finisher_player_id')) {
      context.handle(
        _finisherPlayerIdMeta,
        finisherPlayerId.isAcceptableOrUnknown(
          data['finisher_player_id']!,
          _finisherPlayerIdMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Round map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Round(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      roundNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round_number'],
      )!,
      starterPlayerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}starter_player_id'],
      )!,
      finisherPlayerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finisher_player_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
    );
  }

  @override
  $RoundsTable createAlias(String alias) {
    return $RoundsTable(attachedDatabase, alias);
  }
}

class Round extends DataClass implements Insertable<Round> {
  final String id;
  final String gameId;
  final int roundNumber;
  final String starterPlayerId;
  final String? finisherPlayerId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  const Round({
    required this.id,
    required this.gameId,
    required this.roundNumber,
    required this.starterPlayerId,
    this.finisherPlayerId,
    required this.startedAt,
    this.finishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['round_number'] = Variable<int>(roundNumber);
    map['starter_player_id'] = Variable<String>(starterPlayerId);
    if (!nullToAbsent || finisherPlayerId != null) {
      map['finisher_player_id'] = Variable<String>(finisherPlayerId);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    return map;
  }

  RoundsCompanion toCompanion(bool nullToAbsent) {
    return RoundsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      roundNumber: Value(roundNumber),
      starterPlayerId: Value(starterPlayerId),
      finisherPlayerId: finisherPlayerId == null && nullToAbsent
          ? const Value.absent()
          : Value(finisherPlayerId),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
    );
  }

  factory Round.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Round(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      roundNumber: serializer.fromJson<int>(json['roundNumber']),
      starterPlayerId: serializer.fromJson<String>(json['starterPlayerId']),
      finisherPlayerId: serializer.fromJson<String?>(json['finisherPlayerId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'roundNumber': serializer.toJson<int>(roundNumber),
      'starterPlayerId': serializer.toJson<String>(starterPlayerId),
      'finisherPlayerId': serializer.toJson<String?>(finisherPlayerId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
    };
  }

  Round copyWith({
    String? id,
    String? gameId,
    int? roundNumber,
    String? starterPlayerId,
    Value<String?> finisherPlayerId = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
  }) => Round(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    roundNumber: roundNumber ?? this.roundNumber,
    starterPlayerId: starterPlayerId ?? this.starterPlayerId,
    finisherPlayerId: finisherPlayerId.present
        ? finisherPlayerId.value
        : this.finisherPlayerId,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
  );
  Round copyWithCompanion(RoundsCompanion data) {
    return Round(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      roundNumber: data.roundNumber.present
          ? data.roundNumber.value
          : this.roundNumber,
      starterPlayerId: data.starterPlayerId.present
          ? data.starterPlayerId.value
          : this.starterPlayerId,
      finisherPlayerId: data.finisherPlayerId.present
          ? data.finisherPlayerId.value
          : this.finisherPlayerId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Round(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('roundNumber: $roundNumber, ')
          ..write('starterPlayerId: $starterPlayerId, ')
          ..write('finisherPlayerId: $finisherPlayerId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameId,
    roundNumber,
    starterPlayerId,
    finisherPlayerId,
    startedAt,
    finishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Round &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.roundNumber == this.roundNumber &&
          other.starterPlayerId == this.starterPlayerId &&
          other.finisherPlayerId == this.finisherPlayerId &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt);
}

class RoundsCompanion extends UpdateCompanion<Round> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<int> roundNumber;
  final Value<String> starterPlayerId;
  final Value<String?> finisherPlayerId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> rowid;
  const RoundsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.roundNumber = const Value.absent(),
    this.starterPlayerId = const Value.absent(),
    this.finisherPlayerId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoundsCompanion.insert({
    required String id,
    required String gameId,
    required int roundNumber,
    required String starterPlayerId,
    this.finisherPlayerId = const Value.absent(),
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       roundNumber = Value(roundNumber),
       starterPlayerId = Value(starterPlayerId),
       startedAt = Value(startedAt);
  static Insertable<Round> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<int>? roundNumber,
    Expression<String>? starterPlayerId,
    Expression<String>? finisherPlayerId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (roundNumber != null) 'round_number': roundNumber,
      if (starterPlayerId != null) 'starter_player_id': starterPlayerId,
      if (finisherPlayerId != null) 'finisher_player_id': finisherPlayerId,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoundsCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<int>? roundNumber,
    Value<String>? starterPlayerId,
    Value<String?>? finisherPlayerId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int>? rowid,
  }) {
    return RoundsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      roundNumber: roundNumber ?? this.roundNumber,
      starterPlayerId: starterPlayerId ?? this.starterPlayerId,
      finisherPlayerId: finisherPlayerId ?? this.finisherPlayerId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (roundNumber.present) {
      map['round_number'] = Variable<int>(roundNumber.value);
    }
    if (starterPlayerId.present) {
      map['starter_player_id'] = Variable<String>(starterPlayerId.value);
    }
    if (finisherPlayerId.present) {
      map['finisher_player_id'] = Variable<String>(finisherPlayerId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoundsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('roundNumber: $roundNumber, ')
          ..write('starterPlayerId: $starterPlayerId, ')
          ..write('finisherPlayerId: $finisherPlayerId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MovesTable extends Moves with TableInfo<$MovesTable, MoveRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roundIdMeta = const VerificationMeta(
    'roundId',
  );
  @override
  late final GeneratedColumn<String> roundId = GeneratedColumn<String>(
    'round_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rounds (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moveIndexMeta = const VerificationMeta(
    'moveIndex',
  );
  @override
  late final GeneratedColumn<int> moveIndex = GeneratedColumn<int>(
    'move_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MoveType, String> moveType =
      GeneratedColumn<String>(
        'move_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MoveType>($MovesTable.$convertermoveType);
  static const VerificationMeta _corner1Meta = const VerificationMeta(
    'corner1',
  );
  @override
  late final GeneratedColumn<int> corner1 = GeneratedColumn<int>(
    'corner1',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _corner2Meta = const VerificationMeta(
    'corner2',
  );
  @override
  late final GeneratedColumn<int> corner2 = GeneratedColumn<int>(
    'corner2',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _corner3Meta = const VerificationMeta(
    'corner3',
  );
  @override
  late final GeneratedColumn<int> corner3 = GeneratedColumn<int>(
    'corner3',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseScoreMeta = const VerificationMeta(
    'baseScore',
  );
  @override
  late final GeneratedColumn<int> baseScore = GeneratedColumn<int>(
    'base_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bonusScoreMeta = const VerificationMeta(
    'bonusScore',
  );
  @override
  late final GeneratedColumn<int> bonusScore = GeneratedColumn<int>(
    'bonus_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isTripletMeta = const VerificationMeta(
    'isTriplet',
  );
  @override
  late final GeneratedColumn<bool> isTriplet = GeneratedColumn<bool>(
    'is_triplet',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_triplet" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isBridgeMeta = const VerificationMeta(
    'isBridge',
  );
  @override
  late final GeneratedColumn<bool> isBridge = GeneratedColumn<bool>(
    'is_bridge',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bridge" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isHexagonMeta = const VerificationMeta(
    'isHexagon',
  );
  @override
  late final GeneratedColumn<bool> isHexagon = GeneratedColumn<bool>(
    'is_hexagon',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hexagon" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDoubleHexagonMeta = const VerificationMeta(
    'isDoubleHexagon',
  );
  @override
  late final GeneratedColumn<bool> isDoubleHexagon = GeneratedColumn<bool>(
    'is_double_hexagon',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_double_hexagon" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isStarterMeta = const VerificationMeta(
    'isStarter',
  );
  @override
  late final GeneratedColumn<bool> isStarter = GeneratedColumn<bool>(
    'is_starter',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starter" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roundId,
    playerId,
    moveIndex,
    moveType,
    corner1,
    corner2,
    corner3,
    baseScore,
    bonusScore,
    isTriplet,
    isBridge,
    isHexagon,
    isDoubleHexagon,
    isStarter,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moves';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoveRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('round_id')) {
      context.handle(
        _roundIdMeta,
        roundId.isAcceptableOrUnknown(data['round_id']!, _roundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roundIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('move_index')) {
      context.handle(
        _moveIndexMeta,
        moveIndex.isAcceptableOrUnknown(data['move_index']!, _moveIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_moveIndexMeta);
    }
    if (data.containsKey('corner1')) {
      context.handle(
        _corner1Meta,
        corner1.isAcceptableOrUnknown(data['corner1']!, _corner1Meta),
      );
    }
    if (data.containsKey('corner2')) {
      context.handle(
        _corner2Meta,
        corner2.isAcceptableOrUnknown(data['corner2']!, _corner2Meta),
      );
    }
    if (data.containsKey('corner3')) {
      context.handle(
        _corner3Meta,
        corner3.isAcceptableOrUnknown(data['corner3']!, _corner3Meta),
      );
    }
    if (data.containsKey('base_score')) {
      context.handle(
        _baseScoreMeta,
        baseScore.isAcceptableOrUnknown(data['base_score']!, _baseScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_baseScoreMeta);
    }
    if (data.containsKey('bonus_score')) {
      context.handle(
        _bonusScoreMeta,
        bonusScore.isAcceptableOrUnknown(data['bonus_score']!, _bonusScoreMeta),
      );
    }
    if (data.containsKey('is_triplet')) {
      context.handle(
        _isTripletMeta,
        isTriplet.isAcceptableOrUnknown(data['is_triplet']!, _isTripletMeta),
      );
    }
    if (data.containsKey('is_bridge')) {
      context.handle(
        _isBridgeMeta,
        isBridge.isAcceptableOrUnknown(data['is_bridge']!, _isBridgeMeta),
      );
    }
    if (data.containsKey('is_hexagon')) {
      context.handle(
        _isHexagonMeta,
        isHexagon.isAcceptableOrUnknown(data['is_hexagon']!, _isHexagonMeta),
      );
    }
    if (data.containsKey('is_double_hexagon')) {
      context.handle(
        _isDoubleHexagonMeta,
        isDoubleHexagon.isAcceptableOrUnknown(
          data['is_double_hexagon']!,
          _isDoubleHexagonMeta,
        ),
      );
    }
    if (data.containsKey('is_starter')) {
      context.handle(
        _isStarterMeta,
        isStarter.isAcceptableOrUnknown(data['is_starter']!, _isStarterMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoveRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoveRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}round_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      moveIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}move_index'],
      )!,
      moveType: $MovesTable.$convertermoveType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}move_type'],
        )!,
      ),
      corner1: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corner1'],
      ),
      corner2: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corner2'],
      ),
      corner3: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}corner3'],
      ),
      baseScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_score'],
      )!,
      bonusScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonus_score'],
      )!,
      isTriplet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_triplet'],
      )!,
      isBridge: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bridge'],
      )!,
      isHexagon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hexagon'],
      )!,
      isDoubleHexagon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_double_hexagon'],
      )!,
      isStarter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starter'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MovesTable createAlias(String alias) {
    return $MovesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MoveType, String, String> $convertermoveType =
      const EnumNameConverter<MoveType>(MoveType.values);
}

class MoveRow extends DataClass implements Insertable<MoveRow> {
  final String id;
  final String roundId;
  final String playerId;
  final int moveIndex;
  final MoveType moveType;
  final int? corner1;
  final int? corner2;
  final int? corner3;
  final int baseScore;
  final int bonusScore;
  final bool isTriplet;
  final bool isBridge;
  final bool isHexagon;
  final bool isDoubleHexagon;
  final bool isStarter;
  final DateTime createdAt;
  const MoveRow({
    required this.id,
    required this.roundId,
    required this.playerId,
    required this.moveIndex,
    required this.moveType,
    this.corner1,
    this.corner2,
    this.corner3,
    required this.baseScore,
    required this.bonusScore,
    required this.isTriplet,
    required this.isBridge,
    required this.isHexagon,
    required this.isDoubleHexagon,
    required this.isStarter,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['round_id'] = Variable<String>(roundId);
    map['player_id'] = Variable<String>(playerId);
    map['move_index'] = Variable<int>(moveIndex);
    {
      map['move_type'] = Variable<String>(
        $MovesTable.$convertermoveType.toSql(moveType),
      );
    }
    if (!nullToAbsent || corner1 != null) {
      map['corner1'] = Variable<int>(corner1);
    }
    if (!nullToAbsent || corner2 != null) {
      map['corner2'] = Variable<int>(corner2);
    }
    if (!nullToAbsent || corner3 != null) {
      map['corner3'] = Variable<int>(corner3);
    }
    map['base_score'] = Variable<int>(baseScore);
    map['bonus_score'] = Variable<int>(bonusScore);
    map['is_triplet'] = Variable<bool>(isTriplet);
    map['is_bridge'] = Variable<bool>(isBridge);
    map['is_hexagon'] = Variable<bool>(isHexagon);
    map['is_double_hexagon'] = Variable<bool>(isDoubleHexagon);
    map['is_starter'] = Variable<bool>(isStarter);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MovesCompanion toCompanion(bool nullToAbsent) {
    return MovesCompanion(
      id: Value(id),
      roundId: Value(roundId),
      playerId: Value(playerId),
      moveIndex: Value(moveIndex),
      moveType: Value(moveType),
      corner1: corner1 == null && nullToAbsent
          ? const Value.absent()
          : Value(corner1),
      corner2: corner2 == null && nullToAbsent
          ? const Value.absent()
          : Value(corner2),
      corner3: corner3 == null && nullToAbsent
          ? const Value.absent()
          : Value(corner3),
      baseScore: Value(baseScore),
      bonusScore: Value(bonusScore),
      isTriplet: Value(isTriplet),
      isBridge: Value(isBridge),
      isHexagon: Value(isHexagon),
      isDoubleHexagon: Value(isDoubleHexagon),
      isStarter: Value(isStarter),
      createdAt: Value(createdAt),
    );
  }

  factory MoveRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoveRow(
      id: serializer.fromJson<String>(json['id']),
      roundId: serializer.fromJson<String>(json['roundId']),
      playerId: serializer.fromJson<String>(json['playerId']),
      moveIndex: serializer.fromJson<int>(json['moveIndex']),
      moveType: $MovesTable.$convertermoveType.fromJson(
        serializer.fromJson<String>(json['moveType']),
      ),
      corner1: serializer.fromJson<int?>(json['corner1']),
      corner2: serializer.fromJson<int?>(json['corner2']),
      corner3: serializer.fromJson<int?>(json['corner3']),
      baseScore: serializer.fromJson<int>(json['baseScore']),
      bonusScore: serializer.fromJson<int>(json['bonusScore']),
      isTriplet: serializer.fromJson<bool>(json['isTriplet']),
      isBridge: serializer.fromJson<bool>(json['isBridge']),
      isHexagon: serializer.fromJson<bool>(json['isHexagon']),
      isDoubleHexagon: serializer.fromJson<bool>(json['isDoubleHexagon']),
      isStarter: serializer.fromJson<bool>(json['isStarter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roundId': serializer.toJson<String>(roundId),
      'playerId': serializer.toJson<String>(playerId),
      'moveIndex': serializer.toJson<int>(moveIndex),
      'moveType': serializer.toJson<String>(
        $MovesTable.$convertermoveType.toJson(moveType),
      ),
      'corner1': serializer.toJson<int?>(corner1),
      'corner2': serializer.toJson<int?>(corner2),
      'corner3': serializer.toJson<int?>(corner3),
      'baseScore': serializer.toJson<int>(baseScore),
      'bonusScore': serializer.toJson<int>(bonusScore),
      'isTriplet': serializer.toJson<bool>(isTriplet),
      'isBridge': serializer.toJson<bool>(isBridge),
      'isHexagon': serializer.toJson<bool>(isHexagon),
      'isDoubleHexagon': serializer.toJson<bool>(isDoubleHexagon),
      'isStarter': serializer.toJson<bool>(isStarter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MoveRow copyWith({
    String? id,
    String? roundId,
    String? playerId,
    int? moveIndex,
    MoveType? moveType,
    Value<int?> corner1 = const Value.absent(),
    Value<int?> corner2 = const Value.absent(),
    Value<int?> corner3 = const Value.absent(),
    int? baseScore,
    int? bonusScore,
    bool? isTriplet,
    bool? isBridge,
    bool? isHexagon,
    bool? isDoubleHexagon,
    bool? isStarter,
    DateTime? createdAt,
  }) => MoveRow(
    id: id ?? this.id,
    roundId: roundId ?? this.roundId,
    playerId: playerId ?? this.playerId,
    moveIndex: moveIndex ?? this.moveIndex,
    moveType: moveType ?? this.moveType,
    corner1: corner1.present ? corner1.value : this.corner1,
    corner2: corner2.present ? corner2.value : this.corner2,
    corner3: corner3.present ? corner3.value : this.corner3,
    baseScore: baseScore ?? this.baseScore,
    bonusScore: bonusScore ?? this.bonusScore,
    isTriplet: isTriplet ?? this.isTriplet,
    isBridge: isBridge ?? this.isBridge,
    isHexagon: isHexagon ?? this.isHexagon,
    isDoubleHexagon: isDoubleHexagon ?? this.isDoubleHexagon,
    isStarter: isStarter ?? this.isStarter,
    createdAt: createdAt ?? this.createdAt,
  );
  MoveRow copyWithCompanion(MovesCompanion data) {
    return MoveRow(
      id: data.id.present ? data.id.value : this.id,
      roundId: data.roundId.present ? data.roundId.value : this.roundId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      moveIndex: data.moveIndex.present ? data.moveIndex.value : this.moveIndex,
      moveType: data.moveType.present ? data.moveType.value : this.moveType,
      corner1: data.corner1.present ? data.corner1.value : this.corner1,
      corner2: data.corner2.present ? data.corner2.value : this.corner2,
      corner3: data.corner3.present ? data.corner3.value : this.corner3,
      baseScore: data.baseScore.present ? data.baseScore.value : this.baseScore,
      bonusScore: data.bonusScore.present
          ? data.bonusScore.value
          : this.bonusScore,
      isTriplet: data.isTriplet.present ? data.isTriplet.value : this.isTriplet,
      isBridge: data.isBridge.present ? data.isBridge.value : this.isBridge,
      isHexagon: data.isHexagon.present ? data.isHexagon.value : this.isHexagon,
      isDoubleHexagon: data.isDoubleHexagon.present
          ? data.isDoubleHexagon.value
          : this.isDoubleHexagon,
      isStarter: data.isStarter.present ? data.isStarter.value : this.isStarter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoveRow(')
          ..write('id: $id, ')
          ..write('roundId: $roundId, ')
          ..write('playerId: $playerId, ')
          ..write('moveIndex: $moveIndex, ')
          ..write('moveType: $moveType, ')
          ..write('corner1: $corner1, ')
          ..write('corner2: $corner2, ')
          ..write('corner3: $corner3, ')
          ..write('baseScore: $baseScore, ')
          ..write('bonusScore: $bonusScore, ')
          ..write('isTriplet: $isTriplet, ')
          ..write('isBridge: $isBridge, ')
          ..write('isHexagon: $isHexagon, ')
          ..write('isDoubleHexagon: $isDoubleHexagon, ')
          ..write('isStarter: $isStarter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roundId,
    playerId,
    moveIndex,
    moveType,
    corner1,
    corner2,
    corner3,
    baseScore,
    bonusScore,
    isTriplet,
    isBridge,
    isHexagon,
    isDoubleHexagon,
    isStarter,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoveRow &&
          other.id == this.id &&
          other.roundId == this.roundId &&
          other.playerId == this.playerId &&
          other.moveIndex == this.moveIndex &&
          other.moveType == this.moveType &&
          other.corner1 == this.corner1 &&
          other.corner2 == this.corner2 &&
          other.corner3 == this.corner3 &&
          other.baseScore == this.baseScore &&
          other.bonusScore == this.bonusScore &&
          other.isTriplet == this.isTriplet &&
          other.isBridge == this.isBridge &&
          other.isHexagon == this.isHexagon &&
          other.isDoubleHexagon == this.isDoubleHexagon &&
          other.isStarter == this.isStarter &&
          other.createdAt == this.createdAt);
}

class MovesCompanion extends UpdateCompanion<MoveRow> {
  final Value<String> id;
  final Value<String> roundId;
  final Value<String> playerId;
  final Value<int> moveIndex;
  final Value<MoveType> moveType;
  final Value<int?> corner1;
  final Value<int?> corner2;
  final Value<int?> corner3;
  final Value<int> baseScore;
  final Value<int> bonusScore;
  final Value<bool> isTriplet;
  final Value<bool> isBridge;
  final Value<bool> isHexagon;
  final Value<bool> isDoubleHexagon;
  final Value<bool> isStarter;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MovesCompanion({
    this.id = const Value.absent(),
    this.roundId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.moveIndex = const Value.absent(),
    this.moveType = const Value.absent(),
    this.corner1 = const Value.absent(),
    this.corner2 = const Value.absent(),
    this.corner3 = const Value.absent(),
    this.baseScore = const Value.absent(),
    this.bonusScore = const Value.absent(),
    this.isTriplet = const Value.absent(),
    this.isBridge = const Value.absent(),
    this.isHexagon = const Value.absent(),
    this.isDoubleHexagon = const Value.absent(),
    this.isStarter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovesCompanion.insert({
    required String id,
    required String roundId,
    required String playerId,
    required int moveIndex,
    required MoveType moveType,
    this.corner1 = const Value.absent(),
    this.corner2 = const Value.absent(),
    this.corner3 = const Value.absent(),
    required int baseScore,
    this.bonusScore = const Value.absent(),
    this.isTriplet = const Value.absent(),
    this.isBridge = const Value.absent(),
    this.isHexagon = const Value.absent(),
    this.isDoubleHexagon = const Value.absent(),
    this.isStarter = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roundId = Value(roundId),
       playerId = Value(playerId),
       moveIndex = Value(moveIndex),
       moveType = Value(moveType),
       baseScore = Value(baseScore),
       createdAt = Value(createdAt);
  static Insertable<MoveRow> custom({
    Expression<String>? id,
    Expression<String>? roundId,
    Expression<String>? playerId,
    Expression<int>? moveIndex,
    Expression<String>? moveType,
    Expression<int>? corner1,
    Expression<int>? corner2,
    Expression<int>? corner3,
    Expression<int>? baseScore,
    Expression<int>? bonusScore,
    Expression<bool>? isTriplet,
    Expression<bool>? isBridge,
    Expression<bool>? isHexagon,
    Expression<bool>? isDoubleHexagon,
    Expression<bool>? isStarter,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roundId != null) 'round_id': roundId,
      if (playerId != null) 'player_id': playerId,
      if (moveIndex != null) 'move_index': moveIndex,
      if (moveType != null) 'move_type': moveType,
      if (corner1 != null) 'corner1': corner1,
      if (corner2 != null) 'corner2': corner2,
      if (corner3 != null) 'corner3': corner3,
      if (baseScore != null) 'base_score': baseScore,
      if (bonusScore != null) 'bonus_score': bonusScore,
      if (isTriplet != null) 'is_triplet': isTriplet,
      if (isBridge != null) 'is_bridge': isBridge,
      if (isHexagon != null) 'is_hexagon': isHexagon,
      if (isDoubleHexagon != null) 'is_double_hexagon': isDoubleHexagon,
      if (isStarter != null) 'is_starter': isStarter,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovesCompanion copyWith({
    Value<String>? id,
    Value<String>? roundId,
    Value<String>? playerId,
    Value<int>? moveIndex,
    Value<MoveType>? moveType,
    Value<int?>? corner1,
    Value<int?>? corner2,
    Value<int?>? corner3,
    Value<int>? baseScore,
    Value<int>? bonusScore,
    Value<bool>? isTriplet,
    Value<bool>? isBridge,
    Value<bool>? isHexagon,
    Value<bool>? isDoubleHexagon,
    Value<bool>? isStarter,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MovesCompanion(
      id: id ?? this.id,
      roundId: roundId ?? this.roundId,
      playerId: playerId ?? this.playerId,
      moveIndex: moveIndex ?? this.moveIndex,
      moveType: moveType ?? this.moveType,
      corner1: corner1 ?? this.corner1,
      corner2: corner2 ?? this.corner2,
      corner3: corner3 ?? this.corner3,
      baseScore: baseScore ?? this.baseScore,
      bonusScore: bonusScore ?? this.bonusScore,
      isTriplet: isTriplet ?? this.isTriplet,
      isBridge: isBridge ?? this.isBridge,
      isHexagon: isHexagon ?? this.isHexagon,
      isDoubleHexagon: isDoubleHexagon ?? this.isDoubleHexagon,
      isStarter: isStarter ?? this.isStarter,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roundId.present) {
      map['round_id'] = Variable<String>(roundId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (moveIndex.present) {
      map['move_index'] = Variable<int>(moveIndex.value);
    }
    if (moveType.present) {
      map['move_type'] = Variable<String>(
        $MovesTable.$convertermoveType.toSql(moveType.value),
      );
    }
    if (corner1.present) {
      map['corner1'] = Variable<int>(corner1.value);
    }
    if (corner2.present) {
      map['corner2'] = Variable<int>(corner2.value);
    }
    if (corner3.present) {
      map['corner3'] = Variable<int>(corner3.value);
    }
    if (baseScore.present) {
      map['base_score'] = Variable<int>(baseScore.value);
    }
    if (bonusScore.present) {
      map['bonus_score'] = Variable<int>(bonusScore.value);
    }
    if (isTriplet.present) {
      map['is_triplet'] = Variable<bool>(isTriplet.value);
    }
    if (isBridge.present) {
      map['is_bridge'] = Variable<bool>(isBridge.value);
    }
    if (isHexagon.present) {
      map['is_hexagon'] = Variable<bool>(isHexagon.value);
    }
    if (isDoubleHexagon.present) {
      map['is_double_hexagon'] = Variable<bool>(isDoubleHexagon.value);
    }
    if (isStarter.present) {
      map['is_starter'] = Variable<bool>(isStarter.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovesCompanion(')
          ..write('id: $id, ')
          ..write('roundId: $roundId, ')
          ..write('playerId: $playerId, ')
          ..write('moveIndex: $moveIndex, ')
          ..write('moveType: $moveType, ')
          ..write('corner1: $corner1, ')
          ..write('corner2: $corner2, ')
          ..write('corner3: $corner3, ')
          ..write('baseScore: $baseScore, ')
          ..write('bonusScore: $bonusScore, ')
          ..write('isTriplet: $isTriplet, ')
          ..write('isBridge: $isBridge, ')
          ..write('isHexagon: $isHexagon, ')
          ..write('isDoubleHexagon: $isDoubleHexagon, ')
          ..write('isStarter: $isStarter, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $GamePlayersTable gamePlayers = $GamePlayersTable(this);
  late final $RoundsTable rounds = $RoundsTable(this);
  late final $MovesTable moves = $MovesTable(this);
  late final PlayersDao playersDao = PlayersDao(this as AppDatabase);
  late final GamesDao gamesDao = GamesDao(this as AppDatabase);
  late final StatsDao statsDao = StatsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    players,
    games,
    gamePlayers,
    rounds,
    moves,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_players', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rounds', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rounds',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('moves', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      required String id,
      required String name,
      required String avatarColor,
      required String initials,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> avatarColor,
      Value<String> initials,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, Player> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GamePlayersTable, List<GamePlayer>>
  _gamePlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamePlayers,
    aliasName: $_aliasNameGenerator(db.players.id, db.gamePlayers.playerId),
  );

  $$GamePlayersTableProcessedTableManager get gamePlayersRefs {
    final manager = $$GamePlayersTableTableManager(
      $_db,
      $_db.gamePlayers,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamePlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initials => $composableBuilder(
    column: $table.initials,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gamePlayersRefs(
    Expression<bool> Function($$GamePlayersTableFilterComposer f) f,
  ) {
    final $$GamePlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamePlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamePlayersTableFilterComposer(
            $db: $db,
            $table: $db.gamePlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initials => $composableBuilder(
    column: $table.initials,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initials =>
      $composableBuilder(column: $table.initials, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> gamePlayersRefs<T extends Object>(
    Expression<T> Function($$GamePlayersTableAnnotationComposer a) f,
  ) {
    final $$GamePlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamePlayers,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamePlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.gamePlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          Player,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (Player, $$PlayersTableReferences),
          Player,
          PrefetchHooks Function({bool gamePlayersRefs})
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> avatarColor = const Value.absent(),
                Value<String> initials = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                name: name,
                avatarColor: avatarColor,
                initials: initials,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String avatarColor,
                required String initials,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                name: name,
                avatarColor: avatarColor,
                initials: initials,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gamePlayersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gamePlayersRefs) db.gamePlayers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gamePlayersRefs)
                    await $_getPrefetchedData<
                      Player,
                      $PlayersTable,
                      GamePlayer
                    >(
                      currentTable: table,
                      referencedTable: $$PlayersTableReferences
                          ._gamePlayersRefsTable(db),
                      managerFromTypedResult: (p0) => $$PlayersTableReferences(
                        db,
                        table,
                        p0,
                      ).gamePlayersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      Player,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (Player, $$PlayersTableReferences),
      Player,
      PrefetchHooks Function({bool gamePlayersRefs})
    >;
typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      required String id,
      required EndMode endMode,
      Value<int?> scoreLimit,
      Value<int?> totalRounds,
      Value<int> currentRound,
      required GameStatus status,
      Value<String?> winnerId,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<int> rowid,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<String> id,
      Value<EndMode> endMode,
      Value<int?> scoreLimit,
      Value<int?> totalRounds,
      Value<int> currentRound,
      Value<GameStatus> status,
      Value<String?> winnerId,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<int> rowid,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GamePlayersTable, List<GamePlayer>>
  _gamePlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamePlayers,
    aliasName: $_aliasNameGenerator(db.games.id, db.gamePlayers.gameId),
  );

  $$GamePlayersTableProcessedTableManager get gamePlayersRefs {
    final manager = $$GamePlayersTableTableManager(
      $_db,
      $_db.gamePlayers,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamePlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoundsTable, List<Round>> _roundsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rounds,
    aliasName: $_aliasNameGenerator(db.games.id, db.rounds.gameId),
  );

  $$RoundsTableProcessedTableManager get roundsRefs {
    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_roundsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EndMode, EndMode, String> get endMode =>
      $composableBuilder(
        column: $table.endMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get scoreLimit => $composableBuilder(
    column: $table.scoreLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRounds => $composableBuilder(
    column: $table.totalRounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentRound => $composableBuilder(
    column: $table.currentRound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GameStatus, GameStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get winnerId => $composableBuilder(
    column: $table.winnerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gamePlayersRefs(
    Expression<bool> Function($$GamePlayersTableFilterComposer f) f,
  ) {
    final $$GamePlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamePlayers,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamePlayersTableFilterComposer(
            $db: $db,
            $table: $db.gamePlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> roundsRefs(
    Expression<bool> Function($$RoundsTableFilterComposer f) f,
  ) {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endMode => $composableBuilder(
    column: $table.endMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scoreLimit => $composableBuilder(
    column: $table.scoreLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRounds => $composableBuilder(
    column: $table.totalRounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentRound => $composableBuilder(
    column: $table.currentRound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get winnerId => $composableBuilder(
    column: $table.winnerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EndMode, String> get endMode =>
      $composableBuilder(column: $table.endMode, builder: (column) => column);

  GeneratedColumn<int> get scoreLimit => $composableBuilder(
    column: $table.scoreLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalRounds => $composableBuilder(
    column: $table.totalRounds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentRound => $composableBuilder(
    column: $table.currentRound,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<GameStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get winnerId =>
      $composableBuilder(column: $table.winnerId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  Expression<T> gamePlayersRefs<T extends Object>(
    Expression<T> Function($$GamePlayersTableAnnotationComposer a) f,
  ) {
    final $$GamePlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamePlayers,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamePlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.gamePlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> roundsRefs<T extends Object>(
    Expression<T> Function($$RoundsTableAnnotationComposer a) f,
  ) {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({bool gamePlayersRefs, bool roundsRefs})
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<EndMode> endMode = const Value.absent(),
                Value<int?> scoreLimit = const Value.absent(),
                Value<int?> totalRounds = const Value.absent(),
                Value<int> currentRound = const Value.absent(),
                Value<GameStatus> status = const Value.absent(),
                Value<String?> winnerId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                endMode: endMode,
                scoreLimit: scoreLimit,
                totalRounds: totalRounds,
                currentRound: currentRound,
                status: status,
                winnerId: winnerId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required EndMode endMode,
                Value<int?> scoreLimit = const Value.absent(),
                Value<int?> totalRounds = const Value.absent(),
                Value<int> currentRound = const Value.absent(),
                required GameStatus status,
                Value<String?> winnerId = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                endMode: endMode,
                scoreLimit: scoreLimit,
                totalRounds: totalRounds,
                currentRound: currentRound,
                status: status,
                winnerId: winnerId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({gamePlayersRefs = false, roundsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamePlayersRefs) db.gamePlayers,
                    if (roundsRefs) db.rounds,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gamePlayersRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          GamePlayer
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._gamePlayersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).gamePlayersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (roundsRefs)
                        await $_getPrefetchedData<Game, $GamesTable, Round>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._roundsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(db, table, p0).roundsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({bool gamePlayersRefs, bool roundsRefs})
    >;
typedef $$GamePlayersTableCreateCompanionBuilder =
    GamePlayersCompanion Function({
      required String gameId,
      required String playerId,
      required int seatIndex,
      Value<int> totalScore,
      required String displayNameSnapshot,
      Value<int> rowid,
    });
typedef $$GamePlayersTableUpdateCompanionBuilder =
    GamePlayersCompanion Function({
      Value<String> gameId,
      Value<String> playerId,
      Value<int> seatIndex,
      Value<int> totalScore,
      Value<String> displayNameSnapshot,
      Value<int> rowid,
    });

final class $$GamePlayersTableReferences
    extends BaseReferences<_$AppDatabase, $GamePlayersTable, GamePlayer> {
  $$GamePlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) => db.games.createAlias(
    $_aliasNameGenerator(db.gamePlayers.gameId, db.games.id),
  );

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias(
        $_aliasNameGenerator(db.gamePlayers.playerId, db.players.id),
      );

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<String>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamePlayersTableFilterComposer
    extends Composer<_$AppDatabase, $GamePlayersTable> {
  $$GamePlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seatIndex => $composableBuilder(
    column: $table.seatIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayNameSnapshot => $composableBuilder(
    column: $table.displayNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $GamePlayersTable> {
  $$GamePlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seatIndex => $composableBuilder(
    column: $table.seatIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayNameSnapshot => $composableBuilder(
    column: $table.displayNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamePlayersTable> {
  $$GamePlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seatIndex =>
      $composableBuilder(column: $table.seatIndex, builder: (column) => column);

  GeneratedColumn<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayNameSnapshot => $composableBuilder(
    column: $table.displayNameSnapshot,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamePlayersTable,
          GamePlayer,
          $$GamePlayersTableFilterComposer,
          $$GamePlayersTableOrderingComposer,
          $$GamePlayersTableAnnotationComposer,
          $$GamePlayersTableCreateCompanionBuilder,
          $$GamePlayersTableUpdateCompanionBuilder,
          (GamePlayer, $$GamePlayersTableReferences),
          GamePlayer,
          PrefetchHooks Function({bool gameId, bool playerId})
        > {
  $$GamePlayersTableTableManager(_$AppDatabase db, $GamePlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamePlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamePlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamePlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gameId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<int> seatIndex = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<String> displayNameSnapshot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamePlayersCompanion(
                gameId: gameId,
                playerId: playerId,
                seatIndex: seatIndex,
                totalScore: totalScore,
                displayNameSnapshot: displayNameSnapshot,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gameId,
                required String playerId,
                required int seatIndex,
                Value<int> totalScore = const Value.absent(),
                required String displayNameSnapshot,
                Value<int> rowid = const Value.absent(),
              }) => GamePlayersCompanion.insert(
                gameId: gameId,
                playerId: playerId,
                seatIndex: seatIndex,
                totalScore: totalScore,
                displayNameSnapshot: displayNameSnapshot,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamePlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, playerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$GamePlayersTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$GamePlayersTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (playerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playerId,
                                referencedTable: $$GamePlayersTableReferences
                                    ._playerIdTable(db),
                                referencedColumn: $$GamePlayersTableReferences
                                    ._playerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GamePlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamePlayersTable,
      GamePlayer,
      $$GamePlayersTableFilterComposer,
      $$GamePlayersTableOrderingComposer,
      $$GamePlayersTableAnnotationComposer,
      $$GamePlayersTableCreateCompanionBuilder,
      $$GamePlayersTableUpdateCompanionBuilder,
      (GamePlayer, $$GamePlayersTableReferences),
      GamePlayer,
      PrefetchHooks Function({bool gameId, bool playerId})
    >;
typedef $$RoundsTableCreateCompanionBuilder =
    RoundsCompanion Function({
      required String id,
      required String gameId,
      required int roundNumber,
      required String starterPlayerId,
      Value<String?> finisherPlayerId,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<int> rowid,
    });
typedef $$RoundsTableUpdateCompanionBuilder =
    RoundsCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<int> roundNumber,
      Value<String> starterPlayerId,
      Value<String?> finisherPlayerId,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<int> rowid,
    });

final class $$RoundsTableReferences
    extends BaseReferences<_$AppDatabase, $RoundsTable, Round> {
  $$RoundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias($_aliasNameGenerator(db.rounds.gameId, db.games.id));

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MovesTable, List<MoveRow>> _movesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.moves,
    aliasName: $_aliasNameGenerator(db.rounds.id, db.moves.roundId),
  );

  $$MovesTableProcessedTableManager get movesRefs {
    final manager = $$MovesTableTableManager(
      $_db,
      $_db.moves,
    ).filter((f) => f.roundId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoundsTableFilterComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get starterPlayerId => $composableBuilder(
    column: $table.starterPlayerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finisherPlayerId => $composableBuilder(
    column: $table.finisherPlayerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movesRefs(
    Expression<bool> Function($$MovesTableFilterComposer f) f,
  ) {
    final $$MovesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moves,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovesTableFilterComposer(
            $db: $db,
            $table: $db.moves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoundsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get starterPlayerId => $composableBuilder(
    column: $table.starterPlayerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finisherPlayerId => $composableBuilder(
    column: $table.finisherPlayerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoundsTable> {
  $$RoundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get starterPlayerId => $composableBuilder(
    column: $table.starterPlayerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get finisherPlayerId => $composableBuilder(
    column: $table.finisherPlayerId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movesRefs<T extends Object>(
    Expression<T> Function($$MovesTableAnnotationComposer a) f,
  ) {
    final $$MovesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.moves,
      getReferencedColumn: (t) => t.roundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovesTableAnnotationComposer(
            $db: $db,
            $table: $db.moves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoundsTable,
          Round,
          $$RoundsTableFilterComposer,
          $$RoundsTableOrderingComposer,
          $$RoundsTableAnnotationComposer,
          $$RoundsTableCreateCompanionBuilder,
          $$RoundsTableUpdateCompanionBuilder,
          (Round, $$RoundsTableReferences),
          Round,
          PrefetchHooks Function({bool gameId, bool movesRefs})
        > {
  $$RoundsTableTableManager(_$AppDatabase db, $RoundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<int> roundNumber = const Value.absent(),
                Value<String> starterPlayerId = const Value.absent(),
                Value<String?> finisherPlayerId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoundsCompanion(
                id: id,
                gameId: gameId,
                roundNumber: roundNumber,
                starterPlayerId: starterPlayerId,
                finisherPlayerId: finisherPlayerId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required int roundNumber,
                required String starterPlayerId,
                Value<String?> finisherPlayerId = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoundsCompanion.insert(
                id: id,
                gameId: gameId,
                roundNumber: roundNumber,
                starterPlayerId: starterPlayerId,
                finisherPlayerId: finisherPlayerId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RoundsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, movesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (movesRefs) db.moves],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$RoundsTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$RoundsTableReferences
                                    ._gameIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (movesRefs)
                    await $_getPrefetchedData<Round, $RoundsTable, MoveRow>(
                      currentTable: table,
                      referencedTable: $$RoundsTableReferences._movesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$RoundsTableReferences(db, table, p0).movesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.roundId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoundsTable,
      Round,
      $$RoundsTableFilterComposer,
      $$RoundsTableOrderingComposer,
      $$RoundsTableAnnotationComposer,
      $$RoundsTableCreateCompanionBuilder,
      $$RoundsTableUpdateCompanionBuilder,
      (Round, $$RoundsTableReferences),
      Round,
      PrefetchHooks Function({bool gameId, bool movesRefs})
    >;
typedef $$MovesTableCreateCompanionBuilder =
    MovesCompanion Function({
      required String id,
      required String roundId,
      required String playerId,
      required int moveIndex,
      required MoveType moveType,
      Value<int?> corner1,
      Value<int?> corner2,
      Value<int?> corner3,
      required int baseScore,
      Value<int> bonusScore,
      Value<bool> isTriplet,
      Value<bool> isBridge,
      Value<bool> isHexagon,
      Value<bool> isDoubleHexagon,
      Value<bool> isStarter,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MovesTableUpdateCompanionBuilder =
    MovesCompanion Function({
      Value<String> id,
      Value<String> roundId,
      Value<String> playerId,
      Value<int> moveIndex,
      Value<MoveType> moveType,
      Value<int?> corner1,
      Value<int?> corner2,
      Value<int?> corner3,
      Value<int> baseScore,
      Value<int> bonusScore,
      Value<bool> isTriplet,
      Value<bool> isBridge,
      Value<bool> isHexagon,
      Value<bool> isDoubleHexagon,
      Value<bool> isStarter,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MovesTableReferences
    extends BaseReferences<_$AppDatabase, $MovesTable, MoveRow> {
  $$MovesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoundsTable _roundIdTable(_$AppDatabase db) => db.rounds.createAlias(
    $_aliasNameGenerator(db.moves.roundId, db.rounds.id),
  );

  $$RoundsTableProcessedTableManager get roundId {
    final $_column = $_itemColumn<String>('round_id')!;

    final manager = $$RoundsTableTableManager(
      $_db,
      $_db.rounds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovesTableFilterComposer extends Composer<_$AppDatabase, $MovesTable> {
  $$MovesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moveIndex => $composableBuilder(
    column: $table.moveIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MoveType, MoveType, String> get moveType =>
      $composableBuilder(
        column: $table.moveType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get corner1 => $composableBuilder(
    column: $table.corner1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get corner2 => $composableBuilder(
    column: $table.corner2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get corner3 => $composableBuilder(
    column: $table.corner3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseScore => $composableBuilder(
    column: $table.baseScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonusScore => $composableBuilder(
    column: $table.bonusScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTriplet => $composableBuilder(
    column: $table.isTriplet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBridge => $composableBuilder(
    column: $table.isBridge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHexagon => $composableBuilder(
    column: $table.isHexagon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDoubleHexagon => $composableBuilder(
    column: $table.isDoubleHexagon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarter => $composableBuilder(
    column: $table.isStarter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoundsTableFilterComposer get roundId {
    final $$RoundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableFilterComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovesTableOrderingComposer
    extends Composer<_$AppDatabase, $MovesTable> {
  $$MovesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moveIndex => $composableBuilder(
    column: $table.moveIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moveType => $composableBuilder(
    column: $table.moveType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get corner1 => $composableBuilder(
    column: $table.corner1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get corner2 => $composableBuilder(
    column: $table.corner2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get corner3 => $composableBuilder(
    column: $table.corner3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseScore => $composableBuilder(
    column: $table.baseScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonusScore => $composableBuilder(
    column: $table.bonusScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTriplet => $composableBuilder(
    column: $table.isTriplet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBridge => $composableBuilder(
    column: $table.isBridge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHexagon => $composableBuilder(
    column: $table.isHexagon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDoubleHexagon => $composableBuilder(
    column: $table.isDoubleHexagon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarter => $composableBuilder(
    column: $table.isStarter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoundsTableOrderingComposer get roundId {
    final $$RoundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableOrderingComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovesTable> {
  $$MovesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<int> get moveIndex =>
      $composableBuilder(column: $table.moveIndex, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MoveType, String> get moveType =>
      $composableBuilder(column: $table.moveType, builder: (column) => column);

  GeneratedColumn<int> get corner1 =>
      $composableBuilder(column: $table.corner1, builder: (column) => column);

  GeneratedColumn<int> get corner2 =>
      $composableBuilder(column: $table.corner2, builder: (column) => column);

  GeneratedColumn<int> get corner3 =>
      $composableBuilder(column: $table.corner3, builder: (column) => column);

  GeneratedColumn<int> get baseScore =>
      $composableBuilder(column: $table.baseScore, builder: (column) => column);

  GeneratedColumn<int> get bonusScore => $composableBuilder(
    column: $table.bonusScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTriplet =>
      $composableBuilder(column: $table.isTriplet, builder: (column) => column);

  GeneratedColumn<bool> get isBridge =>
      $composableBuilder(column: $table.isBridge, builder: (column) => column);

  GeneratedColumn<bool> get isHexagon =>
      $composableBuilder(column: $table.isHexagon, builder: (column) => column);

  GeneratedColumn<bool> get isDoubleHexagon => $composableBuilder(
    column: $table.isDoubleHexagon,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStarter =>
      $composableBuilder(column: $table.isStarter, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RoundsTableAnnotationComposer get roundId {
    final $$RoundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roundId,
      referencedTable: $db.rounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoundsTableAnnotationComposer(
            $db: $db,
            $table: $db.rounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovesTable,
          MoveRow,
          $$MovesTableFilterComposer,
          $$MovesTableOrderingComposer,
          $$MovesTableAnnotationComposer,
          $$MovesTableCreateCompanionBuilder,
          $$MovesTableUpdateCompanionBuilder,
          (MoveRow, $$MovesTableReferences),
          MoveRow,
          PrefetchHooks Function({bool roundId})
        > {
  $$MovesTableTableManager(_$AppDatabase db, $MovesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roundId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<int> moveIndex = const Value.absent(),
                Value<MoveType> moveType = const Value.absent(),
                Value<int?> corner1 = const Value.absent(),
                Value<int?> corner2 = const Value.absent(),
                Value<int?> corner3 = const Value.absent(),
                Value<int> baseScore = const Value.absent(),
                Value<int> bonusScore = const Value.absent(),
                Value<bool> isTriplet = const Value.absent(),
                Value<bool> isBridge = const Value.absent(),
                Value<bool> isHexagon = const Value.absent(),
                Value<bool> isDoubleHexagon = const Value.absent(),
                Value<bool> isStarter = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovesCompanion(
                id: id,
                roundId: roundId,
                playerId: playerId,
                moveIndex: moveIndex,
                moveType: moveType,
                corner1: corner1,
                corner2: corner2,
                corner3: corner3,
                baseScore: baseScore,
                bonusScore: bonusScore,
                isTriplet: isTriplet,
                isBridge: isBridge,
                isHexagon: isHexagon,
                isDoubleHexagon: isDoubleHexagon,
                isStarter: isStarter,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roundId,
                required String playerId,
                required int moveIndex,
                required MoveType moveType,
                Value<int?> corner1 = const Value.absent(),
                Value<int?> corner2 = const Value.absent(),
                Value<int?> corner3 = const Value.absent(),
                required int baseScore,
                Value<int> bonusScore = const Value.absent(),
                Value<bool> isTriplet = const Value.absent(),
                Value<bool> isBridge = const Value.absent(),
                Value<bool> isHexagon = const Value.absent(),
                Value<bool> isDoubleHexagon = const Value.absent(),
                Value<bool> isStarter = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MovesCompanion.insert(
                id: id,
                roundId: roundId,
                playerId: playerId,
                moveIndex: moveIndex,
                moveType: moveType,
                corner1: corner1,
                corner2: corner2,
                corner3: corner3,
                baseScore: baseScore,
                bonusScore: bonusScore,
                isTriplet: isTriplet,
                isBridge: isBridge,
                isHexagon: isHexagon,
                isDoubleHexagon: isDoubleHexagon,
                isStarter: isStarter,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MovesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({roundId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (roundId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.roundId,
                                referencedTable: $$MovesTableReferences
                                    ._roundIdTable(db),
                                referencedColumn: $$MovesTableReferences
                                    ._roundIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovesTable,
      MoveRow,
      $$MovesTableFilterComposer,
      $$MovesTableOrderingComposer,
      $$MovesTableAnnotationComposer,
      $$MovesTableCreateCompanionBuilder,
      $$MovesTableUpdateCompanionBuilder,
      (MoveRow, $$MovesTableReferences),
      MoveRow,
      PrefetchHooks Function({bool roundId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$GamePlayersTableTableManager get gamePlayers =>
      $$GamePlayersTableTableManager(_db, _db.gamePlayers);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db, _db.rounds);
  $$MovesTableTableManager get moves =>
      $$MovesTableTableManager(_db, _db.moves);
}
