// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materia_notas.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMateriaNotasCollection on Isar {
  IsarCollection<MateriaNotas> get materiaNotas => this.collection();
}

const MateriaNotasSchema = CollectionSchema(
  name: r'MateriaNotas',
  id: 8260184169406381191,
  properties: {
    r'contenido': PropertySchema(
      id: 0,
      name: r'contenido',
      type: IsarType.string,
    ),
    r'materiaId': PropertySchema(
      id: 1,
      name: r'materiaId',
      type: IsarType.string,
    ),
    r'ultimaActualizacion': PropertySchema(
      id: 2,
      name: r'ultimaActualizacion',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _materiaNotasEstimateSize,
  serialize: _materiaNotasSerialize,
  deserialize: _materiaNotasDeserialize,
  deserializeProp: _materiaNotasDeserializeProp,
  idName: r'id',
  indexes: {
    r'materiaId': IndexSchema(
      id: 8446862627094492875,
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
  getId: _materiaNotasGetId,
  getLinks: _materiaNotasGetLinks,
  attach: _materiaNotasAttach,
  version: '3.1.0+1',
);

int _materiaNotasEstimateSize(
  MateriaNotas object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contenido.length * 3;
  bytesCount += 3 + object.materiaId.length * 3;
  return bytesCount;
}

void _materiaNotasSerialize(
  MateriaNotas object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.contenido);
  writer.writeString(offsets[1], object.materiaId);
  writer.writeDateTime(offsets[2], object.ultimaActualizacion);
}

MateriaNotas _materiaNotasDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MateriaNotas(
    contenido: reader.readString(offsets[0]),
    materiaId: reader.readString(offsets[1]),
    ultimaActualizacion: reader.readDateTime(offsets[2]),
  );
  object.id = id;
  return object;
}

P _materiaNotasDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _materiaNotasGetId(MateriaNotas object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _materiaNotasGetLinks(MateriaNotas object) {
  return [];
}

void _materiaNotasAttach(
    IsarCollection<dynamic> col, Id id, MateriaNotas object) {
  object.id = id;
}

extension MateriaNotasByIndex on IsarCollection<MateriaNotas> {
  Future<MateriaNotas?> getByMateriaId(String materiaId) {
    return getByIndex(r'materiaId', [materiaId]);
  }

  MateriaNotas? getByMateriaIdSync(String materiaId) {
    return getByIndexSync(r'materiaId', [materiaId]);
  }

  Future<bool> deleteByMateriaId(String materiaId) {
    return deleteByIndex(r'materiaId', [materiaId]);
  }

  bool deleteByMateriaIdSync(String materiaId) {
    return deleteByIndexSync(r'materiaId', [materiaId]);
  }

  Future<List<MateriaNotas?>> getAllByMateriaId(List<String> materiaIdValues) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'materiaId', values);
  }

  List<MateriaNotas?> getAllByMateriaIdSync(List<String> materiaIdValues) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'materiaId', values);
  }

  Future<int> deleteAllByMateriaId(List<String> materiaIdValues) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'materiaId', values);
  }

  int deleteAllByMateriaIdSync(List<String> materiaIdValues) {
    final values = materiaIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'materiaId', values);
  }

  Future<Id> putByMateriaId(MateriaNotas object) {
    return putByIndex(r'materiaId', object);
  }

  Id putByMateriaIdSync(MateriaNotas object, {bool saveLinks = true}) {
    return putByIndexSync(r'materiaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMateriaId(List<MateriaNotas> objects) {
    return putAllByIndex(r'materiaId', objects);
  }

  List<Id> putAllByMateriaIdSync(List<MateriaNotas> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'materiaId', objects, saveLinks: saveLinks);
  }
}

extension MateriaNotasQueryWhereSort
    on QueryBuilder<MateriaNotas, MateriaNotas, QWhere> {
  QueryBuilder<MateriaNotas, MateriaNotas, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MateriaNotasQueryWhere
    on QueryBuilder<MateriaNotas, MateriaNotas, QWhereClause> {
  QueryBuilder<MateriaNotas, MateriaNotas, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterWhereClause> idBetween(
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterWhereClause> materiaIdEqualTo(
      String materiaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'materiaId',
        value: [materiaId],
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterWhereClause>
      materiaIdNotEqualTo(String materiaId) {
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

extension MateriaNotasQueryFilter
    on QueryBuilder<MateriaNotas, MateriaNotas, QFilterCondition> {
  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contenido',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contenido',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contenido',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contenido',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contenido',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contenido',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contenido',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contenido',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contenido',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      contenidoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contenido',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdEqualTo(
    String value, {
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdGreaterThan(
    String value, {
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdLessThan(
    String value, {
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdBetween(
    String lower,
    String upper, {
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdStartsWith(
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdEndsWith(
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

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'materiaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'materiaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materiaId',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      materiaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'materiaId',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      ultimaActualizacionEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ultimaActualizacion',
        value: value,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      ultimaActualizacionGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ultimaActualizacion',
        value: value,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      ultimaActualizacionLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ultimaActualizacion',
        value: value,
      ));
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterFilterCondition>
      ultimaActualizacionBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ultimaActualizacion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MateriaNotasQueryObject
    on QueryBuilder<MateriaNotas, MateriaNotas, QFilterCondition> {}

extension MateriaNotasQueryLinks
    on QueryBuilder<MateriaNotas, MateriaNotas, QFilterCondition> {}

extension MateriaNotasQuerySortBy
    on QueryBuilder<MateriaNotas, MateriaNotas, QSortBy> {
  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> sortByContenido() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contenido', Sort.asc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> sortByContenidoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contenido', Sort.desc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> sortByMateriaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.asc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> sortByMateriaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.desc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy>
      sortByUltimaActualizacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimaActualizacion', Sort.asc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy>
      sortByUltimaActualizacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimaActualizacion', Sort.desc);
    });
  }
}

extension MateriaNotasQuerySortThenBy
    on QueryBuilder<MateriaNotas, MateriaNotas, QSortThenBy> {
  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> thenByContenido() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contenido', Sort.asc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> thenByContenidoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contenido', Sort.desc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> thenByMateriaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.asc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy> thenByMateriaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materiaId', Sort.desc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy>
      thenByUltimaActualizacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimaActualizacion', Sort.asc);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QAfterSortBy>
      thenByUltimaActualizacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ultimaActualizacion', Sort.desc);
    });
  }
}

extension MateriaNotasQueryWhereDistinct
    on QueryBuilder<MateriaNotas, MateriaNotas, QDistinct> {
  QueryBuilder<MateriaNotas, MateriaNotas, QDistinct> distinctByContenido(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contenido', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QDistinct> distinctByMateriaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'materiaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MateriaNotas, MateriaNotas, QDistinct>
      distinctByUltimaActualizacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ultimaActualizacion');
    });
  }
}

extension MateriaNotasQueryProperty
    on QueryBuilder<MateriaNotas, MateriaNotas, QQueryProperty> {
  QueryBuilder<MateriaNotas, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MateriaNotas, String, QQueryOperations> contenidoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contenido');
    });
  }

  QueryBuilder<MateriaNotas, String, QQueryOperations> materiaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materiaId');
    });
  }

  QueryBuilder<MateriaNotas, DateTime, QQueryOperations>
      ultimaActualizacionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ultimaActualizacion');
    });
  }
}
