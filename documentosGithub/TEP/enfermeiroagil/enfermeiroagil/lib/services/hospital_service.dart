import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hospital.dart';

class HospitalService {
  final SupabaseClient _supabase;

  HospitalService(this._supabase);

  Future<List<Hospital>> listarHospitais() async {
    final rows = await _supabase
        .from('hospitais')
        .select()
        .order('nome', ascending: true);

    return rows.map<Hospital>((r) => Hospital.fromMap(r)).toList();
  }

  Future<Hospital> criarHospital({
    required String nome,
    String? cidade,
    String? estado,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final data = await _supabase
        .from('hospitais')
        .insert({
          'nome': nome.trim(),
          'cidade': cidade?.trim(),
          'estado': estado?.trim(),
          'criado_por': user.id,
        })
        .select()
        .single();

    return Hospital.fromMap(data);
  }
}