/// Error con un mensaje listo para mostrar. Los data sources traducen a este tipo
/// las excepciones de Supabase, así ninguna capa de arriba conoce el SDK.
class AuthFailure implements Exception {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => message;
}
