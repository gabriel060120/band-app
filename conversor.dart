import 'dart:io';

final RegExp sectionRegex = RegExp(r'^\[(.+?)\]$');

final RegExp chordTokenRegex = RegExp(
  r'^[A-G](#|b)?'
  r'('
  r'm|M|maj|min|dim|aug|sus|add|º|°|\+|-'
  r')?'
  r'[0-9]*'
  r'(M|maj)?'
  r'(\([^)]+\))*'
  r'(/[A-G](#|b)?)?$',
);

bool isChordToken(String token) {
  return chordTokenRegex.hasMatch(token);
}

bool isChordLine(String line) {
  var stripped = line.trim();

  if (stripped.isEmpty) {
    return false;
  }

  // Linha instrumental: ( Em7  C2  G  D )
  // Mas evita confundir comentários como: (Quebrando em nome de Jesus)
  if (stripped.startsWith('(') && stripped.endsWith(')')) {
    stripped = stripped.substring(1, stripped.length - 1).trim();

    if (stripped.isEmpty) {
      return false;
    }
  }

  final tokens = stripped.split(RegExp(r'\s+'));

  return tokens.every(isChordToken);
}

String convertPair(String chordLine, String lyricLine) {
  final matches = RegExp(r'\S+').allMatches(chordLine);

  final chords = matches.map((match) {
    return {'pos': match.start, 'chord': match.group(0)!};
  }).toList();

  if (chords.isEmpty) {
    return lyricLine;
  }

  final buffer = StringBuffer();
  int lastIndex = 0;

  for (final item in chords) {
    final int pos = item['pos'] as int;
    final String chord = item['chord'] as String;

    final int lyricPos = pos > lyricLine.length ? lyricLine.length : pos;

    if (lyricPos >= lastIndex) {
      buffer.write(lyricLine.substring(lastIndex, lyricPos));
    }

    buffer.write('[$chord]');
    lastIndex = lyricPos;
  }

  if (lastIndex < lyricLine.length) {
    buffer.write(lyricLine.substring(lastIndex));
  }

  return buffer.toString().trimRight();
}

String convertChordLineOnly(String line) {
  var stripped = line.trim();

  if (stripped.startsWith('(') && stripped.endsWith(')')) {
    stripped = stripped.substring(1, stripped.length - 1).trim();
  }

  if (stripped.isEmpty) {
    return '';
  }

  final chords = stripped.split(RegExp(r'\s+'));
  return chords.map((chord) => '[$chord]').join(' ');
}

String convertChart(String text) {
  final lines = text.split(RegExp(r'\r?\n'));
  final output = <String>[];

  int i = 0;

  while (i < lines.length) {
    final line = lines[i];
    final stripped = line.trim();

    final sectionMatch = sectionRegex.firstMatch(stripped);

    if (sectionMatch != null) {
      output.add('{section: ${sectionMatch.group(1)}}');
      i++;
      continue;
    }

    if (isChordLine(line)) {
      final bool hasNextLine = i + 1 < lines.length;
      final bool nextLineIsLyric =
          hasNextLine &&
          lines[i + 1].trim().isNotEmpty &&
          !isChordLine(lines[i + 1]);

      if (nextLineIsLyric) {
        output.add(convertPair(line, lines[i + 1]));
        i += 2;
      } else {
        output.add(convertChordLineOnly(line));
        i++;
      }

      continue;
    }

    output.add(line.trimRight());
    i++;
  }

  return output.join('\n');
}

Future<void> main() async {
  final inputFile = File('cifra.txt');
  final outputFile = File('cifra_chordpro.txt');

  if (!await inputFile.exists()) {
    stderr.writeln('Erro: arquivo cifra.txt não encontrado.');
    exit(1);
  }

  final original = await inputFile.readAsString();
  final converted = convertChart(original);

  await outputFile.writeAsString(converted);

  print('Cifra convertida salva em cifra_chordpro.txt');
}
