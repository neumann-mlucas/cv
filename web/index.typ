#import "/lib.typ": *

#let el = html.elem
#let pdf-url(l, f) = "https://github.com/neumann-mlucas/cv/raw/main/pdf/cv-" + l + "-" + f + ".pdf"
#let tags-of(x) = x.at("tags", default: ("fin", "tech")).join(" ")
#let level-of(x) = x.at("level", default: "core")
#let li-for(b) = el("li", attrs: (data-tags: tags-of(b)))[#m(b.text)]
#let section(title) = el("h2")[#title]
#let head(title, subtitle, dates) = el("h3")[#title · #subtitle #el("span", attrs: (class: "dates"))[#dates]]

#set document(title: basics.name + " — CV")
#set text(lang: lang)

#el("link", attrs: (rel: "stylesheet", href: "https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Source+Serif+4:wght@600;700&display=swap"))
#el("link", attrs: (rel: "stylesheet", href: "style.css"))

#el("header")[
  #el("h1")[#basics.name]
  #el("p", attrs: (class: "headline"))[#t(basics.headline)]
  #el("p", attrs: (class: "contact"))[#contact(web: true).map(link-or-text).join([ · ])]
  #el("p", attrs: (class: "meta"))[
    #if lang == "en" { link("pt/")[Português] } else { link("../")[English] }
    #for l in ("en", "pt") [
      · PDF #upper(l):
      #link(pdf-url(l, "fin"))[#t((en: "finance", pt: "finanças"))] /
      #link(pdf-url(l, "tech"))[#t((en: "engineering", pt: "engenharia"))]
    ]
  ]
]

// CSS-only focus toggle: radios before content, filtered via :has() in style.css
#el("nav", attrs: (class: "focus"))[
  #for (id, label) in (
    ("f-all", (en: "All", pt: "Tudo")),
    ("f-fin", (en: "Finance", pt: "Finanças")),
    ("f-tech", (en: "Engineering", pt: "Engenharia")),
  ) {
    let attrs = (type: "radio", name: "focus", id: id)
    if id == "f-all" { attrs.insert("checked", "checked") }
    el("input", attrs: attrs)
    el("label", attrs: ("for": id))[#t(label)]
  }
]

#el("main")[
  #section(L("summary"))
  #el("p", attrs: (data-tags: "fin"))[#m(basics.summary.fin)]
  #el("p", attrs: (data-tags: "tech"))[#m(basics.summary.tech)]

  #section(L("experience"))
  #for w in work(web: true) {
    el("article")[
      #head([#w.org], t(w.role), years(w))
      #if "note" in w { el("p", attrs: (class: "note"))[#t(w.note)] }
      #el("ul")[#for b in w.bullets.filter(b => level-of(b) == "core") { li-for(b) }]
      #let more = w.bullets.filter(b => level-of(b) == "detail")
      #if more.len() > 0 {
        el("details")[
          #el("summary")[#t((en: "More detail", pt: "Mais detalhes"))]
          #el("ul")[#for b in more { li-for(b) }]
        ]
      }
    ]
  }

  #let ptags = projects(web: true).map(tags-of).join(" ").split(" ").dedup().join(" ")
  #el("section", attrs: (data-tags: ptags))[#section(L("projects"))
  #el("ul", attrs: (class: "projects"))[
    #for p in projects(web: true) {
      el("li", attrs: (data-tags: tags-of(p)))[#project-name(p, p.name) #el("span", attrs: (class: "lang"))[#p.lang] — #m(p.text)]
    }
  ]]

  #education(section, head)
  #skills(section)
]

#el("footer")[
  #t((en: "Generated with Typst from", pt: "Gerado com Typst a partir de"))
  #link("https://github.com/neumann-mlucas/cv")[data/cv.yaml]
]
