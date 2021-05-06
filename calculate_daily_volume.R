
# v1 contract -------------------------------------------------------------

##########This code is for the PancakeSwap v1 contract

library(readr)
data <- read_csv("export-address-token-0xb374394aee78d2f42926b9eb040e248ee2ea67ec.csv")

#convert to date in new var
data$UnixTimestamp<- as.POSIXct(data$UnixTimestamp, origin = "1970-01-01")
data$date <- as.Date(data$UnixTimestamp)  

#get unique dates
volume_data <- data.frame(dates = unique(data$date))

#add columns to hold data
library("dplyr")

volume_data <- volume_data %>% mutate(wzer_sold = 0, wzer_sold_in_usdt = 0, usdt_sold = 0, wzer_bought = 0)

#for each date, get data frame of transactions
for (i in seq_len(nrow(volume_data))){
  date_1 <- volume_data$dates[i]
  date_txs <-  data[data$date==date_1,]
  #id unique transactions
  txs <- unique(date_txs$Txhash)
  for (j in 1:length(txs)) {
    tx_hash <- txs[j]
    txs_1 <- date_txs[date_txs$Txhash==tx_hash,]
    #if there are 2 rows, it is a trade or LP add. if there are 4 rows LP is removed
    if (nrow(txs_1)==2) {
      if ((txs_1$To[1] == '0xb374394aee78d2f42926b9eb040e248ee2ea67ec') & 
          (txs_1$To[2] == '0xb374394aee78d2f42926b9eb040e248ee2ea67ec')){
        } else {
          index = which(txs_1$To == '0xb374394aee78d2f42926b9eb040e248ee2ea67ec')
          #id token, and add amount to corresponding column/row in volume_data
          if (txs_1$TokenSymbol[index]=='BUSD-T'){
            volume_data$usdt_sold[i]<- volume_data$usdt_sold[i] + txs_1$Value[index]
            if ((txs_1$From[1] == '0xb374394aee78d2f42926b9eb040e248ee2ea67ec') &
                (txs_1$TokenSymbol[1]=='wZER')) {
              volume_data$wzer_bought[i]<-volume_data$wzer_bought[i] + txs_1$Value[1]
            }
            if ((txs_1$From[2] == '0xb374394aee78d2f42926b9eb040e248ee2ea67ec') &
                (txs_1$TokenSymbol[2]=='wZER')) {
              volume_data$wzer_bought[i]<-volume_data$wzer_bought[i] + txs_1$Value[2]
            }
            } 
          if (txs_1$TokenSymbol[index]=='wZER'){
            volume_data$wzer_sold[i]<- volume_data$wzer_sold[i] + txs_1$Value[index]
            if ((txs_1$From[1] == '0xb374394aee78d2f42926b9eb040e248ee2ea67ec') &
                (txs_1$TokenSymbol[1]=='BUSD-T')) {
              volume_data$wzer_sold_in_usdt[i]<-volume_data$wzer_sold_in_usdt[i] + txs_1$Value[1]
            }
            if ((txs_1$From[2] == '0xb374394aee78d2f42926b9eb040e248ee2ea67ec') &
                (txs_1$TokenSymbol[2]=='BUSD-T')) {
              volume_data$wzer_sold_in_usdt[i]<-volume_data$wzer_sold_in_usdt[i] + txs_1$Value[2]
            }
            }
            
          }
        }
    }
  }

######add columns and calculations for total daily volume (in USD), total fees (in USD), and fees in each coin
volume_data <- volume_data %>% mutate(total_volume_usd = 0, total_volume_wzer = 0, tot_fees_usd = 0, fees_wzer= 0, fees_usdt = 0, wzer_price = 0)
volume_data$total_volume_usd <- volume_data$wzer_sold_in_usdt + volume_data$usdt_sold
volume_data$total_volume_wzer <- volume_data$wzer_sold + volume_data$wzer_bought
volume_data$tot_fees_usd <- volume_data$total_volume_usd * .0017
volume_data$fees_wzer <- volume_data$wzer_sold * .0017
volume_data$fees_usdt <- volume_data$usdt_sold * .0017
for (i in seq_len(nrow(volume_data))) {
if (is.nan(((volume_data$wzer_sold_in_usdt[i]/volume_data$wzer_sold[i])+(volume_data$usdt_sold[i]/volume_data$wzer_bought[i]))/2) == FALSE){
  volume_data$wzer_price[i] <- ((volume_data$wzer_sold_in_usdt[i]/volume_data$wzer_sold[i])+(volume_data$usdt_sold[i]/volume_data$wzer_bought[i]))/2
  } else if (is.nan(volume_data$wzer_sold_in_usdt[i]/volume_data$wzer_sold[i]) == FALSE) {
  volume_data$wzer_price[i] <- volume_data$wzer_sold_in_usdt[i]/volume_data$wzer_sold[i]   
  } else if (is.nan(volume_data$usdt_sold[i]/volume_data$wzer_bought[i]) == FALSE) {
    volume_data$wzer_price[i] <- volume_data$usdt_sold[i]/volume_data$wzer_bought[i] 
      } else {
        volume_data$wzer_price[i] <- NA
        }
}

