local utils = require("utils")

function scrape_product(splash)
    local isGroup = nil
    local group = nil
    if not splash:start() then
        return ""
    end
    -- splash:set_viewport_full()
    -- check if it is a group
    isGroup = splash:select("section#openPage")
    if isGroup then
        -- find sub-div with class "row"
        group = isGroup:getElementsByClassName("row")
        if group then
            -- # extracts links to individual product pages within the category
            print(group)
        end
    end

    return {
        cookies=splash:get_cookies(),
        grp = type(group[1]),
    l = #group,
        grp = type(group[0]),
    html = splash:html()
        --png=splash:png(),
        --har=splash:har(),
        --product = product
    }
end

function main(splash)
    if not splash:start() then return "" end
    return {
        html=splash:html(),
        cookies=splash:get_cookies()
    }
end
