-- For better performance put these functions in local variables:
local P, S, R, Cf, Cc, Ct, V, Cs, Cg, Cb, B, C, Cmt =
  lpeg.P, lpeg.S, lpeg.R, lpeg.Cf, lpeg.Cc, lpeg.Ct, lpeg.V,
  lpeg.Cs, lpeg.Cg, lpeg.Cb, lpeg.B, lpeg.C, lpeg.Cmt

local whitespacechar = S(" \t\r\n")
local wordchar = (1 - whitespacechar)
local spacechar = S(" \t")
local newline = P"\r"^-1 * P"\n"
local blanklines = newline * (spacechar^0 * newline)^1
local endline = newline - blanklines
local priority = P"!"

-- Actual grammar
G = P{ "Doc",
  Doc = V"Block"^0;

  Block = blanklines^0 
        * V"Line"^1
        * endline^0;

  Line = Ct(V"Inline"^1) / pandoc.Para;
  Inline = V"Content" + V"Space";

  Literal = P"{{{"
          * blanklines
          * C((1 - (newline * P"}}}"))^0)
          * newline
          * P"}}}"
          / pandoc.CodeBlock;

  Priority = priority * wordchar^1 / pandoc.Span;
  Words = wordchar^1 / pandoc.Str;

  Content = V"Priority" + V"Words";

  Space = spacechar^1 / pandoc.Space;
}

function parse_exo (source)
  -- TODO: Currently shoving in the filename, but could do more stuff with tags represented by path
  return pandoc.Div{
    pandoc.Header(1, source.name == '' and '<stdin>' or source.name),
    lpeg.match(G, tostring(source.text))
  }
end

function Reader (input)
  return pandoc.Pandoc(input:map(parse_exo))
end

