import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import 'package:moviles_auth/features/auth/domain/entities/auth_user.dart';
import 'package:moviles_auth/features/auth/domain/errors/auth_failure.dart';

/// El único archivo que usa el SDK de Auth.
class SupabaseAuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return _toAuthUser(response.user);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return _toAuthUser(response.user);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  AuthUser _toAuthUser(User? user) {
    // `response.user` puede ser null: se valida antes de usarlo.
    if (user == null) {
      throw const AuthFailure('Supabase no devolvió el usuario');
    }
    return AuthUser(id: user.id, email: user.email ?? '');
  }
}
