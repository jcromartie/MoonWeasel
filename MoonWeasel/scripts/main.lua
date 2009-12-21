
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
  return handler and handler(info) or handlers.default(info)
end

function handlers.default(info)
  local _, _, path = info.uri:find('/(.*)')
  local text = moonweasel.delegate("contentsOfFileNamed:", path)
  return text or "<h1>404ed!</h1>"
end

-- =====================
-- == example handler ==
-- =====================

local hits = 0

handlers.hello = function(info)
  hits = hits + 1
  local greetstr = "<div>" .. greeting .. (info.params.name or "stranger") .. ", you've been here: " .. hits .. " times</div>"

  local headers = ""
  for k, v in pairs(info.headers or {}) do
    headers = headers .. k .. " => " .. v .. "\n"
  end
  moonweasel.delegate("setText:", headers)

  return greetstr
end

handlers.fail = function(info)
  return "one" + 1
end

function dostuff()
  print "Hi there, this is dostuff()."
  print("The path for main.lua is " .. moonweasel.delegate("pathForScript:", "main"))
  print("My delegate is: " .. moonweasel.delegate("description"))
  local tab = {
    foo = 'bar',
    fn = function(x) print("Lua says: " .. x) end,
  }
  local list = { 42, 43, 44, "OH YEAH"}
  return tab, list
end
