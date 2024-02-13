const escapeCharacters = {
  "&quot;": '\\"',
  "&amp;": "&",
  "&lt;": "<",
  "&gt;": ">",
  "&#145;": "\\'"
};

String replaceEntity(String text) {
  return text.replaceAllMapped(
    RegExp('&[A-Za-z]+;'),
    (match) {
      if (escapeCharacters.containsKey(match.group(0))) {
        return escapeCharacters[match.group(0)]!;
      }
      return match.group(0)!;
    },
  );
}
