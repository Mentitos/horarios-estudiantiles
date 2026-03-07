// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_usuario.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPerfilUsuarioCollection on Isar {
  IsarCollection<PerfilUsuario> get perfilUsuarios => this.collection();
}

const PerfilUsuarioSchema = CollectionSchema(
  name: r'PerfilUsuario',
  id: -185477283045830,
  properties: {
    r'carrerasSeleccionadas': PropertySchema(
      id: 0,
      name: r'carrerasSeleccionadas',
      type: IsarType.stringList,
    ),
    r'materiasAprobadas': PropertySchema(
      id: 1,
      name: r'materiasAprobadas',
      type: IsarType.stringList,
    )
  },
  estimateSize: _perfilUsuarioEstimateSize,
  serialize: _perfilUsuarioSerialize,
  deserialize: _perfilUsuarioDeserialize,
  deserializeProp: _perfilUsuarioDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _perfilUsuarioGetId,
  getLinks: _perfilUsuarioGetLinks,
  attach: _perfilUsuarioAttach,
  version: '3.1.0+1',
);

int _perfilUsuarioEstimateSize(
  PerfilUsuario object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.carrerasSeleccionadas.length * 3;
  {
    for (var i = 0; i < object.carrerasSeleccionadas.length; i++) {
      final value = object.carrerasSeleccionadas[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.materiasAprobadas.length * 3;
  {
    for (var i = 0; i < object.materiasAprobadas.length; i++) {
      final value = object.materiasAprobadas[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _perfilUsuarioSerialize(
  PerfilUsuario object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.carrerasSeleccionadas);
  writer.writeStringList(offsets[1], object.materiasAprobadas);
}

PerfilUsuario _perfilUsuarioDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PerfilUsuario();
  object.carrerasSeleccionadas = reader.readStringList(offsets[0]) ?? [];
  object.id = id;
  object.materiasAprobadas = reader.readStringList(offsets[1]) ?? [];
  return object;
}

P _perfilUsuarioDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _perfilUsuarioGetId(PerfilUsuario object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _perfilUsuarioGetLinks(PerfilUsuario object) {
  return [];
}

void _perfilUsuarioAttach(
    IsarCollection<dynamic> col, Id id, PerfilUsuario object) {
  object.id = id;
}

extension PerfilUsuarioQueryWhereSort
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QWhere> {
  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PerfilUsuarioQueryWhere
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QWhereClause> {
  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterWhereClause> idBetween(
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
}

extension PerfilUsuarioQueryFilter
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QFilterCondition> {
  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carrerasSeleccionadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carrerasSeleccionadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carrerasSeleccionadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carrerasSeleccionadas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'carrerasSeleccionadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'carrerasSeleccionadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'carrerasSeleccionadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'carrerasSeleccionadas',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carrerasSeleccionadas',
        value: '',
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'carrerasSeleccionadas',
        value: '',
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'carrerasSeleccionadas',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'carrerasSeleccionadas',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'carrerasSeleccionadas',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'carrerasSeleccionadas',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'carrerasSeleccionadas',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      carrerasSeleccionadasLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'carrerasSeleccionadas',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materiasAprobadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'materiasAprobadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'materiasAprobadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'materiasAprobadas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'materiasAprobadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'materiasAprobadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'materiasAprobadas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'materiasAprobadas',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materiasAprobadas',
        value: '',
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'materiasAprobadas',
        value: '',
      ));
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasAprobadas',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasAprobadas',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasAprobadas',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasAprobadas',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasAprobadas',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterFilterCondition>
      materiasAprobadasLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasAprobadas',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PerfilUsuarioQueryObject
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QFilterCondition> {}

extension PerfilUsuarioQueryLinks
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QFilterCondition> {}

extension PerfilUsuarioQuerySortBy
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QSortBy> {}

extension PerfilUsuarioQuerySortThenBy
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QSortThenBy> {
  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension PerfilUsuarioQueryWhereDistinct
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QDistinct> {
  QueryBuilder<PerfilUsuario, PerfilUsuario, QDistinct>
      distinctByCarrerasSeleccionadas() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carrerasSeleccionadas');
    });
  }

  QueryBuilder<PerfilUsuario, PerfilUsuario, QDistinct>
      distinctByMateriasAprobadas() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'materiasAprobadas');
    });
  }
}

extension PerfilUsuarioQueryProperty
    on QueryBuilder<PerfilUsuario, PerfilUsuario, QQueryProperty> {
  QueryBuilder<PerfilUsuario, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PerfilUsuario, List<String>, QQueryOperations>
      carrerasSeleccionadasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carrerasSeleccionadas');
    });
  }

  QueryBuilder<PerfilUsuario, List<String>, QQueryOperations>
      materiasAprobadasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materiasAprobadas');
    });
  }
}
