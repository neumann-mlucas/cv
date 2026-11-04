#import "/lib.typ": *

// t(): plain strings pass through, dicts resolve to current lang
#assert.eq(t("x"), "x")
#assert.eq(t((en: "a", pt: "b")), if lang == "en" { "a" } else { "b" })

// keep(): PDF keeps only core items tagged with current focus; web keeps all
#let other = if focus == "fin" { "tech" } else { "fin" }
#assert(keep((level: "core", tags: (focus,))))
#assert(keep((tags: (focus,))))
#assert(not keep((level: "core", tags: (other,))))
#assert(not keep((level: "detail", tags: ("fin", "tech"))))
#assert(keep((level: "detail", tags: (other,)), web: true))

// years()
#assert.eq(years((start: 2023, end: 2025)), "2023–2025")
#assert.eq(years((start: 2025, end: none)), "2025–" + L("present"))

// filtering on real data
#assert.eq(work().len(), 3)
#assert(work().all(w => w.bullets.all(b => keep(b))))
#assert(work(web: true).at(0).bullets.len() > work().at(0).bullets.len())

// contact: phone only in pt
#assert.eq(contact().any(c => c.at(0) == basics.phone), lang == "pt")

// data integrity: no half-translated field anywhere
#let check(v, path) = {
  if type(v) == dictionary {
    if "en" in v or "pt" in v {
      assert("en" in v and "pt" in v, message: "half-translated at " + path)
    }
    for (k, x) in v { check(x, path + "." + k) }
  } else if type(v) == array {
    for (i, x) in v.enumerate() { check(x, path + "[" + str(i) + "]") }
  }
}
#check(data, "data")

// every markup field evaluates (catches stray # $ @ _ etc.)
#for w in work(web: true) { for b in w.bullets { m(b.text) } }
#for p in projects(web: true) { m(p.text) }
#summary

ok
