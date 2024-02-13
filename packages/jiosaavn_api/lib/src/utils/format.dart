const escapeCharacters = {
  "&quot;": '\\"',
  "&amp;": "&",
  "&lt;": "<",
  "&gt;": ">",
  "&#039;": "'",
};

String replaceEntity(String text) {
  return text.replaceAllMapped(
    RegExp('&(#[0-9]+|[a-zA-Z0-9]+);'),
    (match) {
      if (escapeCharacters.containsKey(match.group(0))) {
        return escapeCharacters[match.group(0)]!;
      }
      return match.group(0)!;
    },
  );
}
