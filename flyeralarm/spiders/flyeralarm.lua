local utils = require("utils")

function scrape_product(splash)
    if not splash:start() then return "" end

    return {
        cookies=splash:get_cookies(),
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
