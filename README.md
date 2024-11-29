# exo-parse

Uses Pandoc's [custom readers](https://pandoc.org/custom-readers.html) to 
convert my weird exo textfiles into PDF format, or whatever else pandoc can write.

References
- https://pandoc.org/lua-filters.html#module-pandoc
- https://www.inf.puc-rio.br/~roberto/lpeg/


## HTML

Try [Water.css](https://watercss.kognise.dev/): a "drop-in collection of CSS 
styles to make simple websites just a little nicer." It works well with the 
HTML documents produced by pandoc, and so it simplifies the production of 
styled webpages.

	pandoc -s --css='https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css' …

## PDF

This should be pretty straightforward, except for cross-file links.

## Supernote

Haven't even started to look but if I want tags and priorities to come through 
in a way that's usable on the Supernote, that's going to take understanding 
their wacky format.
