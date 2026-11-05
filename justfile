set shell := ["bash", "-euo", "pipefail", "-c"]

theme := "sidebar"
themes := "sidebar"
tc := "typst compile --root . --font-path fonts --ignore-system-fonts"

# Download OFL fonts into fonts/ (run once; output is committed)
fonts:
    #!/usr/bin/env bash
    set -euo pipefail
    tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
    for u in \
      https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip \
      https://github.com/adobe-fonts/source-serif/releases/download/4.005R/source-serif-4.005_Desktop.zip; do
      curl -fsSL "$u" -o "$tmp/f.zip"; unzip -qo "$tmp/f.zip" -d "$tmp/x"
    done
    mkdir -p fonts
    fd -t f --regex '^((Inter|SourceSerif4)-(Regular|Italic|It|Medium|SemiBold|Semibold|Bold|BoldItalic|BoldIt)\.otf)$' "$tmp/x" -x cp {} fonts/
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

# 5 themes × en × {fin,tech} with PNG previews, for choosing a theme
compare:
    for t in {{themes}}; do for f in fin tech; do just build $t en $f out/compare/$t-en-$f.pdf; pdftoppm -png -r 80 -singlefile out/compare/$t-en-$f.pdf out/compare/$t-en-$f; done; done
    just check "out/compare/*.pdf"

# Final PDFs with the chosen theme
all:
    for l in en pt; do for f in fin tech; do just build {{theme}} $l $f pdf/cv-$l-$f.pdf; done; done
    just check

# Build the static site into out/site
web:
    mkdir -p out/site/pt
    {{tc}} --features html --format html --input lang=en web/index.typ out/site/index.html
    {{tc}} --features html --format html --input lang=pt web/index.typ out/site/pt/index.html
    cp web/style.css out/site/style.css
    cp web/style.css out/site/pt/style.css
