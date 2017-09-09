local utils = require("utils")

function scrape_product(splash)
    if not splash:start() then
        return ""
    end
    splash.resource_timeout = 10.0
    -- splash:set_viewport_full()
    local output = {html=splash:html(),
                    cookies=splash:get_cookies()}
    -- check if it is a group and exit
    local isGroup = splash:select("section#openPage")
    if isGroup then
        output.isGroup = true
        return output
    end
    -- continue if it is a product
    local isProduct = splash:select("div#shopWrapper")
    if isProduct then
        local product = {}
        product.URL = splash.args.url
        product.name = splash:select("h1.productName"):text()
        --product.output = walk_attribs(splash, {})
        local prodBody = splash:select("div#configuratorContent")
        if prodBody then
            local attrs = walk_attribs(splash, {})
--            local aName = prodBody:querySelector("h3"):text()
--            local statuss = "not yet"
--            if string.find(aName, "delivery") then
--                statuss = "last"
--            end
            output.attrs = attrs
        end
--        local attrs = {}
--        local cAttr = splash:select("div#currentAttribute")
--        if cAttr then
--            local aName = cAttr:querySelector("div#selectedAttributeHeader"):text()
--            attrs[#attrs+1] = aName
--            local statuss = string.find(aName, "Delivery")
--            if not statuss then
--                statuss = "huj"
--            end
--        end
--        return {
--            cookies=splash:get_cookies(),
--            html = splash:html(),
--            --har=splash:har(),
--            product = product,
--            attrs = attrs}
        output.product = product
    end
    return output
end


function walk_attribs(splash, attrs)
    local aName = splash:select("div#configuratorContent h3"):text()
    if string.find(aName, "delivery") then
        attrs[#attrs+1] = "delivery"
        return attrs
    end
    local cAttr = splash:select("div#currentAttribute")
    if cAttr then
        attrs[#attrs+1] = aName
        -- do click
        assert(cAttr:querySelector("div.attributeValue"):mouse_click())
        return walk_attribs(splash, attrs)
    else
        return attrs
    end
end


function parse_attrib(splash)
    local output = {}
    local cAttr = splash:select("div#currentAttribute")
    if cAttr then
        local aName = cAttr:querySelector("div#selectedAttributeHeader"):text()
        output.name = aName
        if string.find(aName, "Delivery") then
            output.lastGroup = true
        end
        --local values = cAttr
        local aValues = cAttr:querySelectorAll("div#attributeValues div.attributeValueContainer")
        local huj
        for _, v in pairs(aValues) do
            huj = v:querySelector("div.attributeValueName"):text()
        end
        output.huj = huj
        return output
    end
end


function main(splash)
    splash.resource_timeout = 10.0
    if not splash:start() then return "" end
    return {
        html=splash:html(),
        cookies=splash:get_cookies()
    }
end
