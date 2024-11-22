import 'package:cloud_firestore/cloud_firestore.dart';

class Dadosprofissional {

  Future<List<Map<String, dynamic>>> fetchIdosos(String emailEntrada) async {
    try {
      QuerySnapshot servicoSnapshot = await FirebaseFirestore.instance
          .collection('servico')
          .where('profissional', isEqualTo: emailEntrada)
          .get();

      if (servicoSnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> userDataList = [];

        for (var servicoDoc in servicoSnapshot.docs) {
          String uidIdoso = servicoDoc.get('idoso');
          String dataServicoString = servicoDoc.get('data');
          String mensagem = servicoDoc.get('mensagem');

          DateTime dataServico = DateTime.parse(dataServicoString);
          String dataFormatada = "${dataServico.day.toString().padLeft(2, '0')}/${dataServico.month.toString().padLeft(2, '0')}/${dataServico.year}";

          QuerySnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('user')
              .where(FieldPath.documentId, isEqualTo: uidIdoso)
              .get();

          for (var userDoc in userSnapshot.docs) {
            Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
            userData['data_servico'] = dataFormatada;
            userData['mensagem'] = mensagem;
            userDataList.add(userData);
          }
        }
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
