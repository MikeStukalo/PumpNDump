from scrapy import Request
from reddit.items import RedditItem
from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor
import time
import numpy as np


class PennyStocks(CrawlSpider):
    name = "robin"
    allowed_urls = ["https://old.reddit.com"]
    start_urls = ["https://old.reddit.com/r/RobinHoodPennyStocks/"]

    # To address random link patterns on redit we use regex
    # 'Next' button link looks like
    #  https://old.reddit.com/r/pennystocks/?count=25&after=t3_9pdtke

    rules = [Rule(LinkExtractor(allow=['/r/RobinHoodPennyStocks/\?count=\d*&after=\w*']),
                  callback='parse_urls',
                  follow=True)]

    # Get urls of the posts and pass them to the parser
    def parse_urls(self, response):
        # Print url for debugging
        print(response.url)
        print("="*50)

        # Get post urls
        urls = response.xpath("//a[@class='title may-blank ']/@href").extract()

        for url in urls:
            # Add random sleep Timeout
            time.sleep(np.random.uniform(0.01, 2.0))

            # Create a url
            url = "https://old.reddit.com" + url
            #print(url)
            #print('-'*50)

            # Save url for the record and pass it further
            yield Request(url=url, meta={'post_url': url},
            callback=self.parse_page)

        # Add random sleep Timeout
        time.sleep(np.random.uniform(0.01, 5.0))

    def parse_page(self, response):

        # Retrieve url
        url = response.meta['post_url']

        # Parse top post parameters
        post_date = response.xpath("//div[@id='siteTable']//div[@class='entry unvoted']//time/@datetime").extract_first()
        title = response.xpath("//div[@id='siteTable']//div[@class='entry unvoted']//p[@class='title']/a/text()").extract_first()
        op_text = response.xpath("//div[@id='siteTable']//div[@class='entry unvoted']//div[@class='md']/p/text()").extract()
        op_text = " ".join([p for p in op_text])  # Combine all paragraphs
        op_author = response.xpath("//div[@id='siteTable']//div[@class='entry unvoted']//p[@class='tagline ']/a/text()").extract_first()

        # Get all comments
        try:
            comments = response.xpath("//div[@class='commentarea']//div[@class='entry unvoted']")

            #Parse items
            for comment in comments:
                com_date = comment.xpath("p[@class='tagline']/time/@datetime").extract_first()
                com_author = comment.xpath("p[@class='tagline']/a/text()").extract()[1]
                com_text = comment.xpath("form//div[@class='md']/p/text()").extract()
                com_text = " ".join([p for p in com_text])  # Combine all paragraphs

                item = RedditItem()
                item['post_url'] = url
                item['post_date'] = post_date
                item['post_author'] = op_author
                item['post_title'] = title
                item['post_text'] = op_text
                item['com_date'] = com_date
                item['com_author'] = com_author
                item['com_text'] = com_text

                yield item

        # If no coments pass empy strings
        except IndexError:
            item = RedditItem()
            item['post_url'] = url
            item['post_date'] = post_date
            item['post_author'] = op_author
            item['post_title'] = title
            item['post_text'] = op_text
            item['com_date'] = ""
            item['com_author'] = ""
            item['com_text'] = ""

            yield item
