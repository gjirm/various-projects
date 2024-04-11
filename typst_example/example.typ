
#let name = "Document Name"

#set text(
  font: "New Computer Modern",
  size: 10pt
)
#set page(
  paper: "a4",
  margin: (x: 2.54cm, y: 2.54cm),
  header: [
    #set text(14pt)
    #locate(
        loc => if [#loc.page()] != [1] {
            grid(
              columns: (1fr, 1fr),
              align(left)[
              #image(
                "safetica_icon_logo.svg",
                height: 20pt
                )
              ],
              align(right)[
                #name
              ]
            )
        }
    )
    
    
  ],
  numbering: "1 / 1",
  number-align: right
)
#set par(
  justify: true,
  leading: 0.52em,
)

#set heading(
  numbering: "1."
)

#set document(
  title: name,
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

#name

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