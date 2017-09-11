# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import re


class FlyeralarmPipeline(object):

    def __init__(self, crawler):
        self.stats = crawler
        self.reProductSku = re.compile(r'\d+')

    @classmethod
    def from_crawler(cls, crawler):
        s = cls(crawler)
        return s

    def process_item(self, item, spider):
        # trick from here http://masnun.com/2015/12/04/scrapy-scraping-each-
        # type-of-item-to-its-own-collection-in-mongodb.html
        itType = type(item).__name__.lower()
        if itType == 'supplierproductitem':
            item = self.processProduct(item)
        elif itType == 'supplierparameteritem':
            item = self.processParameter(item)
        elif itType == 'suppliervalueitem':
            item = self.processValue(item)
        return item

    def processProduct(self, item):
        name = item.get('name', '')
        item['caption'] = name
        grp = self.reProductSku.search(item.get('URL', ''))
        if grp:
            item['data'] = grp.group(0)
        return item

    def processParameter(self, item):
        name = item.get('name', '')
        item['name'] = ' '.join(name.split())
        jsStr = item.get('data', '')
        _, a1, _ = self.triplet(jsStr)
        item['data'] = a1
        return item

    def processValue(self, item):
        sp = item.get('supplier_parameter', '')
        item['supplier_parameter'] = ' '.join(sp.split())
        jsStr = item.get('data', '')
        _, _, a2 = self.triplet(jsStr)
        item['data'] = a2
        return item

    def triplet(self, jsStr):
        a0 = None
        a1 = None
        a2 = None
        s = jsStr.replace('selectShoppingCartAttribute(', '')\
                 .replace(');', '')\
                 .replace("\'", '')
        output = s.split(', ')
        l = len(output)
        if l > 0:
            a0 = output[0]
        if l > 1:
            a1 = output[1]
        if l > 2:
            a2 = output[2]
        return a0, a1, a2
