// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materia_custom.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMateriaCustomCollection on Isar {
  IsarCollection<MateriaCustom> get materiaCustoms => this.collection();
}

const MateriaCustomSchema = CollectionSchema(
  name: r'MateriaCustom',
  id: -345036815389049,
  properties: {
    r'carreraAsociada': PropertySchema(
      id: 0,
      name: r'carreraAsociada',
      type: IsarType.string,
    ),
    r'esAgregadaLocalmente': PropertySchema(
      id: 1,
      name: r'esAgregadaLocalmente',
      type: IsarType.bool,
    ),
    r'estaOculta': PropertySchema(
      id: 2,
      name: r'estaOculta',
      type: IsarType.bool,
    ),
    r'materiaId': PropertySchema(
      id: 3,
      name: r'materiaId',
      type: IsarType.string,
    ),
    r'nombrePersonalizado': PropertySchema(
      id: 4,
      name: r'nombrePersonalizado',
      type: IsarType.string,
    ),
  },
  estimateSize: _materiaCustomEstimateSize,
  serialize: _materiaCustomSerialize,
  deserialize: _materiaCustomDeserialize,
  deserializeProp: _materiaCustomDeserializeProp,
  idName: r'id',
  indexes: {
    r'materiaId': IndexSchema(
      id: 844686262709449,
      name: r'materiaId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'materiaId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _materiaCustomGetId,
  getLinks: _materiaCustomGetLinks,
  attach: _materiaCustomAttach,
  version: '3.1.0+1',
);

int _materiaCustomEstimateSize(
  MateriaCustom object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.carreraAsociada;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.materiaId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nombrePersonalizado;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _materiaCustomSerialize(
  MateriaCustom object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.carreraAsociada);
  writer.writeBool(offsets[1], object.esAgregadaLocalmente);
  writer.writeBool(offsets[2], object.estaOculta);
  writer.writeString(offsets[3], object.materiaId);
  writer.writeString(offsets[4], object.nombrePersonalizado);
}

MateriaCustom _materiaCustomDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MateriaCustom();
  object.carreraAsociada = reader.readStringOrNull(offsets[0]);
  object.esAgregadaLocalmente = reader.readBool(offsets[1]);
  object.estaOculta = reader.readBool(offsets[2]);
  object.id = id;
  object.materiaId = reader.readStringOrNull(offsets[3]);
  object.nombrePersonalizado = reader.readStringOrNull(offsets[4]);
  return object;
}

P _materiaCustomDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _materiaCustomGetId(MateriaCustom object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _materiaCustomGetLinks(MateriaCustom object) {
  return [];
}

void _materiaCustomAttach(
  IsarCollection<dynamic> col,
  Id id,
  MateriaCustom object,
) {
  object.id = id;
}

extension MateriaCustomByIndex on IsarCollection<MateriaCustom> {
  Future<MateriaCustom?> getByMateriaId(String? materiaId) {
    return getByIndex(r'materiaId', [materiaId]);
  }

  MateriaCustom? getByMateriaIdSync(String? materiaId) {
    return getByIndexSync(r'materiaId', [materiaId]);
  }

  Future<bool> deleteByMateriaId(String? materiaId) {
    return deleteByIndex(r'materiaId', [materiaId]);
  }

  bool deleteByMateriaIdSync(String? materiaId) {
    return deleteByIndexSync(r'materiaId', [materiaId]);
  }

  Future<List<MateriaCustom?>> getAllByMateriaId(
    List<String?> materiaIdValues,
  ) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'materiaId', values);
  }

  List<MateriaCustom?> getAllByMateriaIdSync(List<String?> materiaIdValues) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'materiaId', values);
  }

  Future<int> deleteAllByMateriaId(List<String?> materiaIdValues) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'materiaId', values);
  }

  int deleteAllByMateriaIdSync(List<String?> materiaIdValues) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'materiaId', values);
  }

  Future<Id> putByMateriaId(MateriaCustom object) {
    return putByIndex(r'materiaId', object);
  }

  Id putByMateriaIdSync(MateriaCustom object, {bool saveLinks = true}) {
    return putByIndexSync(r'materiaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMateriaId(List<MateriaCustom> objects) {
    return putAllByIndex(r'materiaId', objects);
  }

  List<Id> putAllByMateriaIdSync(
    List<MateriaCustom> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'materiaId', objects, saveLinks: saveLinks);
  }
}

