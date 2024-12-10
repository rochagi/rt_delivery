enum DatabaseTablesEnum {
  lista(table: 'tb_lista'),
  hawb(table: 'tb_hawb'),
  hawbFinalizada(table: 'tb_hawb_finalizada'),
  coleta(table: 'tb_coleta'),
  coletaFinalizada(table: 'tb_coleta_finalizada'),
  images(table: 'tb_images');

  const DatabaseTablesEnum({required this.table});

  final String table;
}
