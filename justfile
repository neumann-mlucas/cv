set shell := ["bash", "-euo", "pipefail", "-c"]

theme := "classic"
themes := "classic sidebar desk terminal editorial"
tc := "typst compile --root . --font-path fonts --ignore-system-fonts"

# Download OFL fonts into fonts/ (run once; output is committed)
fonts:
    #!/usr/bin/env bash
    set -euo pipefail
    tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
    for u in \
      https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip \
      https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip \
      https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip \
      https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip \
      https://github.com/adobe-fonts/source-serif/releases/download/4.005R/source-serif-4.005_Desktop.zip \
      https://github.com/undercasetype/Fraunces/releases/download/1.000/UnderCaseType_Fraunces_1.000.zip; do
      curl -fsSL "$u" -o "$tmp/f.zip"; unzip -qo "$tmp/f.zip" -d "$tmp/x"
    done
    mkdir -p fonts
    fd -t f --regex '^((Inter|IBMPlexSans|IBMPlexMono|SourceSerif4|Fraunces72pt)-(Regular|Italic|It|Medium|SemiBold|Semibold|Bold|BoldItalic|BoldIt)\.otf|JetBrainsMono-(Regular|Medium|Bold)\.ttf)$' "$tmp/x" -x cp {} fonts/
    typst fonts --font-path fonts --ignore-system-fonts

# Compile one theme/lang/focus to a given PDF path
build t lang focus out:
    mkdir -p "$(dirname {{out}})"
    {{tc}} --input lang={{lang}} --input focus={{focus}} themes/{{t}}.typ {{out}}

# Fail unless every given PDF has exactly one page
check files="pdf/*.pdf":
    for f in {{files}}; do n=$(pdfinfo "$f" | grep -oP '^Pages:\s+\K\d+'); [ "$n" = 1 ] || { echo "$f: $n pages"; exit 1; }; done; echo "all 1 page"

# Run lib/data assertions for every lang × focus
test:
    mkdir -p out
    for l in en pt; do for f in fin tech; do {{tc}} --input lang=$l --input focus=$f tests/lib.typ out/test.pdf; done; done; echo "tests ok"
