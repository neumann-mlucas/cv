#import "/lib.typ": *

#let accent = rgb("#2E7D5B")
#let mono = "JetBrains Mono"
#set document(title: basics.name + " — CV", author: basics.name)
#set page(paper: "a4", margin: (x: 1.5cm, y: 1.2cm))
#set text(font: "Inter", size: 9pt, lang: lang)
#set par(justify: true, leading: 0.55em, spacing: 0.65em)
#set list(indent: 0.2em, spacing: 0.5em, marker: text(font: mono, fill: accent)[›])
#show link: set text(fill: accent)

// String concatenation, not markup: "//" in markup would start a comment.
#let section(title) = block(above: 1.1em, below: 0.5em,
  text(font: mono, size: 10pt, weight: "bold", fill: accent, "// " + lower(title)))
#let head(title, subtitle, dates) = block(above: 0.8em, below: 0.35em, grid(
  columns: (1fr, auto),
  [*#title* #text(fill: luma(110))[·] #subtitle],
  text(font: mono, size: 8pt, fill: accent, dates),
))

#block(below: 0.4em)[
  #text(font: mono, size: 20pt, weight: "bold", basics.name) \
  #text(size: 10.5pt, fill: accent, t(basics.headline)) \
  #text(font: mono, size: 7.8pt, contact().map(link-or-text).join([ | ]))
]

#section(L("summary"))
#summary
#experience(section, head)
#education(section, head)
#[
  #set text(font: mono, size: 8pt)
  #skills(section)
]
#projects-block(section)
