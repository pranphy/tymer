// vim: ft=typst sts=4 ts=4 et

#let section = state("section", none)
#let slide-ct = counter("slide-ct")
#let global-theme = state("global-theme", none)
#let backup-st = state("backup-st",false)
#let backup-no = counter("backup-no")

#let new-section(name) = section.update(name)

#let Institute(full, short:none) = {
  (
    full: full,
    short: if short==none { full } else { short }
  )
}

#let alert(body,fill: orange) = {
  align(center,box(fill: fill.darken(20%), outset: 1em, width: 95%,radius: 10pt,align(center,body)))
}

#let Author(full-name, abbr:none) = {
  (full-name: full-name, abbr: "P. Gautam")
}



#let slide(
  max-repetitions: 10,
  theme-variant: "default",
  override-theme: none,
  footer: true,
  ..args
) = {

  locate( loc => { if slide-ct.at(loc).first() > 0 {pagebreak()} })
  locate( loc => {
    if backup-st.at(loc) { backup-no.step() } else { slide-ct.step() }

    let slide-content = global-theme.at(loc).at(theme-variant)
    if override-theme != none {
      slide-content = override-theme
    }
    let slide-info = args.named()
    let bodies = args.pos()

    slide-content(slide-info,bodies,footer:footer)
  })
}

#let titlepage() = { slide(theme-variant: "title slide") }

#let slide-number(obj) = {
  locate(loc => {
    let current = if backup-st.at(loc) { backup-no.at(loc).at(0) } else { slide-ct.at(loc).at(0) }
    let total   = if backup-st.at(loc) { backup-no.final(loc).at(0) } else { slide-ct.final(loc).at(0) }
    [#(current)/#(total)]
  })
}

#let slides-default-theme() = data => {
  let title-slide(slide-info, bodies,footer: false) = {
    if bodies.len() != 0 {
      panic("title slide of default theme does not support any bodies")
    }

    align(center + horizon)[
      #block( stroke: ( y: 1mm + data.thm.ac), inset: 1em, breakable: false, [
        #text(1.3em)[*#data.title*] \
        #{
          if data.subtitle != none {
            parbreak()
            text(.9em)[#data.subtitle]
          }
        }
      ]
    )
    #set text(size: .8em)
    #grid(
      columns: (1fr,) * calc.min(data.authors.len(), 3),
      column-gutter: 1em,
      row-gutter: 1em,
      ..data.authors
    )
    #data.institute.full
    #v(1em)
    #data.location \
    #data.date
  ]
}


let default(slide-info, bodies,content:none,footer:true) = {
  if bodies.len() != 1 and content == none {
    panic("default variant of default theme only supports one body per slide")
  }
  let body = bodies.first()


  let decoration(position, body) = {
    let border = 1mm + color
    let strokes = (
      header: ( bottom: border ),
      footer: ( top: border )
    )
    block(
      stroke: strokes.at(position),
      width: 100%,
      fill: rgb("ff8d1f"),
      inset: .3em,
      text(.5em, body)
    )
  }


  // header
  //decoration("header", section.display())

  if "title" in slide-info {
    block(
      width: 100%, inset: (x: 1em, y: 0.5em), breakable: false, fill: data.thm.bg.lighten(20%),
      outset: 0.6em, height: 6%,
      heading(level: 1, slide-info.title)
    )
  }

  v(1fr)
  if content == none {
    block( width: 100%, inset: (x: 1em), breakable: false, outset: 0em, body)
  } else { content(bodies) }
  v(2fr)

  let cbox(body,fill: orange, width: 25%, al: center) = {
    box(inset:(x: 2pt, y: 1pt), height: 1.1em, width: width,fill: fill,
    align(al,body))
  }
  //let cbox(body,fill:none) = { body }

  let slide_footer() = {
    block(width:100%, fill: data.thm.bg.darken(20%))[
      #text(fill:data.thm.fg.darken(30%), size:12pt)[
        #h(0.08fr)
        #cbox(fill: data.thm.bg.lighten(20%),[
          #(data.short-authors.at(0)) (#data.institute.short)
        ])
        #h(1fr)
        //#cbox(data.date)
        #cbox(width: 50%, fill: none,[#text(data.thm.fg.darken(50%),data.title) ])
        #h(1fr)
        #cbox(fill: data.thm.bg.lighten(20%),al: right,[#data.date #h(5em)  #slide-number(slide-ct)])]
        #h(0.15fr)
      ]
    }
    if footer {slide_footer()}
  }
  (
    "title slide": title-slide,
    "default": default,
  )
}

#let backup(content) = {
  backup-st.update(true)
  slide(alert(content),footer:false)
}

// ===================================
// ======== TEMPLATE FUNCTION ========
// ===================================

#let slides(
  title: none,
  authors: none,
  institute: none,
  location: none,
  subtitle: none,
  short-title: none,
  short-authors: none,
  date: datetime.today().display(),
  theme: slides-default-theme(),
  aspect: 1.6,
  thm: (fg:white,bg:rgb("282a36"),ac: orange),
  body
) = {

  let asp = aspect
  set page(
    //paper: "presentation-" + aspect-ratio,
    width: asp*16cm,
    height: 16cm,
    margin: 0pt,
    fill: thm.bg
  )

  let data = (
    title: title,
    authors: if type(authors) == "array" {
      authors
    } else if type(authors) in ("string", "content", "none") {
      (authors, )
    } else {
      panic("if not none, authors must be an array, string, or content.")
    },
    short-authors : if type(short-authors) in ("none") {
      (authors,)
    } else if type(short-authors) == "array" {
      short-authors
    } else if type(short-authors) in ("string","content"){
      (short-authors, )
    } else { panic("So much panic short-authors") },
    subtitle: subtitle,
    short-title: short-title,
    date: date,
    institute: institute,
    location: location,
    thm: thm,
  )
  let the-theme = theme(data)
  global-theme.update(the-theme)

  //set text(font: "Noto Serif", size: 20pt, fill: thm.fg)
  //set text(size: 20pt, fill: thm.fg, font: "cmss12")
  //set text(size: 20pt, fill: thm.fg, font: "Noto Sans")
  set text(size: 20pt, fill: thm.fg, font: "CMU Sans Serif")
  //set text(size: 20pt, fill: thm.fg, font: "Laila")



  set list(marker: (text(21pt)[▶],[•], [--]))

  body
}
