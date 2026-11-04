#import "/lib.typ": *

#let accent = rgb("#1F3A5F")
#set document(title: basics.name + " — CV", author: basics.name)
#set page(paper: "a4", margin: (x: 1.6cm, y: 1.3cm))
#set text(font: "Source Serif 4", size: 9.5pt, lang: lang)
#set par(justify: true, leading: 0.52em, spacing: 0.65em)
#set list(indent: 0.3em, spacing: 0.5em, marker: text(fill: accent)[•])
#show link: set text(fill: accent)

#let section(title) = block(
  above: 1.1em, below: 0.55em, width: 100%,
  stroke: (bottom: 0.6pt + accent), inset: (bottom: 2pt),
  text(size: 10.5pt, weight: "bold", fill: accent, smallcaps(title)),
)
#let head(title, subtitle, dates) = block(above: 0.8em, below: 0.4em, grid(
  columns: (1fr, auto),
  [*#title* — #subtitle], text(fill: luma(90), dates),
))

#align(center)[
  #text(size: 22pt, weight: "bold", basics.name) \
  #text(size: 11pt, fill: accent, t(basics.headline)) \
  #text(size: 8.5pt, contact().map(link-or-text).join([ · ]))
]

#section(L("summary"))
#summary
#experience(section, head)
#education(section, head)
#skills(section)
#projects-block(section)
