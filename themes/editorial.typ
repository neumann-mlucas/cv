#import "/lib.typ": *

#let accent = rgb("#3D5A80")
#let gutter = 2.4cm
#set document(title: basics.name + " — CV", author: basics.name)
#set page(paper: "a4", margin: (x: 1.4cm, y: 1.3cm))
#set text(font: "Inter", size: 9pt, lang: lang)
#set par(justify: false, leading: 0.6em, spacing: 0.7em)
#set list(indent: 0em, spacing: 0.5em, marker: text(fill: accent)[–])
#show link: set text(fill: accent)

// Section titles and dates sit in the left gutter; body is padded right of it.
#let section(title) = block(above: 1.3em, below: 0.6em,
  move(dx: -gutter, text(font: "Fraunces 72pt", size: 13pt, weight: "semibold", title)))
#let head(title, subtitle, dates) = block(above: 0.85em, below: 0.35em)[
  #place(dx: -gutter, text(size: 8pt, fill: accent, dates))
  *#title* #h(0.3em) #text(fill: luma(100), subtitle)
]

#block(below: 1em)[
  #text(font: "Fraunces 72pt", size: 30pt, weight: "semibold", basics.name) \
  #text(size: 11pt, fill: accent, t(basics.headline)) \
  #text(size: 8pt, fill: luma(90), contact().map(link-or-text).join([ · ]))
]

#pad(left: gutter)[
  #section(L("summary"))
  #summary
  #experience(section, head)
  #education(section, head)
  #skills(section)
  #projects-block(section)
]
