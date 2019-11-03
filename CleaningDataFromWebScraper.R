library(openxlsx)
library(dplyr)
library(tidyr)
library(stringr)

getwd()
setwd("D:/Master/AN_2/Sem 1/NLP")

# read actual data frame
df = read.csv("emag_Laptopuri.csv")

# split diff_infos column into 2 parts (the first part contains the name of the laptop)
df <- df %>% separate(diff_infos, into = c("Denumire Laptop", "diff_infos"), sep = 'cu')

# we will use extra = "merge" because we want to keep what is after sep = ","
# (the idea is that we have more than 1 "," and therefore we will have problems if we don t include extra argument)
df <- df %>% separate(diff_infos, into = c("Tip Procesor", "diff_infos"), sep = ",", extra = "merge")

# taking the size of the laptops
df <- df %>% separate(diff_infos, into = c("Dimensiune Ecran (inch.)", "diff_infos"), sep = "\",")

# we eliminate from column everything before ","
df$`Dimensiune Ecran (inch.)` <- sub('.*\\,', '', df$`Dimensiune Ecran (inch.)`)

# str_remove (package: stringr)
# we want to remove some strings, in order to make possible to take what we want
# this patterns represents the display technologies and display formats
df$diff_infos <- str_remove(df$diff_infos, "IPS,")
df$diff_infos <- str_remove(df$diff_infos, "Full HD,")
df$diff_infos <- str_remove(df$diff_infos, "144Hz,")
df$diff_infos <- str_remove(df$diff_infos, "120Hz,")
df$diff_infos <- str_remove(df$diff_infos, "HD,")
df$diff_infos <- str_remove(df$diff_infos, "Touch,")
df$diff_infos <- str_remove(df$diff_infos, "Ecran Retina,")

df <- df %>% separate(diff_infos, into = c("Capacitate Memorie (GB)", "diff_infos"), sep = ",", extra = "merge")
# delete 'GB' from values
df$`Capacitate Memorie (GB)` <- substr(df$`Capacitate Memorie (GB)`, 1, nchar(df$`Capacitate Memorie (GB)`) - 2)

df <- df %>% separate(diff_infos, into = c("Capacitate Stocare", "diff_infos"), sep = ",", extra = "merge")

df <- df %>% separate(diff_infos, into = c("Placa Video", "diff_infos"), sep = ",", extra = "merge")

# now we will remove diff_infos columns (we don t need it anymore)
df <- subset(df, select = -diff_infos)

df$new_price <- str_replace(df$new_price ," Lei", "")
names(df)[7] <- "Pret Nou (Lei)"

# we split 'Pret Nou' column in 2 columns
df <- df %>% separate(old_price, into = c("Pret Vechi (Lei)", "% Reducere"), sep = " ")
# View(df)

# we extract from '% Reducere' column only the percentage (without Lei)
df$`% Reducere` <- substr(df$`% Reducere`, 6, 7)
# replace "%" with ""
df$`% Reducere` <- str_replace(df$`% Reducere`, "%", "")

# we extract from 'nr_of_reviews' column only the nr. of reviews
df$nr_of_reviews <- substr(df$nr_of_reviews, 1, 2)

###### Rating column

# delete width string from 'rating' column values
df$rating <- substring(df$rating, 7)

# delete '%'
df$rating <- substr(df$rating, 1, 2)
# View(df)

#######################################
########## Procesor column ############
#######################################

# replace "procesor" word with "" in 'Tip Procesor' column
df$`Tip Procesor` <- str_replace(df$`Tip Procesor`, "procesor", "")

df$`Tip Procesor` <- str_trim(df$`Tip Procesor`)
df <- df %>% separate(`Tip Procesor`, into = c("a", "b", "Generatie Procesor", "d", "e", "Frecventa Procesor (GHz)"), sep = " ")

# delete special characters from "Tip Procesor" column
df$a <- gsub("[^0-9A-Za-z///' ]", "", df$a)
df$b <- gsub("[^0-9A-Za-z///' ]", "", df$b)

# merge column a and column b
df <- unite(df, "Tip Procesor", c("a", "b"), sep = " ")

# now we will remove d and e columns (we don t need them anymore)
df <- subset(df, select = -c(d,e))

# taking from "Generatie Procesor" only the i and generation number
df$`Generatie Procesor` <-  str_extract(df$`Generatie Procesor`, "[i]{1,2}\\d")

