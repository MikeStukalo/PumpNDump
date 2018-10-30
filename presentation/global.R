library(dplyr)
library(plotly)
library(lubridate)

# Sample raw data
raw_table = read.csv("./data/raw_sample.csv")

# Work flow
initial = data.frame(subreddit=c("/r/RobinHoodPennyStocks",
                               "/r/pennystocks",
                               "/r/stocks"),
                   comments = c(9477, 6390, 11056))



clean = data.frame(subreddit=c("/r/RobinHoodPennyStocks",
                                 "/r/pennystocks",
                                 "/r/stocks"),
                     comments = c(3991, 2256, 219))

# Final dataset
final = read.csv("./data/df.csv")

# Get tickers
tickers = as.character(unique(final$ticker))

# Load stock prices
raw_stock = read.csv("./data/raw_stock_quotes.csv")

# Function that plots stock retuns vs positive and negative comments

plotComment = function(ticker){
  # Select stock perfomance
  stock = raw_stock[c("Date", ticker)] 
  stock$Date = as.Date(stock$Date)
  
  # Select comments related to stock
  comm = final[final$ticker==ticker,]
  
  # Calculate weekly sum of comments and average score for positive and negative
  posit = comm %>% group_by(week) %>% summarise(n_com = n(), pos = mean(com_positive[com_positive>0]),
                                                neg = mean(com_positive[com_positive<0]), mindate=min(as.Date(com_date)), 
                                                maxdate=max(as.Date(com_date)))
  
  posit[!is.na(posit$n_com) & is.na(posit$pos), "pos" ] = 0 # Change NA to zero
  posit[!is.na(posit$n_com) & is.na(posit$neg), "neg" ] = 0
  
  
  # Match weeks and dates
  posit$year = floor(posit$week / 100)
  posit$week = posit$week - posit$year *100 
  posit$Date = posit$mindate
  
  # Start returns 4 weeks prior to first comment
  start = min(posit$Date) - as.difftime(4, unit="weeks")
  stock = stock[stock$Date>as.Date(start),]
  colnames(stock) = c("Date", "Price")
  
  
  comb = merge.data.frame(posit[,c("week","year", "n_com", "pos", "neg", "Date")], stock, by="Date", all = TRUE)
  
  
  # Plot
  p1 = plot_ly(x = ~comb$Date, y = ~comb$Price, mode = 'lines', name = paste0(ticker," price"), type = 'scatter') %>% 
    add_trace(x = ~comb$Date[comb$n_com!=0], y = ~comb$Price[comb$n_com!=0], mode = 'markers', name = "Comments", 
              text = paste0("N of comments: ", comb$n_com[comb$n_com!=0]))
  
  
  p2 = plot_ly(x= ~comb$Date, y = ~comb$n_com, name = 'Number of comments', type = 'bar', 
               marker = list(size = 10, color = 'steelblue'))
  
  p3 = plot_ly(x= ~comb$Date, y = ~comb$pos, name = 'Positivity Score (pos)', type = 'bar',
               marker = list(size = 10, color = 'orange')) %>%
    layout(yaxis = list(range=c(0,1)))
  
  p4 = plot_ly(x= ~comb$Date, y = ~comb$neg, name = 'Positivity Score (neg)', type = 'bar',
               marker = list(size = 10, color = 'gray')) %>%
    layout(yaxis = list(range=c(-1,0)))
  
  
  subplot(p1,p2,p3,p4, nrows = 4, shareX = TRUE, titleX = FALSE, titleY = FALSE)
  
} 



# Run logistic regressions

#Specification 1
# Aggregate data
data = final %>% group_by(week, ticker) %>% summarize(Flag = last(lead_pnd_up), 
                                                      Np = n(),
                                                      PS = mean(com_positive))

data = data[data$Flag!="",]


logit1 = glm(Flag ~ Np + PS,
                    family = "binomial",
                    data = data)

#Specification 2
# Aggregate data
data = final %>% group_by(week, ticker) %>% summarize(Flag = last(lead_pnd_up), 
                                                      Np = n(),
                                                      PS = mean(com_positive))

data = data[data$Flag!="",]

# Change PS to categorical
data$PS[data$PS>0] = 1
data$PS[data$PS<0] = -1


logit2 = glm(Flag ~ Np + PS,
             family = "binomial",
             data = data)


#Specification 3
# Aggregate data
data = final %>% group_by(week, ticker) %>% summarize(Flag = last(lead_pnd_up), 
                                                      Np = n(),
                                                      PS = mean(com_positive),
                                                      R = last(return))

data = data[data$Flag!="",]

# Change PS to categorical
data$PS[data$PS>0] = 1
data$PS[data$PS<0] = -1


logit3 = glm(Flag ~ Np + PS + R,
             family = "binomial",
             data = data)


# Specification 4

# Aggregate data
data = final %>% group_by(week, ticker, top_post) %>% summarize(Flag = last(lead_pnd_up), 
                                                      Np = n(),
                                                      PS = mean(com_positive),
                                                      R = last(return))

data = data[data$Flag!="",]

# Change PS to categorical
data$PS[data$PS>0] = 1
data$PS[data$PS<0] = -1

# Create interaction variables
data$m1TP_Np = (1-data$top_post) * data$Np
data$m1TP_PS = (1-data$top_post) * data$PS
data$TP_Np = data$top_post * data$Np
data$TP_PS = 1-data$top_post * data$PS


logit4 = glm(Flag ~ m1TP_Np + m1TP_PS + TP_Np + TP_PS,
             family = "binomial",
             data = data)