volume_data_v1 <- volume_data

library(xlsx) 
write.xlsx(volume_data_v1, "v1_volume_data.xlsx", row.names = FALSE)

# v2 contract -------------------------------------------------------------

##########This code is for the PancakeSwap v2 contract

library(readr)
data <- read_csv("export-address-token-0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6.csv")

#convert to date in new var
data$UnixTimestamp<- as.POSIXct(data$UnixTimestamp, origin = "1970-01-01")
data$date <- as.Date(data$UnixTimestamp)  

#get unique dates
volume_data <- data.frame(dates = unique(data$date))

#add columns to hold data
library("dplyr")

volume_data <- volume_data %>% mutate(wzer_sold = 0, wzer_sold_in_usdt = 0, usdt_sold = 0, wzer_bought = 0)

#for each date, get data frame of transactions
for (i in seq_len(nrow(volume_data))){
  date_1 <- volume_data$dates[i]
  date_txs <-  data[data$date==date_1,]
  #id unique transactions
  txs <- unique(date_txs$Txhash)
  for (j in 1:length(txs)) {
    tx_hash <- txs[j]
    txs_1 <- date_txs[date_txs$Txhash==tx_hash,]
    #if there are 2 rows, it is a trade or LP add. if there are 4 rows LP is removed
    if (nrow(txs_1)==2) {
      if ((txs_1$To[1] == '0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6') & 
          (txs_1$To[2] == '0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6')){
      } else {
        index = which(txs_1$To == '0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6')
        #id token, and add amount to corresponding column/row in volume_data
        if (txs_1$TokenSymbol[index]=='BUSD-T'){
          volume_data$usdt_sold[i]<- volume_data$usdt_sold[i] + txs_1$Value[index]
          if ((txs_1$From[1] == '0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6') &
              (txs_1$TokenSymbol[1]=='wZER')) {
            volume_data$wzer_bought[i]<-volume_data$wzer_bought[i] + txs_1$Value[1]
          }
          if ((txs_1$From[2] == '0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6') &
              (txs_1$TokenSymbol[2]=='wZER')) {
            volume_data$wzer_bought[i]<-volume_data$wzer_bought[i] + txs_1$Value[2]
          }
        } 
        if (txs_1$TokenSymbol[index]=='wZER'){
          volume_data$wzer_sold[i]<- volume_data$wzer_sold[i] + txs_1$Value[index]
          if ((txs_1$From[1] == '0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6') &
              (txs_1$TokenSymbol[1]=='BUSD-T')) {
            volume_data$wzer_sold_in_usdt[i]<-volume_data$wzer_sold_in_usdt[i] + txs_1$Value[1]
          }
          if ((txs_1$From[2] == '0xad7b5e295a476c43f1fc3b7bb945030e9e9ffdc6') &
              (txs_1$TokenSymbol[2]=='BUSD-T')) {
            volume_data$wzer_sold_in_usdt[i]<-volume_data$wzer_sold_in_usdt[i] + txs_1$Value[2]
          }
        }
        
      }
    }
  }
}

######add columns and calculations for total daily volume (in USD), total fees (in USD), and fees in each coin
volume_data <- volume_data %>% mutate(total_volume_usd = 0, total_volume_wzer = 0, tot_fees_usd = 0, fees_wzer= 0, fees_usdt = 0, wzer_price = 0)
volume_data$total_volume_usd <- volume_data$wzer_sold_in_usdt + volume_data$usdt_sold
volume_data$total_volume_wzer <- volume_data$wzer_sold + volume_data$wzer_bought
volume_data$tot_fees_usd <- volume_data$total_volume_usd * .0017
volume_data$fees_wzer <- volume_data$wzer_sold * .0017
volume_data$fees_usdt <- volume_data$usdt_sold * .0017
for (i in seq_len(nrow(volume_data))) {
  if (is.nan(((volume_data$wzer_sold_in_usdt[i]/volume_data$wzer_sold[i])+(volume_data$usdt_sold[i]/volume_data$wzer_bought[i]))/2) == FALSE){
    volume_data$wzer_price[i] <- ((volume_data$wzer_sold_in_usdt[i]/volume_data$wzer_sold[i])+(volume_data$usdt_sold[i]/volume_data$wzer_bought[i]))/2
  } else if (is.nan(volume_data$wzer_sold_in_usdt[i]/volume_data$wzer_sold[i]) == FALSE) {
    volume_data$wzer_price[i] <- volume_data$wzer_sold_in_usdt[i]/volume_data$wzer_sold[i]   
  } else if (is.nan(volume_data$usdt_sold[i]/volume_data$wzer_bought[i]) == FALSE) {
    volume_data$wzer_price[i] <- volume_data$usdt_sold[i]/volume_data$wzer_bought[i] 
  } else {
    volume_data$wzer_price[i] <- NA
  }
}

volume_data_v2 <- volume_data

library(xlsx) 
write.xlsx(volume_data_v2, "v2_volume_data.xlsx", row.names = FALSE)
