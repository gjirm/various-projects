#set text(
  font: "New Computer Modern",
  size: 10pt
)
#set page(
  paper: "a6",
  margin: (x: 1.8cm, y: 1.5cm),
)
#set par(
  justify: true,
  leading: 0.52em,
)

#set heading(
  numbering: "1."
)

#set document(
  title: "Glacier report",
  author: "JirM",
  keywords:  ("glacier","climate"),
  date: auto
)

#show link: set text(blue)
#show link: underline
#show "Safetica": name => box[
  #box(image(
    "safetica_icon_logo.svg",
    height: 0.7em,
  ))
  #name
]

= Introduction <intro>
In this report, we will explore the
various factors that influence _fluid
dynamics_ in glaciers and how they
contribute to the formation and
behaviour of these natural structures.

+ The climate
  - Temperature
  - Precipitation
+ The topography
+ The geology

Glaciers as the one shown in
@glaciers will cease to exist if
we don't take action soon!

#align(center + bottom)[
  #figure(
    image("glacier.jpg", width: 70%),
    caption: [
      *Glaciers form an important part
      of the earth's climate system.*
    ],
  ) <glaciers>
] 
== Background
#lorem(12)

== Methods
We follow the glacier melting models
established in @aksin.

Total displaced soil by glacial flow:

$ 7.32 beta +
  sum_(i=0)^nabla
    (Q_i (a_i - epsilon)) / 2 $

Adding `rbx` to `rcx` gives
the desired result.

What is ```rust fn main()``` in Rust
would be ```c int main()``` in C.

```rust
fn main() {
    println!("Hello World!");
}
```

This has ``` `backticks` ``` in it
(but the spaces are trimmed). And
``` here``` the leading space is
also trimmed.

#link("mailto:hello@typst.app") \
#link(<intro>)[Go to intro] \
#link((page: 1, x: 0pt, y: 0pt))[
  Go to top
]

This report is embedded in the
Safetica project. Safetica is a
project of the Artos Institute.

#bibliography("biblatex-examples.bib")