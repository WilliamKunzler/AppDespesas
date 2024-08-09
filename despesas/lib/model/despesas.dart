class Despesas {
  final String descricao;
  final double valor;
  final String area;
  final DateTime data;


  Despesas({ required this.descricao, required this.valor, required this.area, required this.data});

  Map<String, Object?> toMap(){
    return {'descricao': descricao, 'valor': valor, 'area': area, 'data': data};
  }
  @override
  String toString(){
    return 'Despesas {descricao: $descricao, valor: $valor, area: $area, data: $data}';
  }

}