extension MateriaCustomQueryWhereSort
    on QueryBuilder<MateriaCustom, MateriaCustom, QWhere> {
  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MateriaCustomQueryWhere
    on QueryBuilder<MateriaCustom, MateriaCustom, QWhereClause> {
  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause>
  materiaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'materiaId', value: [null]),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause>
  materiaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'materiaId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause>
  materiaIdEqualTo(String? materiaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'materiaId', value: [materiaId]),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterWhereClause>
  materiaIdNotEqualTo(String? materiaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'materiaId',
                lower: [],
                upper: [materiaId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'materiaId',
                lower: [materiaId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'materiaId',
                lower: [materiaId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'materiaId',
                lower: [],
                upper: [materiaId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension MateriaCustomQueryFilter
    on QueryBuilder<MateriaCustom, MateriaCustom, QFilterCondition> {
  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'carreraAsociada'),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'carreraAsociada'),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'carreraAsociada',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'carreraAsociada',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'carreraAsociada',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'carreraAsociada',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'carreraAsociada',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'carreraAsociada',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'carreraAsociada',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'carreraAsociada',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'carreraAsociada', value: ''),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  carreraAsociadaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'carreraAsociada', value: ''),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  esAgregadaLocalmenteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'esAgregadaLocalmente',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  estaOcultaEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'estaOculta', value: value),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'materiaId'),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'materiaId'),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'materiaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'materiaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'materiaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'materiaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'materiaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'materiaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'materiaId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'materiaId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'materiaId', value: ''),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  materiaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'materiaId', value: ''),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nombrePersonalizado'),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nombrePersonalizado'),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nombrePersonalizado',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nombrePersonalizado',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nombrePersonalizado',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nombrePersonalizado',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nombrePersonalizado',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nombrePersonalizado',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nombrePersonalizado',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nombrePersonalizado',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nombrePersonalizado', value: ''),
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterFilterCondition>
  nombrePersonalizadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'nombrePersonalizado',
          value: '',
        ),
      );
    });
  }
}

extension MateriaCustomQueryObject
    on QueryBuilder<MateriaCustom, MateriaCustom, QFilterCondition> {}

extension MateriaCustomQueryLinks
    on QueryBuilder<MateriaCustom, MateriaCustom, QFilterCondition> {}

extension MateriaCustomQuerySortBy
    on QueryBuilder<MateriaCustom, MateriaCustom, QSortBy> {
  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  sortByCarreraAsociada() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carreraAsociada', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  sortByCarreraAsociadaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carreraAsociada', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  sortByEsAgregadaLocalmente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'esAgregadaLocalmente', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  sortByEsAgregadaLocalmenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'esAgregadaLocalmente', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy> sortByEstaOculta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estaOculta', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  sortByEstaOcultaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estaOculta', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy> sortByMateriaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  sortByMateriaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  sortByNombrePersonalizado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombrePersonalizado', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  sortByNombrePersonalizadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombrePersonalizado', Sort.desc);
    });
  }
}

extension MateriaCustomQuerySortThenBy
    on QueryBuilder<MateriaCustom, MateriaCustom, QSortThenBy> {
  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  thenByCarreraAsociada() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carreraAsociada', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  thenByCarreraAsociadaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carreraAsociada', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  thenByEsAgregadaLocalmente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'esAgregadaLocalmente', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  thenByEsAgregadaLocalmenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'esAgregadaLocalmente', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy> thenByEstaOculta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estaOculta', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  thenByEstaOcultaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estaOculta', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy> thenByMateriaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  thenByMateriaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.desc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  thenByNombrePersonalizado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombrePersonalizado', Sort.asc);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QAfterSortBy>
  thenByNombrePersonalizadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombrePersonalizado', Sort.desc);
    });
  }
}

extension MateriaCustomQueryWhereDistinct
    on QueryBuilder<MateriaCustom, MateriaCustom, QDistinct> {
  QueryBuilder<MateriaCustom, MateriaCustom, QDistinct>
  distinctByCarreraAsociada({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'carreraAsociada',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QDistinct>
  distinctByEsAgregadaLocalmente() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'esAgregadaLocalmente');
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QDistinct> distinctByEstaOculta() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estaOculta');
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QDistinct> distinctByMateriaId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'materiaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MateriaCustom, MateriaCustom, QDistinct>
  distinctByNombrePersonalizado({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'nombrePersonalizado',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension MateriaCustomQueryProperty
    on QueryBuilder<MateriaCustom, MateriaCustom, QQueryProperty> {
  QueryBuilder<MateriaCustom, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MateriaCustom, String?, QQueryOperations>
  carreraAsociadaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carreraAsociada');
    });
  }

  QueryBuilder<MateriaCustom, bool, QQueryOperations>
  esAgregadaLocalmenteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'esAgregadaLocalmente');
    });
  }

  QueryBuilder<MateriaCustom, bool, QQueryOperations> estaOcultaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estaOculta');
    });
  }

  QueryBuilder<MateriaCustom, String?, QQueryOperations> materiaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materiaId');
    });
  }

  QueryBuilder<MateriaCustom, String?, QQueryOperations>
  nombrePersonalizadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nombrePersonalizado');
    });
  }
}
