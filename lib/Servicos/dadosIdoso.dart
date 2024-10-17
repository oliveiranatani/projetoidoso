import 'package:cloud_firestore/cloud_firestore.dart';


class DadosIdoso {

  Future<String?> fetchNomeUsuario(String uid) async {
    try {
      print("Buscando nome para o UID: $uid"); // Adicione isso
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (userDoc.exists) {
        print("Documento encontrado: ${userDoc.data()}"); // Adicione isso
        return userDoc.get('nome');
      } else {
        print("Documento não encontrado para o UID: $uid"); // Adicione isso
      }
    } catch (e) {
      print("Erro ao buscar nome do usuário: $e");
    }
    return null; // Retorna null se não encontrar ou ocorrer erro
  }

  Future<void> solicitarContato(String profissionalId, String? idosoId) async {
    final String dataAtual = DateTime.now().toIso8601String(); 
    if (idosoId != null) {
      try {
        await FirebaseFirestore.instance.collection('servico').add({
          'idoso': idosoId,
          'profissional': profissionalId,
          'data': dataAtual,
        });
        print("Solicitação de contato registrada com sucesso.");
      } catch (e) {
        print("Erro ao registrar solicitação de contato: $e");
      }
    } else {
      print("Usuário não está logado.");
    }
  }

}