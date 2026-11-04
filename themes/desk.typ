#import "/lib.typ": *

#let accent = rgb("#C77C02")
#let ink = rgb("#2B2B2B")
#let mono = "IBM Plex Mono"
#set document(title: basics.name + " — CV", author: basics.name)
#set page(paper: "a4", margin: (x: 1.4cm, y: 1.1cm))
#set text(font: "IBM Plex Sans", size: 8.8pt, fill: ink, lang: lang)
#set par(justify: true, leading: 0.5em, spacing: 0.6em)
#set list(indent: 0.2em, spacing: 0.45em, marker: text(fill: accent, size: 0.7em)[■])
#show link: set text(fill: ink)

#let section(title) = block(
  above: 1em, below: 0.5em, width: 100%,
  stroke: (bottom: 0.5pt + luma(180)), inset: (bottom: 3pt),
)[
  #box(fill: accent, width: 3pt, height: 0.8em) #h(4pt)
  #text(size: 8.5pt, weight: "bold", tracking: 0.4pt, upper(title))
]
#let head(title, subtitle, dates) = block(above: 0.75em, below: 0.35em, grid(
  columns: (1fr, auto),
  [*#title* #h(0.4em) #text(fill: luma(90), subtitle)],
  text(font: mono, size: 8pt, fill: luma(90), dates),
))

#grid(
  columns: (1fr, auto), align: (left + bottom, right + bottom),
  [
    #text(size: 22pt, weight: "bold", basics.name) \
    #text(size: 10.5pt, weight: "medium", fill: accent, t(basics.headline))
  ],
  text(size: 8pt, contact().map(link-or-text).join(linebreak())),
)

#block(above: 0.8em, width: 100%, fill: rgb("#1E1E1E"), inset: (x: 10pt, y: 7pt), radius: 2pt,
  grid(
    columns: basics.kpis.len() * (1fr,),
    ..basics.kpis.map(k => [
      #text(font: mono, size: 13pt, weight: "bold", fill: accent, k.value) \
      #text(size: 7.5pt, fill: luma(220), t(k.label))
    ]),
  ),
)

#section(L("summary"))
#summary
#experience(section, head)
#education(section, head)
#skills(section)
#projects-block(section)
