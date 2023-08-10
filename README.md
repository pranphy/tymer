# tymer

A minimalist typst packages to make slide. The theme is kinda like some beamer theme, at least the layout.

This doesn't have fancy features like uncover, only etc. I don't find them useful, they are just distractions.


# Installation

```bash
git clone git@github.com:pranphy/tymer ~/.local/share/typst/packages/local/tymer/0.1.0/
```


# Usage

In your `slide.typ` file

```typst
#import "@local/tymer:0.1.0": *
#show: slides.with(
    authors: "Prakash Gautam",
    institute: Institute("University of Virginia",short:"UVa"),
    short-authors: "P. Gautam",
    title: "Background from all edges",
    location: "Moller Simulation Meeting",
    thm: (fg:white.darken(00%),bg:black.lighten(21%),ac: orange)
)

#titlepage()
```
This will create just a title page. The theme can be configured with different colours. `fg:` sets the text colour. `bg:` sets the background colour and `ac:` for accent colour.

You can have a example slide like


```typst
#slide(title: "Background from different edges")[
    - Item 1
    - Item 2
    $ (sin phi ) / (cos phi) = tan phi $
]
```

You can makr the start of backup slide with `backup` function like:

```typst
#backup(text(60pt)[Backup])
```

The text passed to `backup` function would set the text on backup slide marker. The backup slides have their own independent numbering different from regular slide numbering.


Backup slides are exactly same as regular slides.
```typst
#slide(title: "Background from different edges")[
    - Nothing different here
    - Same deal.
]
```

# Compile
```bash
$ typst compile slide.typ
```

This should produce `slide.pdf`, which you can view with your favourite pdf viewer (zathura??).

