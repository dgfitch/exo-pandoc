-- For better performance put these functions in local variables:
local P, S, R, Cf, Cc, Ct, V, Cs, Cg, Cb, B, C, Cmt =
  lpeg.P, lpeg.S, lpeg.R, lpeg.Cf, lpeg.Cc, lpeg.Ct, lpeg.V,
  lpeg.Cs, lpeg.Cg, lpeg.Cb, lpeg.B, lpeg.C, lpeg.Cmt

local whitespacechar = S(" \t\r\n")
local wordchar = (1 - whitespacechar)
local spacechar = S(" \t")
local newline = P"\r"^-1 * P"\n"
local blankline = spacechar^0 * newline
local endline = newline * #-blankline
local priority = P"!"

-- Actual grammar
G = P{ "Doc",
  Doc = V"Block"^0;

  Block = ( V"Literal" 
          + V"BlankLines"
          + blankline
          + V"Line" );

  Line = Ct(V"Inline"^1) / pandoc.Para;
  BlankLines = blankline^2 / pandoc.HorizontalRule;
  Inline = V"Content" + V"Space";
  Space = spacechar^1 / pandoc.Space;

  Content = V"Priority" + V"Words";
  Priority = priority * wordchar^1 / pandoc.Span;
  Words = wordchar^1 / pandoc.Str;

  Literal = P"{{{"
          * blankline
          * C((1 - (newline * P"}}}"))^0)
          * newline
          * P"}}}"
          / pandoc.CodeBlock;
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

