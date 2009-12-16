
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

function get(info)
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
  return greetstr .. stuffstr
end

handlers.fail = function(info)
  return "one" + 1
end