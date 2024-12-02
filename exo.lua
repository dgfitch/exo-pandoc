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

-- Helper for counting (lol lua)
function len(t)
  local c = 0
  for n in pairs(t) do
    c = c + 1
  end
  return c
end

-- Helper for dumping
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end



-- Main grammar
G = P{ "Doc",
  Doc = V"Block"^0;

  Block = ( V"Literal" 
          + V"BlankLines"
          + blankline
          + V"Line" );

  Line = Ct(V"Indents"^0 * (V"TagsBegin" + V"TagsEnd" + V"Space" + V"Priority" + V"Word")^1);
  BlankLines = blankline^2 / pandoc.LineBreak;

  Content = V"Space" + V"Priority" + V"Word";
  Word = wordchar^1 / pandoc.Str;
  Space = spacechar / pandoc.Space;
  Indents = spacechar^2
         / function(p)
             return pandoc.Span("", {indentlevel=p:len() // 2})
         end;

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


-- Helper to deal with turning indentation into nested lists
function reorg (lines)
  -- TODO
  -- require "croissant.debugger"()

  return lines
end

function parse_exo (source)
  text = tostring(source.text)

  -- Currently shoving in the filename, but could do more stuff with tags represented by folder names in the path?
  header = pandoc.Header(1, source.name == '' and '<stdin>' or source.name)

  lines = { lpeg.match(G, text) }
  in_paras = reorg(lines)

  doc = pandoc.Div { header, table.unpack(in_paras) }

  return doc
end

function Reader (input)
  return pandoc.Pandoc(input:map(parse_exo))
end