#################################################
######### same for "Placa video" column ######### 
#################################################

# eliminate spaces
df$`Placa Video` <- str_trim(df$`Placa Video`)
df <- df %>% separate(`Placa Video`, into = c("a1", "b2", "c3", "Versiune Placa Video", "Capacitate Placa Video (GB)"), sep = " ")

df$a1 <- gsub("[^0-9A-Za-z///' ]", "", df$a1)
df$b2 <- gsub("[^0-9A-Za-z///' ]", "", df$b2)

# merge column a1 and column b2
df <- unite(df, "Tip Placa Video", c("a1", "b2", "c3"), sep = " ")

# delete "GB" word from "Capacitate Placa Video" column
df$`Capacitate Placa Video (GB)` <- str_replace(df$`Capacitate Placa Video (GB)`,"GB", "")

# fill NA-s values (pentru placile video integrate)
df$`Capacitate Placa Video (GB)` <- 
  ifelse(is.na(df$`Capacitate Placa Video (GB)`), "-", df$`Capacitate Placa Video (GB)`)

#######################################
###### Capacitate Stocare column ######
#######################################

df$`Capacitate Stocare` <- str_trim(df$`Capacitate Stocare`)
df <- df %>% separate(`Capacitate Stocare`, into = c("Capacitate Stocare (GB)", "Tip Stocare"), sep = " ")

# change 1TB to 1000GB
df$`Capacitate Stocare (GB)` <- ifelse(df$`Capacitate Stocare (GB)` == "1TB", "1000GB", df$`Capacitate Stocare (GB)`)


# delete "GB"
df$`Capacitate Stocare (GB)` <- str_replace(df$`Capacitate Stocare (GB)`, "GB", "")

df$`Tip Stocare` <- ifelse(is.na(df$`Tip Stocare`), "HDD", df$`Tip Stocare`)

############################################
############### More Changes ###############
############################################

df$`Versiune Placa Video` <- 
  ifelse(is.na(df$`Versiune Placa Video`), "-", df$`Versiune Placa Video`)

df$`Generatie Procesor` <- 
  ifelse(is.na(df$`Generatie Procesor`), "-", df$`Generatie Procesor`)

# verify the complete cases and eliminate the ones that are not complete
sum(complete.cases(df))
newDf <- df[complete.cases(df), ]


#################################################
############### Final adjustments ###############
#################################################

newDf <- newDf[- grep("la", newDf$`Frecventa Procesor (GHz)`),]
newDf <- newDf[- grep("GHz", newDf$`Frecventa Procesor (GHz)`),]
newDf <- newDf[- grep("Ghz", newDf$`Frecventa Procesor (GHz)`),]
newDf <- newDf[- grep("Whiskey", newDf$`Frecventa Procesor (GHz)`),]

#newDf <- newDf[- grep("+", newDf$`Tip Stocare`),]
newDf <- newDf[- grep("Hybrid", newDf$`Tip Stocare`),]
newDf <- newDf[- grep("FireCuda", newDf$`Tip Stocare`),]
newDf <- newDf[- grep("GeForce", newDf$`Tip Stocare`),]

newDf <- newDf[- grep("X", newDf$`Versiune Placa Video`),]
newDf <- newDf[- grep("GB", newDf$`Versiune Placa Video`),]
newDf <- newDf[- grep("Ti", newDf$`Versiune Placa Video`),]
#newDf <- newDf[- grep("+", newDf$`Versiune Placa Video`),]

newDf <- newDf[- grep("Ti", newDf$`Capacitate Placa Video (GB)`),]
newDf <- newDf[- grep("TI", newDf$`Capacitate Placa Video (GB)`),]
newDf <- newDf[- grep("GDDR5", newDf$`Capacitate Placa Video (GB)`),]
newDf <- newDf[- grep("1TB", newDf$`Capacitate Placa Video (GB)`),]
newDf <- newDf[- grep("HDD", newDf$`Capacitate Placa Video (GB)`),]
newDf <- newDf[- grep("Drive", newDf$`Capacitate Placa Video (GB)`),]
newDf <- newDf[- grep("Max-Q", newDf$`Capacitate Placa Video (GB)`),]

# View(newDf)

write.xlsx(newDf,"LaptopuriExcelFinal.xlsx",sheetName = "Sheet1",col.names = TRUE)



