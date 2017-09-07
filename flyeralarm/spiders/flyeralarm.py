#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from scrapy_splash import SplashRequest
from .supplierspider import SupplierSpider


class FlyerSpider(SupplierSpider):
    name = 'flyeralarm'
    allowed_domains = ['flyeralarm.com']
    start_url = 'https://www.flyeralarm.com/uk/content/index/open/id/25414/all-products-a-z.html'

    def parse(self, response):
        prodDiv = response.css('div.productoverviewaz')[0]
        aTags = prodDiv.xpath('.//a')
        for aTag in aTags:
            yield self._follow_item(response, aTag)

    def _follow_item(self, response, item):
        href = item.xpath('@href').extract_first().strip()
        if not href:
            return
        args = {
            'lua_source': self.product_script,
            'proxy': self.proxy
        }
        return SplashRequest(response.urljoin(href), self.parse_item,
                             endpoint='execute', cache_args=['lua_source'],
                             args=args)

    def parse_item(self, response):
        pass
