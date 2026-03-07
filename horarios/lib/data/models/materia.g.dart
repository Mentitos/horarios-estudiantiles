// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materia.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMateriaCollection on Isar {
  IsarCollection<Materia> get materias => this.collection();
}

const MateriaSchema = CollectionSchema(
  name: r'Materia',
  id: -337303220298979,
  properties: {
    r'materiaId': PropertySchema(
      id: 0,
      name: r'materiaId',
      type: IsarType.string,
    ),
    r'nombre': PropertySchema(
      id: 1,
      name: r'nombre',
      type: IsarType.string,
    )
  },
  estimateSize: _materiaEstimateSize,
  serialize: _materiaSerialize,
  deserialize: _materiaDeserialize,
  deserializeProp: _materiaDeserializeProp,
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
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _materiaGetId,
  getLinks: _materiaGetLinks,
  attach: _materiaAttach,
  version: '3.1.0+1',
);

int _materiaEstimateSize(
  Materia object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.materiaId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nombre;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _materiaSerialize(
  Materia object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.materiaId);
  writer.writeString(offsets[1], object.nombre);
}

Materia _materiaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Materia();
  object.id = id;
  object.materiaId = reader.readStringOrNull(offsets[0]);
  object.nombre = reader.readStringOrNull(offsets[1]);
  return object;
}

P _materiaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _materiaGetId(Materia object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _materiaGetLinks(Materia object) {
  return [];
}

void _materiaAttach(IsarCollection<dynamic> col, Id id, Materia object) {
  object.id = id;
}

extension MateriaByIndex on IsarCollection<Materia> {
  Future<Materia?> getByMateriaId(String? materiaId) {
    return getByIndex(r'materiaId', [materiaId]);
  }

  Materia? getByMateriaIdSync(String? materiaId) {
    return getByIndexSync(r'materiaId', [materiaId]);
  }

  Future<bool> deleteByMateriaId(String? materiaId) {
    return deleteByIndex(r'materiaId', [materiaId]);
  }

  bool deleteByMateriaIdSync(String? materiaId) {
    return deleteByIndexSync(r'materiaId', [materiaId]);
  }

  Future<List<Materia?>> getAllByMateriaId(List<String?> materiaIdValues) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'materiaId', values);
  }

  List<Materia?> getAllByMateriaIdSync(List<String?> materiaIdValues) {
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

  Future<Id> putByMateriaId(Materia object) {
    return putByIndex(r'materiaId', object);
  }

  Id putByMateriaIdSync(Materia object, {bool saveLinks = true}) {
    return putByIndexSync(r'materiaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMateriaId(List<Materia> objects) {
    return putAllByIndex(r'materiaId', objects);
  }

  List<Id> putAllByMateriaIdSync(List<Materia> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'materiaId', objects, saveLinks: saveLinks);
  }
}

extension MateriaQueryWhereSort on QueryBuilder<Materia, Materia, QWhere> {
  QueryBuilder<Materia, Materia, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MateriaQueryWhere on QueryBuilder<Materia, Materia, QWhereClause> {
  QueryBuilder<Materia, Materia, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Materia, Materia, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Materia, Materia, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Materia, Materia, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterWhereClause> materiaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'materiaId',
        value: [null],
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterWhereClause> materiaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'materiaId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterWhereClause> materiaIdEqualTo(
      String? materiaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'materiaId',
        value: [materiaId],
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterWhereClause> materiaIdNotEqualTo(
      String? materiaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'materiaId',
              lower: [],
              upper: [materiaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'materiaId',
              lower: [materiaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'materiaId',
              lower: [materiaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'materiaId',
              lower: [],
              upper: [materiaId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MateriaQueryFilter
    on QueryBuilder<Materia, Materia, QFilterCondition> {
  QueryBuilder<Materia, Materia, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'materiaId',
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'materiaId',
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materiaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'materiaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'materiaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'materiaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'materiaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'materiaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'materiaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'materiaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materiaId',
        value: '',
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> materiaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'materiaId',
        value: '',
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nombre',
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nombre',
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nombre',
        value: '',
      ));
    });
  }

  QueryBuilder<Materia, Materia, QAfterFilterCondition> nombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nombre',
        value: '',
      ));
    });
  }
}

extension MateriaQueryObject
    on QueryBuilder<Materia, Materia, QFilterCondition> {}

extension MateriaQueryLinks
    on QueryBuilder<Materia, Materia, QFilterCondition> {}

extension MateriaQuerySortBy on QueryBuilder<Materia, Materia, QSortBy> {
  QueryBuilder<Materia, Materia, QAfterSortBy> sortByMateriaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.asc);
    });
  }

  QueryBuilder<Materia, Materia, QAfterSortBy> sortByMateriaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.desc);
    });
  }

  QueryBuilder<Materia, Materia, QAfterSortBy> sortByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<Materia, Materia, QAfterSortBy> sortByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }
}

extension MateriaQuerySortThenBy
    on QueryBuilder<Materia, Materia, QSortThenBy> {
  QueryBuilder<Materia, Materia, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Materia, Materia, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Materia, Materia, QAfterSortBy> thenByMateriaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.asc);
    });
  }

  QueryBuilder<Materia, Materia, QAfterSortBy> thenByMateriaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.desc);
    });
  }

  QueryBuilder<Materia, Materia, QAfterSortBy> thenByNombre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.asc);
    });
  }

  QueryBuilder<Materia, Materia, QAfterSortBy> thenByNombreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nombre', Sort.desc);
    });
  }
}

extension MateriaQueryWhereDistinct
    on QueryBuilder<Materia, Materia, QDistinct> {
  QueryBuilder<Materia, Materia, QDistinct> distinctByMateriaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'materiaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Materia, Materia, QDistinct> distinctByNombre(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nombre', caseSensitive: caseSensitive);
    });
  }
}

extension MateriaQueryProperty
    on QueryBuilder<Materia, Materia, QQueryProperty> {
  QueryBuilder<Materia, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Materia, String?, QQueryOperations> materiaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materiaId');
    });
  }

  QueryBuilder<Materia, String?, QQueryOperations> nombreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nombre');
    });
  }
}
