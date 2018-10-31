# PumpNDump

A web-scraping project aimed at identification of potential pump-and-dump activities on Reddit small-stock boards.

## Data structure

/ reddit  - Scrapy application with spiders that scrape reddit boards: /r/stocks, /r/pennystocks, /r/RobinHoodPennyStocks


/ analysis - Python code to clean, compile and analyze the scraped data

/ analysis/data - scraped data (filenames correspond to reddit boards)

/ analysis/output - some output files later used in the presentation


/presentation - Shiny App, presenting the results of the preliminary analysis


## Shiny App
https://mikestukalo.shinyapps.io/PumpNDump/
