#let data = yaml("/data/cv.yaml")
#let basics = data.basics
#let lang = sys.inputs.at("lang", default: "en")
#let focus = sys.inputs.at("focus", default: "fin")
#assert(lang in ("en", "pt"), message: "lang must be en or pt, got " + lang)
#assert(focus in ("fin", "tech"), message: "focus must be fin or tech, got " + focus)

// Text field: plain string or (en: .., pt: ..).
#let t(v) = if type(v) == dictionary {
  assert(lang in v, message: "missing '" + lang + "' in " + repr(v))
  v.at(lang)
} else { v }

// Text field rendered as Typst markup (allows *bold*).
#let m(v) = eval(t(v), mode: "markup")

#let labels = (
  summary: (en: "Summary", pt: "Resumo"),
  experience: (en: "Experience", pt: "Experiência"),
  education: (en: "Education", pt: "Formação"),
  skills: (en: "Skills", pt: "Competências"),
  projects: (en: "Projects", pt: "Projetos"),
  languages: (en: "Languages", pt: "Idiomas"),
  present: (en: "present", pt: "atual"),
)
#let L(key) = t(labels.at(key))

// PDF keeps core items tagged with the current focus; web keeps everything.
#let keep(item, web: false) = web or (
  item.at("level", default: "core") == "core"
    and focus in item.at("tags", default: ("fin", "tech"))
)

#let years(e) = str(e.start) + "–" + if e.at("end", default: none) == none { L("present") } else { str(e.end) }

#let work(web: false) = data.work.map(w => w + (bullets: w.bullets.filter(b => keep(b, web: web))))
#let projects(web: false) = data.projects.filter(p => keep(p, web: web))
#let summary = m(basics.summary.at(focus))

#let contact(web: false) = {
  let b = basics
  let items = ((t(b.location), none),)
  if lang == "pt" and not web { items.push((b.phone, "tel:" + b.phone.replace(" ", "").replace("-", ""))) }
  items.push((b.email, "mailto:" + b.email))
  items.push(("linkedin.com/in/" + b.linkedin, "https://linkedin.com/in/" + b.linkedin))
  items.push(("github.com/" + b.github, "https://github.com/" + b.github))
  items.push((b.web, "https://" + b.web))
  items
}
#let link-or-text(c) = if c.at(1) == none { c.at(0) } else { link(c.at(1), c.at(0)) }

// ---- Section blocks. Themes pass styling functions:
// section(title: str) -> content
// head(title: content, subtitle: str, dates: str) -> content

#let experience(section, head) = {
  section(L("experience"))
  for w in work() {
    head([#w.org], t(w.role), years(w))
    if "note" in w { text(style: "italic", size: 0.92em, t(w.note)); parbreak() }
    list(..w.bullets.map(b => m(b.text)))
  }
}

#let education(section, head) = {
  section(L("education"))
  for e in data.education {
    head([#t(e.org)], t(e.degree), years(e))
    m(e.text)
  }
}

#let skills(section, stacked: false) = {
  section(L("skills"))
  let rows = data.skills.map(s => (t(s.label), t(s.items)))
  rows.push((L("languages"), data.languages.map(l => t(l.name) + " (" + t(l.level) + ")").join(", ")))
  for (k, v) in rows {
    if stacked { block(spacing: 0.75em)[*#k* \ #v] } else { [*#k:* #v]; linebreak() }
  }
}

// Project name, linked when it has a public url.
#let project-name(p, body) = if "url" in p { link(p.url, body) } else { body }

#let projects-block(section, stacked: false) = {
  let ps = projects()
  if ps.len() > 0 {
    section(L("projects"))
    for p in ps {
      if stacked { block(spacing: 0.75em)[#project-name(p, strong[#p.name]) (#p.lang) \ #m(p.text)] }
      else { [#project-name(p, strong[#p.name]) (#p.lang) — #m(p.text)]; linebreak() }
    }
  }
}
