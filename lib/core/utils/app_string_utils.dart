class AppStringUtils {
  static String maskEmail(String email) {
    if (email.isEmpty || !email.contains('@')) return email;

    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];

    if (name.length <= 3) {
      return '${name[0]}***@$domain';
    }

    return '${name.substring(0, 3)}***@$domain';
  }
}
