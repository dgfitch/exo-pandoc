# TODO

Uses Pandoc's [custom readers](https://pandoc.org/custom-readers.html) to 
convert my weird exo stuff into PDF format, or whatever else pandoc can write.

See also:
- https://pandoc.org/lua-filters.html#module-pandoc
- https://www.inf.puc-rio.br/~roberto/lpeg/


## Notes

[Water.css](https://watercss.kognise.dev/) is a "drop-in collection of CSS 
styles to make simple websites just a little nicer." It works well with the 
HTML documents produced by pandoc, and so it simplifies the production of 
styled webpages.

	pandoc -s --css='https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css' …

