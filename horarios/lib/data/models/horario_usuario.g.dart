// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horario_usuario.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHorarioUsuarioCollection on Isar {
  IsarCollection<HorarioUsuario> get horarioUsuarios => this.collection();
}

const HorarioUsuarioSchema = CollectionSchema(
  name: r'HorarioUsuario',
  id: 514617047043716,
  properties: {
    r'fechaActualizacion': PropertySchema(
      id: 0,
      name: r'fechaActualizacion',
      type: IsarType.dateTime,
    ),
    r'materiasSeleccionadas': PropertySchema(
      id: 1,
      name: r'materiasSeleccionadas',
      type: IsarType.objectList,
      target: r'MateriaSeleccionada',
    ),
    r'titulo': PropertySchema(
      id: 2,
      name: r'titulo',
      type: IsarType.string,
    )
  },
  estimateSize: _horarioUsuarioEstimateSize,
  serialize: _horarioUsuarioSerialize,
  deserialize: _horarioUsuarioDeserialize,
  deserializeProp: _horarioUsuarioDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'MateriaSeleccionada': MateriaSeleccionadaSchema,
    r'BloqueHorario': BloqueHorarioSchema
  },
  getId: _horarioUsuarioGetId,
  getLinks: _horarioUsuarioGetLinks,
  attach: _horarioUsuarioAttach,
  version: '3.1.0+1',
);

int _horarioUsuarioEstimateSize(
  HorarioUsuario object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.materiasSeleccionadas.length * 3;
  {
    final offsets = allOffsets[MateriaSeleccionada]!;
    for (var i = 0; i < object.materiasSeleccionadas.length; i++) {
      final value = object.materiasSeleccionadas[i];
      bytesCount +=
          MateriaSeleccionadaSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.titulo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _horarioUsuarioSerialize(
  HorarioUsuario object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.fechaActualizacion);
  writer.writeObjectList<MateriaSeleccionada>(
    offsets[1],
    allOffsets,
    MateriaSeleccionadaSchema.serialize,
    object.materiasSeleccionadas,
  );
  writer.writeString(offsets[2], object.titulo);
}

HorarioUsuario _horarioUsuarioDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HorarioUsuario();
  object.fechaActualizacion = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.materiasSeleccionadas = reader.readObjectList<MateriaSeleccionada>(
        offsets[1],
        MateriaSeleccionadaSchema.deserialize,
        allOffsets,
        MateriaSeleccionada(),
      ) ??
      [];
  object.titulo = reader.readStringOrNull(offsets[2]);
  return object;
}

P _horarioUsuarioDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readObjectList<MateriaSeleccionada>(
            offset,
            MateriaSeleccionadaSchema.deserialize,
            allOffsets,
            MateriaSeleccionada(),
          ) ??
          []) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _horarioUsuarioGetId(HorarioUsuario object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _horarioUsuarioGetLinks(HorarioUsuario object) {
  return [];
}

void _horarioUsuarioAttach(
    IsarCollection<dynamic> col, Id id, HorarioUsuario object) {
  object.id = id;
}

extension HorarioUsuarioQueryWhereSort
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QWhere> {
  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HorarioUsuarioQueryWhere
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QWhereClause> {
  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterWhereClause> idBetween(
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

extension HorarioUsuarioQueryFilter
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QFilterCondition> {
  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      fechaActualizacionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fechaActualizacion',
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      fechaActualizacionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fechaActualizacion',
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      fechaActualizacionEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fechaActualizacion',
        value: value,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      fechaActualizacionGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fechaActualizacion',
        value: value,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      fechaActualizacionLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fechaActualizacion',
        value: value,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      fechaActualizacionBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fechaActualizacion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
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

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      materiasSeleccionadasLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasSeleccionadas',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      materiasSeleccionadasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasSeleccionadas',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      materiasSeleccionadasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasSeleccionadas',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      materiasSeleccionadasLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasSeleccionadas',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      materiasSeleccionadasLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasSeleccionadas',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      materiasSeleccionadasLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'materiasSeleccionadas',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'titulo',
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'titulo',
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titulo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titulo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titulo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titulo',
        value: '',
      ));
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      tituloIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titulo',
        value: '',
      ));
    });
  }
}

extension HorarioUsuarioQueryObject
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QFilterCondition> {
  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterFilterCondition>
      materiasSeleccionadasElement(FilterQuery<MateriaSeleccionada> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'materiasSeleccionadas');
    });
  }
}

extension HorarioUsuarioQueryLinks
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QFilterCondition> {}

extension HorarioUsuarioQuerySortBy
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QSortBy> {
  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy>
      sortByFechaActualizacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaActualizacion', Sort.asc);
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy>
      sortByFechaActualizacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaActualizacion', Sort.desc);
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy> sortByTitulo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titulo', Sort.asc);
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy>
      sortByTituloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titulo', Sort.desc);
    });
  }
}

