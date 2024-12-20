class NominatimException implements Exception {
  final String message;
  final String? code;

  NominatimException(this.message, {this.code});

  @override
  String toString() =>
      'NominatimException: $message${code != null ? ' (Code: $code)' : ''}';
}
