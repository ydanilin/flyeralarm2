function main(splash)
  splash.resource_timeout = 10.0
  local url = splash.args.url
  assert(splash:go(url))
  assert(splash:wait(0.5))
  splash:set_viewport_full()
  local ok, attrs = splash:with_timeout(
      function()
         return walk_attribs(splash, {})
      end,
      15)
  
  return {
    --html = splash:html(),
    --har = splash:har(),
    att = attrs,
    status = ok
  }
end


function walk_attribs(splash, attrs)
    local aName = splash:select("div#configuratorContent h3"):text()
    if string.find(aName, "delivery") then
        attrs[#attrs+1] = "delivery"
        return attrs
    end
    --if string.find(aName, "umber") then
    --    attrs[#attrs+1] = "recursia bilatt"
    --    return attrs
    --end
    --attrs[#attrs+1] = aName
    local cAttr = splash:select("div#currentAttribute")
    assert(cAttr)
    if cAttr then
     -- attr values here
        valDivs = assert(cAttr:querySelectorAll("div.attributeValueName, div.attributeValueListNameText"))   
        local values = {}
        for k, value in pairs(valDivs) do
            values[#values+1] = value:text()
        end
        attrs[#attrs+1] = {name = aName, values = values}
        ok, reason = cAttr:querySelector("div.attributeValue, div.attributeValueListName.cursor"):mouse_click()
        splash:wait(2)
        return walk_attribs(splash, attrs)
        --local t = splash:select("div#configuratorContent h3"):text()
        --attrs[#attrs+1] = t
        --attrs[#attrs+1] = ok
        --attrs[#attrs+1] = reason
        --attrs[#attrs+1] = h
        --return walk_attribs(splash, attrs)
    end
    return attrs
end
