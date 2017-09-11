local utils = require("utils")
local treat = require("treat")

function scrape_product(splash)
    if not splash:start() then
        return ""
    end
    splash.resource_timeout = 10.0
    local output = {html=splash:html(),
                    cookies=splash:get_cookies()}
    -- check if it is a group and exit
    local isGroup = splash:select("section#openPage")
    if isGroup then
        output.isGroup = true
        return output
    end
    -- continue if it is a product
    splash:set_viewport_full()
    local isProduct = splash:select("div#shopWrapper")
    if isProduct then
        local product = {}
        product.URL = splash.args.url
        product.name = splash:select("h1.productName"):text()
        --product.output = walk_attribs(splash, {})
        local prodBody = splash:select("div#configuratorContent")
        if prodBody then
            local ok, attrs = splash:with_timeout(
                function()
                    return walk_attribs(splash, {})
                end,
                40)
            product.parameters = treat.as_array(attrs)
        end
        output.product = product
    end
    return output
end


function walk_attribs(splash, attrs)
    local aName = splash:select("div#configuratorContent h3"):text()
    if string.find(aName, "delivery") then
        attrs[#attrs+1] = {name = "delivery", data = "" }
        return attrs
    end
    local cAttr = splash:select("div#currentAttribute")
    if cAttr then
        -- attr values here
        local valDivs = assert(cAttr:querySelectorAll("div.attributeValueName, div.attributeValueListNameText"))
        local values = collect_values(valDivs)
        -- attr name and data here
        local clickTag = cAttr:querySelector("div.attributeValue, div.attributeValueListName.cursor")
        local jsProcTxt = clickTag.attributes.onclick
        attrs[#attrs+1] = {name = aName, values = values, data = jsProcTxt}
        -- do click
        local ok, reason = clickTag:mouse_click()
        splash:wait(2)
        if ok then
            return walk_attribs(splash, attrs)
        end
    end
    return attrs
end


function collect_values(valDivs)
    local values = {}
    for k, value in pairs(valDivs) do
        local click = value.parentElement.attributes.onclick
        values[#values+1] = {name=value:text(), data=click}
    end
    return values
end


function main(splash)
    splash.resource_timeout = 10.0
    if not splash:start() then return "" end
    return {
        html=splash:html(),
        cookies=splash:get_cookies()
    }
end