extension HorarioUsuarioQuerySortThenBy
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QSortThenBy> {
  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy>
      thenByFechaActualizacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaActualizacion', Sort.asc);
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy>
      thenByFechaActualizacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fechaActualizacion', Sort.desc);
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy> thenByTitulo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titulo', Sort.asc);
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QAfterSortBy>
      thenByTituloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titulo', Sort.desc);
    });
  }
}

extension HorarioUsuarioQueryWhereDistinct
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QDistinct> {
  QueryBuilder<HorarioUsuario, HorarioUsuario, QDistinct>
      distinctByFechaActualizacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fechaActualizacion');
    });
  }

  QueryBuilder<HorarioUsuario, HorarioUsuario, QDistinct> distinctByTitulo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titulo', caseSensitive: caseSensitive);
    });
  }
}

extension HorarioUsuarioQueryProperty
    on QueryBuilder<HorarioUsuario, HorarioUsuario, QQueryProperty> {
  QueryBuilder<HorarioUsuario, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HorarioUsuario, DateTime?, QQueryOperations>
      fechaActualizacionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fechaActualizacion');
    });
  }

  QueryBuilder<HorarioUsuario, List<MateriaSeleccionada>, QQueryOperations>
      materiasSeleccionadasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materiasSeleccionadas');
    });
  }

  QueryBuilder<HorarioUsuario, String?, QQueryOperations> tituloProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titulo');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MateriaSeleccionadaSchema = Schema(
  name: r'MateriaSeleccionada',
  id: -851079244793238,
  properties: {
    r'aula': PropertySchema(
      id: 0,
      name: r'aula',
      type: IsarType.string,
    ),
    r'bloques': PropertySchema(
      id: 1,
      name: r'bloques',
      type: IsarType.objectList,
      target: r'BloqueHorario',
    ),
    r'colorARGB': PropertySchema(
      id: 2,
      name: r'colorARGB',
      type: IsarType.long,
    ),
    r'materiaId': PropertySchema(
      id: 3,
      name: r'materiaId',
      type: IsarType.string,
    ),
    r'materiaNombre': PropertySchema(
      id: 4,
      name: r'materiaNombre',
      type: IsarType.string,
    ),
    r'notas': PropertySchema(
      id: 5,
      name: r'notas',
      type: IsarType.string,
    ),
    r'profesores': PropertySchema(
      id: 6,
      name: r'profesores',
      type: IsarType.stringList,
    )
  },
  estimateSize: _materiaSeleccionadaEstimateSize,
  serialize: _materiaSeleccionadaSerialize,
  deserialize: _materiaSeleccionadaDeserialize,
  deserializeProp: _materiaSeleccionadaDeserializeProp,
);

