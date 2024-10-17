import 'package:cloud_firestore/cloud_firestore.dart';

class Dadosprofissional {

Future<List<Map<String, dynamic>>> fetchIdosos(String emailEntrada) async {
  try {
    // Primeira busca na coleção 'servico' pelo campo 'profissional' (com o email fornecido)
    QuerySnapshot servicoSnapshot = await FirebaseFirestore.instance
        .collection('servico')
        .where('profissional', isEqualTo: emailEntrada)
        .get();

    // Verificando se há documentos retornados da coleção 'servico'
    if (servicoSnapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> userDataList = [];

      // Iterar sobre cada documento da coleção 'servico'
      for (var servicoDoc in servicoSnapshot.docs) {
        // Pegando o UID do idoso (que está no campo 'idoso') e a data dentro dos documentos da coleção 'servico'
        String uidIdoso = servicoDoc.get('idoso');
        String dataServicoString = servicoDoc.get('data'); // Pega o campo 'data' (string)

        // Convertendo a string 'data' para o formato 'yyyy-MM-dd'
        DateTime dataServico = DateTime.parse(dataServicoString);
         String dataFormatada = "${dataServico.day.toString().padLeft(2, '0')}/${dataServico.month.toString().padLeft(2, '0')}/${dataServico.year}";

        // Fazendo a segunda busca na coleção 'user' pelo campo 'uid' usando o UID encontrado
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .where(FieldPath.documentId, isEqualTo: uidIdoso) // Usando o UID encontrado para buscar o documento pelo ID
            .get();

        // Adicionando os dados retornados da coleção 'user' junto com a 'data' da coleção 'servico'
        for (var userDoc in userSnapshot.docs) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          userData['data_servico'] = dataFormatada; // Adiciona o campo 'data' formatada
          userDataList.add(userData); // Adiciona à lista final
        }
      }

      // Retornando todos os dados encontrados na coleção 'user' juntamente com o campo 'data' da coleção 'servico'
      return userDataList;
    } else {
      print('Nenhum documento encontrado na coleção "servico" para o email $emailEntrada');
      return [];
    }
  } catch (e) {
    print("Erro ao buscar documentos: $e");
    return [];
  }
}

}