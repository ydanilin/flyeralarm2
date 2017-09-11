# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html


class FlyeralarmPipeline(object):
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
        return item

    def processParameter(self, item):
        name = item.get('name', '')
        item['name'] = ' '.join(name.split())
        return item

    def processValue(self, item):
        return item
