class CheckCondition {
  String? checkNull(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong isi kolom ini.';
    }
    return null; // Return null when valid
  }
}