int _materiaSeleccionadaEstimateSize(
  MateriaSeleccionada object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.aula;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.bloques.length * 3;
  {
    final offsets = allOffsets[BloqueHorario]!;
    for (var i = 0; i < object.bloques.length; i++) {
      final value = object.bloques[i];
      bytesCount +=
          BloqueHorarioSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.materiaId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.materiaNombre;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notas;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.profesores.length * 3;
  {
    for (var i = 0; i < object.profesores.length; i++) {
      final value = object.profesores[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _materiaSeleccionadaSerialize(
  MateriaSeleccionada object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aula);
  writer.writeObjectList<BloqueHorario>(
    offsets[1],
    allOffsets,
    BloqueHorarioSchema.serialize,
    object.bloques,
  );
  writer.writeLong(offsets[2], object.colorARGB);
  writer.writeString(offsets[3], object.materiaId);
  writer.writeString(offsets[4], object.materiaNombre);
  writer.writeString(offsets[5], object.notas);
  writer.writeStringList(offsets[6], object.profesores);
}

MateriaSeleccionada _materiaSeleccionadaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MateriaSeleccionada();
  object.aula = reader.readStringOrNull(offsets[0]);
  object.bloques = reader.readObjectList<BloqueHorario>(
        offsets[1],
        BloqueHorarioSchema.deserialize,
        allOffsets,
        BloqueHorario(),
      ) ??
      [];
  object.colorARGB = reader.readLongOrNull(offsets[2]);
  object.materiaId = reader.readStringOrNull(offsets[3]);
  object.materiaNombre = reader.readStringOrNull(offsets[4]);
  object.notas = reader.readStringOrNull(offsets[5]);
  object.profesores = reader.readStringList(offsets[6]) ?? [];
  return object;
}

P _materiaSeleccionadaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readObjectList<BloqueHorario>(
            offset,
            BloqueHorarioSchema.deserialize,
            allOffsets,
            BloqueHorario(),
          ) ??
          []) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MateriaSeleccionadaQueryFilter on QueryBuilder<MateriaSeleccionada,
    MateriaSeleccionada, QFilterCondition> {
  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aula',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aula',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aula',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aula',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aula',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      aulaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aula',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      bloquesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bloques',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      bloquesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bloques',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      bloquesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bloques',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      bloquesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bloques',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      bloquesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bloques',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      bloquesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bloques',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      colorARGBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'colorARGB',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      colorARGBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'colorARGB',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      colorARGBEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorARGB',
        value: value,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      colorARGBGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorARGB',
        value: value,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      colorARGBLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorARGB',
        value: value,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      colorARGBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorARGB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'materiaId',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'materiaId',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdEqualTo(
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

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdGreaterThan(
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

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdLessThan(
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

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdBetween(
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

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
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

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
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

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'materiaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'materiaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materiaId',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'materiaId',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'materiaNombre',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'materiaNombre',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materiaNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'materiaNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'materiaNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'materiaNombre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'materiaNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'materiaNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'materiaNombre',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'materiaNombre',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materiaNombre',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      materiaNombreIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'materiaNombre',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notas',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notas',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notas',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notas',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      notasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notas',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profesores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profesores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profesores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profesores',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profesores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profesores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profesores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profesores',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profesores',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profesores',
        value: '',
      ));
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profesores',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profesores',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profesores',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profesores',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profesores',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      profesoresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'profesores',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension MateriaSeleccionadaQueryObject on QueryBuilder<MateriaSeleccionada,
    MateriaSeleccionada, QFilterCondition> {
  QueryBuilder<MateriaSeleccionada, MateriaSeleccionada, QAfterFilterCondition>
      bloquesElement(FilterQuery<BloqueHorario> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'bloques');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const BloqueHorarioSchema = Schema(
  name: r'BloqueHorario',
  id: -644508994527177,
  properties: {
    r'aula': PropertySchema(
      id: 0,
      name: r'aula',
      type: IsarType.string,
    ),
    r'dia': PropertySchema(
      id: 1,
      name: r'dia',
      type: IsarType.string,
    ),
    r'horaFin': PropertySchema(
      id: 2,
      name: r'horaFin',
      type: IsarType.string,
    ),
    r'horaInicio': PropertySchema(
      id: 3,
      name: r'horaInicio',
      type: IsarType.string,
    )
  },
  estimateSize: _bloqueHorarioEstimateSize,
  serialize: _bloqueHorarioSerialize,
  deserialize: _bloqueHorarioDeserialize,
  deserializeProp: _bloqueHorarioDeserializeProp,
);

int _bloqueHorarioEstimateSize(
  BloqueHorario object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.aula;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dia;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.horaFin;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.horaInicio;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bloqueHorarioSerialize(
  BloqueHorario object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aula);
  writer.writeString(offsets[1], object.dia);
  writer.writeString(offsets[2], object.horaFin);
  writer.writeString(offsets[3], object.horaInicio);
}

BloqueHorario _bloqueHorarioDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BloqueHorario();
  object.aula = reader.readStringOrNull(offsets[0]);
  object.dia = reader.readStringOrNull(offsets[1]);
  object.horaFin = reader.readStringOrNull(offsets[2]);
  object.horaInicio = reader.readStringOrNull(offsets[3]);
  return object;
}

P _bloqueHorarioDeserializeProp<P>(
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
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension BloqueHorarioQueryFilter
    on QueryBuilder<BloqueHorario, BloqueHorario, QFilterCondition> {
  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aula',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aula',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> aulaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> aulaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aula',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aula',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> aulaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aula',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aula',
        value: '',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      aulaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aula',
        value: '',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      diaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dia',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      diaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dia',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> diaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      diaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> diaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> diaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dia',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      diaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> diaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> diaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition> diaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dia',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      diaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dia',
        value: '',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      diaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dia',
        value: '',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'horaFin',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'horaFin',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'horaFin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'horaFin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'horaFin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'horaFin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'horaFin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'horaFin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'horaFin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'horaFin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'horaFin',
        value: '',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaFinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'horaFin',
        value: '',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'horaInicio',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'horaInicio',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'horaInicio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'horaInicio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'horaInicio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'horaInicio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'horaInicio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'horaInicio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'horaInicio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'horaInicio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'horaInicio',
        value: '',
      ));
    });
  }

  QueryBuilder<BloqueHorario, BloqueHorario, QAfterFilterCondition>
      horaInicioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'horaInicio',
        value: '',
      ));
    });
  }
}

extension BloqueHorarioQueryObject
    on QueryBuilder<BloqueHorario, BloqueHorario, QFilterCondition> {}
