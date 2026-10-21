/// Los datos que guardamos en la tabla `profiles`. Su `id` es el UID de la cuenta.
class Profile {
  final String id;
  final String username;
  final String fullName;

  const Profile({
    required this.id,
    required this.username,
    required this.fullName,
  });
}
