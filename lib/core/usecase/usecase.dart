/// Clase base abstracta para casos de uso
///
/// [Output] - Tipo de retorno del caso de uso
/// [Params] - Parámetros requeridos para ejecutar el caso de uso
abstract class UseCase<Output, Params> {
  Future<Output> call(Params params);
}

/// Clase base para casos de uso que no requieren parámetros
abstract class UseCaseNoParams<Output> {
  Future<Output> call();
}
