#import "/lib.typ": *

#let accent = rgb("#7A1E2C")
#set document(title: basics.name + " — CV", author: basics.name, date: none)
#set page(paper: "a4", margin: (x: 1.4cm, y: 1.2cm))
#set text(font: "Inter", size: if lang == "pt" { 9.7pt } else { 10.1pt }, lang: lang, hyphenate: false)
#set par(justify: true, leading: 0.6em, spacing: 0.7em)
#set list(indent: 0.2em, spacing: 0.6em, marker: text(fill: accent)[▸])
#show link: set text(fill: accent)

#let section(title) = block(above: 1.25em, below: 0.55em,
  text(font: "Source Serif 4", size: 13pt, weight: "bold", fill: accent, title))
#let head(title, subtitle, dates) = block(above: 1em, below: 0.45em)[
  *#title* #h(1fr) #text(size: 8.5pt, fill: luma(100), dates) \
  #text(fill: accent, subtitle)
]
#let side-head(title, subtitle, dates) = block(above: 0.6em, below: 0.3em)[
  *#title* \ #subtitle \ #text(size: 8pt, fill: luma(100), dates)
]

#block(width: 100%, inset: (bottom: 0.6em), stroke: (bottom: 1.5pt + accent))[
  #set par(justify: false)
  #text(font: "Source Serif 4", size: 26pt, weight: "bold", basics.name) \
  #text(size: 12pt, fill: accent, t(basics.headline)) \
  #text(size: 9pt, contact().map(c => box(link-or-text(c))).join([ · ]))
]

// Main column first in source order (ATS reading order), sidebar second.
#grid(
  columns: (1fr, 5.6cm), column-gutter: 0.8cm,
  fill: (none, luma(247)), inset: (x, y) => if x == 1 { 8pt } else { 0pt },
  [
    #section(L("summary"))
    #summary
    #experience(section, head)
  ],
  [
    #set text(size: 9.5pt)
    #set par(justify: false)
    #skills(section, stacked: true)
    #education(section, side-head)
    #projects-block(section, stacked: true)
  ],
)
