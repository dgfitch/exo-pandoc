-- For better performance put these functions in local variables:
local P, S, R, Cf, Cc, Ct, V, Cs, Cg, Cb, B, C, Cmt =
  lpeg.P, lpeg.S, lpeg.R, lpeg.Cf, lpeg.Cc, lpeg.Ct, lpeg.V,
  lpeg.Cs, lpeg.Cg, lpeg.Cb, lpeg.B, lpeg.C, lpeg.Cmt

local loc = lpeg.locale()

local wordchar = (1 - loc.space)
local spacechar = S(" \t")
local newline = P"\r"^-1 * P"\n"
local blankline = spacechar^0 * newline
local endline = newline * #-blankline

local priority = P"!"
local notcolon = (wordchar - P":")

function maybe(p) return p^-1 end
function empty(p)
  return C(p)/''
end

-- Helper, add in grammars like `I'Name' * "name"`
I = function (tag)
  return lpeg.P(function ()
    print(tag)
    return true
  end)
end

-- Actual grammar
G = P{ "Doc",
  Doc = V"Block"^0;

  Block = ( V"Literal" 
          + V"BlankLines"
          + blankline
          + V"Line" );

  Line = Ct((V"TagsBegin" + V"TagsEnd" + V"Space" + V"Priority" + V"Word")^1) / pandoc.Para;
  BlankLines = blankline^2 / pandoc.LineBreak;

  Content = V"Space" + V"Priority" + V"Word";
  Word = wordchar^1 / pandoc.Str;
  Space = spacechar^1 / pandoc.Space;

  Priority = priority 
           * wordchar^1 
           / function(p) 
               return pandoc.Span(p, {priority=p:sub(2)})
             end;

  TagsBegin = (notcolon^1 + spacechar^1)^1
            * P(":")
            / function(p)
                return pandoc.Span(pandoc.Strong(p), {tag="begin"})
              end;

  TagsEnd = P"#"
          * Ct(V"Content"^1) 
          / function(p)
              table.insert(p, 1, '#')
              return pandoc.Span(pandoc.Emph(p), {tag="end"})
            end;

  Literal = P"{{{"
          * blankline
          * C((1 - (newline * P"}}}"))^0)
          * newline
          * P"}}}"
          / pandoc.CodeBlock;
}

function parse_exo (source)
  -- TODO: Currently shoving in the filename, but could do more stuff with tags represented by folder names in the path?
  return pandoc.Div{
    pandoc.Header(1, source.name == '' and '<stdin>' or source.name),
    lpeg.match(G, tostring(source.text))
  }
end

function Reader (input)
  return pandoc.Pandoc(input:map(parse_exo))
end

