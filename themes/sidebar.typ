#import "/lib.typ": *

#let accent = rgb("#7A1E2C")
#set document(title: basics.name + " — CV", author: basics.name, date: none)
#set page(paper: "a4", margin: (x: 1.4cm, y: 1.2cm))
#set text(font: "Inter", size: if lang == "pt" { 9.7pt } else { 10.1pt }, lang: lang, hyphenate: false)
#set par(justify: true, leading: 0.6em, spacing: 0.7em,
  justification-limits: (tracking: (min: -0.012em, max: 0.025em)))
#set list(indent: 0.2em, spacing: 0.75em, marker: text(fill: accent)[▸])
#show link: set text(fill: accent)

#let section(title) = block(above: 1.5em, below: 0.6em, grid(
  columns: (auto, 1fr), column-gutter: 0.5em, align: horizon,
  text(font: "Source Serif 4", size: 13pt, weight: "bold", fill: accent, title),
  line(length: 100%, stroke: 0.5pt + accent.lighten(55%)),
))
#let dates-text(d) = text(size: 8.5pt, fill: luma(100), number-width: "tabular", d)
#let head(title, subtitle, dates) = block(above: 1.6em, below: 0.5em)[
  #set par(justify: false)
  *#title* #text(fill: luma(150))[·] #text(fill: accent, subtitle) #h(1fr) #dates-text(dates)
]
#let side-head(title, subtitle, dates) = block(above: 0.6em, below: 0.3em)[
  *#title* \ #subtitle #h(1fr) #box(text(size: 8pt, fill: luma(110), number-width: "tabular", dates))
]

#block(width: 100%, inset: (bottom: 0.7em), below: 1em, stroke: (bottom: 1.5pt + accent))[
  #set par(justify: false)
  #text(font: "Source Serif 4", size: 26pt, weight: "bold", basics.name) \
  #text(size: 12pt, fill: accent, t(basics.headline)) \
  #let cs = contact()
  #let direct(c) = c.at(1) == none or c.at(1).starts-with("tel:") or c.at(1).starts-with("mailto:")
  #set text(size: 9pt)
  #cs.filter(direct).map(link-or-text).join([ · ]) \
  #cs.filter(c => not direct(c)).map(link-or-text).join([ · ])
]

// Main column first in source order (ATS reading order), sidebar second.
#grid(
  columns: (1fr, 5.6cm), column-gutter: 0.8cm,
  fill: (none, luma(249)), stroke: (x, y) => if x == 1 { (left: 1.2pt + accent.lighten(40%)) }, inset: (x, y) => if x == 1 { 8pt } else { (top: 8pt) },
  [
    #section(L("summary"))
    #summary
    #experience(section, head)
  ],
  [
    #set text(size: 9.5pt)
    #set par(justify: false)
    #set text(fill: luma(85))
    #show strong: set text(fill: black)
    #skills(section, stacked: true)
    #education(section, side-head)
    #projects-block(section, stacked: true)
  ],
)
