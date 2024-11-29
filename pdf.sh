eval "$(luarocks path --bin)"
pandoc -f exo.lua -t pdf -o exo.pdf $*
