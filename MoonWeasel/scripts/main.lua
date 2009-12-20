
function parseparams(info)
  local t = {}
  local str = info.querystring
  if not str then return t end
  for k, v in string.gmatch(str, "(%w+)=(%w+)") do
    t[k] = v
  end
  return t
end

local handlers = {}

function moonweasel.handle(info)
  info.params = parseparams(info)
  local _, _, verb = info.uri:find('/(%w+)')
  local handler = handlers[verb]
  return handler and handler(info) or "Unknown handler"
end

-- =====================
-- == example handler ==
-- =====================

local hits = 0

handlers.hello = function(info)
  hits = hits + 1
  local greetstr = "<div>" .. greeting .. (info.params.name or "stranger") .. ", you've been here: " .. hits .. " times</div>"
  local stuffstr = "<div>foo = " .. stuff.foo .. ", bar = " .. stuff.bar .. "</div>"
  moonweasel.delegate("setText:", "hits: " .. hits)
  return greetstr .. stuffstr
end

handlers.fail = function(info)
  return "one" + 1
end

function dostuff()
  print "Hi there, this is dostuff()."
  print("The path for main.lua is " .. moonweasel.delegate("pathForScript:", "main"))
  print("My delegate is: " .. moonweasel.delegate("description"))
  return { foo = 'bar', [1] = 42, 43, 44, "YES!" }
end
