import 'package:moviles_auth/features/auth/domain/entities/auth_user.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles_auth/features/auth/domain/repository/profile_repository.dart';

class SignInUseCase {
  final AuthRepository _auth;
  final ProfileRepository _profiles;

  SignInUseCase(this._auth, this._profiles);

  /// También son dos pasos: iniciar sesión y, con el `id` de la cuenta, traer el perfil.
  Future<({AuthUser user, Profile profile})> call({
    required String email,
    required String password,
  }) async {
    final user = await _auth.signIn(email: email, password: password);
    final profile = await _profiles.getProfile(user.id);
    return (user: user, profile: profile);
  }
}
