eval "$(luarocks path --bin)"
pandoc -f exo.lua -t native $*
