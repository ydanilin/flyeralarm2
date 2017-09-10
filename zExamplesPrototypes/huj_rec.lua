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
    local cAttr = splash:select("div#currentAttribute")
    if cAttr then

        -- attr values here
        local valDivs = assert(cAttr:querySelectorAll("div.attributeValueName, div.attributeValueListNameText"))
        local values = {}
        for k, value in pairs(valDivs) do
            local click = value.parentElement.attributes.onclick
            values[#values+1] = {name=value:text(), data=click}
        end

        local clickTag = cAttr:querySelector("div.attributeValue, div.attributeValueListName.cursor")
        local jsProcTxt = clickTag.attributes.onclick
        attrs[#attrs+1] = {name = aName, values = values, data = jsProcTxt }
        -- do click
        local ok, reason = clickTag:mouse_click()
        splash:wait(2)
        if ok then
            return walk_attribs(splash, attrs)
        end
    end
    return attrs
end