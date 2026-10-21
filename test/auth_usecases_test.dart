import 'package:flutter_test/flutter_test.dart';

import 'package:moviles_auth/features/auth/domain/entities/auth_user.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/auth/domain/errors/auth_failure.dart';
import 'package:moviles_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles_auth/features/auth/domain/repository/profile_repository.dart';
import 'package:moviles_auth/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:moviles_auth/features/auth/domain/usecases/sign_up_usecase.dart';

class _FakeAuth implements AuthRepository {
  bool signedOut = false;

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async => AuthUser(id: 'uid-1', email: email);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async => AuthUser(id: 'uid-1', email: email);

  @override
  Future<void> signOut() async => signedOut = true;
}

class _FakeProfiles implements ProfileRepository {
  final bool failOnCreate;
  final saved = <Profile>[];

  _FakeProfiles({this.failOnCreate = false});

  @override
  Future<void> createProfile(Profile profile) async {
    if (failOnCreate) {
      throw const AuthFailure('permission denied for table profiles');
    }
    saved.add(profile);
  }

  @override
  Future<Profile> getProfile(String id) async =>
      Profile(id: id, username: 'ana', fullName: 'Ana Gómez');
}

void main() {
  test(
    'SignUpUseCase crea la cuenta y guarda el perfil con el id de Auth',
    () async {
      final profiles = _FakeProfiles();
      final signUp = SignUpUseCase(_FakeAuth(), profiles);

      final profile = await signUp(
        username: 'ana',
        fullName: 'Ana Gómez',
        email: 'ana@icesi.edu.co',
        password: '123456',
      );

      expect(profile.id, 'uid-1');
      expect(profiles.saved.single.username, 'ana');
    },
  );

  test(
    'SignUpUseCase cierra la sesión si no se pudo guardar el perfil',
    () async {
      final auth = _FakeAuth();
      final signUp = SignUpUseCase(auth, _FakeProfiles(failOnCreate: true));

      await expectLater(
        signUp(
          username: 'ana',
          fullName: 'Ana Gómez',
          email: 'ana@icesi.edu.co',
          password: '123456',
        ),
        throwsA(isA<AuthFailure>()),
      );
      expect(auth.signedOut, isTrue);
    },
  );

  test('SignInUseCase devuelve la cuenta y su perfil', () async {
    final signIn = SignInUseCase(_FakeAuth(), _FakeProfiles());

    final result = await signIn(email: 'ana@icesi.edu.co', password: '123456');

    expect(result.user.email, 'ana@icesi.edu.co');
    expect(result.profile.fullName, 'Ana Gómez');
  });
}
