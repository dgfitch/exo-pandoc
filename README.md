# exo-parse

Uses Pandoc's [custom readers](https://pandoc.org/custom-readers.html) to 
convert my weird exo textfiles into PDF format, or whatever else pandoc can write.

References
- https://pandoc.org/lua-filters.html#module-pandoc
- https://www.inf.puc-rio.br/~roberto/lpeg/


## HTML

Looks like [Water.css](https://watercss.kognise.dev/) is a good minimal 
solution.

## PDF

This should be pretty straightforward, except for cross-file links. Needs 
`pdflatex` and a bunch of stuff from `texlive` but I already have that 
installed, so not a big deal.

## Supernote

Haven't even started to look but if I want tags and priorities to come through 
in a way that's usable on the Supernote, that's going to take understanding 
their wacky format.
