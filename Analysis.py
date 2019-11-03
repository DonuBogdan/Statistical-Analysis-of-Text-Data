# set working directory
import os
os.getcwd()
os.chdir("D:/Master/AN_2/Sem 1/NLP")

# read excel file
from pandas import read_excel
import pandas as pd
from scipy.stats import mode
import statistics
import numpy as np
import seaborn as sns

data = read_excel("LaptopuriExcelFinal.xlsx", "Sheet1")

# display the infos of the data
data.info()

# visualize data
data

#################################
###### Change data types. #######
#################################

data['Frecventa Procesor (GHz)'] = pd.to_numeric(data['Frecventa Procesor (GHz)'])
data['Dimensiune Ecran (inch.)'] = pd.to_numeric(data['Dimensiune Ecran (inch.)'])
data['Capacitate Memorie (GB)'] = pd.to_numeric(data['Capacitate Memorie (GB)'])
data['Capacitate Stocare (GB)'] = pd.to_numeric(data['Capacitate Stocare (GB)'])

# we need to change "-" into None's in order to be able to change the data type here
data['Capacitate Placa Video (GB)'] = data['Capacitate Placa Video (GB)'].replace(['-'], [None])
# None will be NaN now. 
# "NaN is used as a placeholder for missing data in pandas."
# I usually read/translate NaN as "missing"
data['Capacitate Placa Video (GB)'] = pd.to_numeric(data['Capacitate Placa Video (GB)'])

data['Pret Nou (Lei)'] = pd.to_numeric(data['Pret Nou (Lei)'])/100
data['Pret Vechi (Lei)'] = pd.to_numeric(data['Pret Vechi (Lei)'])/100

data['% Reducere'] = pd.to_numeric(data['% Reducere'])
data['nr_of_reviews'] = pd.to_numeric(data['nr_of_reviews'])
data['rating'] = pd.to_numeric(data['rating'])
 
# only the values are transformed into strings
# the column name will remain "object"
# that s why we have object as type
data['Denumire Laptop'] = data['Denumire Laptop'].astype(str)
data['Tip Procesor'] = data['Tip Procesor'].astype(str)
data['Generatie Procesor'] = data['Generatie Procesor'].astype(str)
data['Tip Stocare'] = data['Tip Stocare'].astype(str)
data['Tip Placa Video'] = data['Tip Placa Video'].astype(str)
data['Versiune Placa Video'] = data['Versiune Placa Video'].astype(str)
data['availability'] = data['availability'].astype(str)

data.info()

#################################
## Change name of the columns. ##
#################################

newColumnNamesVector = ["Denumire_Laptop", "Tip_Procesor", "Generatie_Procesor"
                          , "Frecventa_Procesor_(GHz)", "Dimensiune_Ecran_(inch.)", "Capacitate_Memorie_RAM_(GB)"
                          , "Capacitate_Stocare_(GB)", "Tip_Stocare", "Tip_Placa_Video", "Versiune_Placa_Video"
                          , "Capacitate_Placa_Video_(GB)", "Pret_Nou_(Lei)", "Pret_Vechi_(Lei)"
                          , "Procentaj_Reducere_(%)", "Numar_Recenzii", "Nota_Acordata", "Disponibilitate"]
data.columns = newColumnNamesVector

##################################
############ Analysis ############
##################################

# Descriptive statistic for each variable
descriptiveStatistic = data.describe()

################################
###### Numeric variables #######
################################

# Further on we will apply describe function on each numeric variable
d1 = data['Frecventa_Procesor_(GHz)'].describe()

d2 = data['Capacitate_Memorie_RAM_(GB)'].describe()

d4 = data['Pret_Nou_(Lei)'].describe()

d5 = data['Pret_Vechi_(Lei)'].describe()

d6 = data['Procentaj_Reducere_(%)'].describe()

d7 = data['Numar_Recenzii'].describe()

d8 = data['Nota_Acordata'].describe()

###############################################
#### Identify the mode of each numeric variable

print(mode(data['Frecventa_Procesor_(GHz)']))
print(mode(data['Capacitate_Memorie_RAM_(GB)']))
print(mode(data['Pret_Nou_(Lei)']))
print(mode(data['Pret_Vechi_(Lei)']))
print(mode(data['Procentaj_Reducere_(%)']))
print(mode(data['Numar_Recenzii']))
print(mode(data['Nota_Acordata']))

###############################################
#### Identify the mean of each numeric variable

print(statistics.mean(data['Frecventa_Procesor_(GHz)']))
print(statistics.mean(data['Capacitate_Memorie_RAM_(GB)']))
print(statistics.mean(data['Pret_Nou_(Lei)']))
print(statistics.mean(data['Pret_Vechi_(Lei)']))
print(statistics.mean(data['Procentaj_Reducere_(%)']))
print(statistics.mean(data['Numar_Recenzii']))
print(statistics.mean(data['Nota_Acordata']))

#################################################
#### Identify the median of each numeric variable

print(statistics.median(data['Frecventa_Procesor_(GHz)']))
print(statistics.median(data['Capacitate_Memorie_RAM_(GB)']))
print(statistics.median(data['Pret_Nou_(Lei)']))
print(statistics.median(data['Pret_Vechi_(Lei)']))
print(statistics.median(data['Procentaj_Reducere_(%)']))
print(statistics.median(data['Numar_Recenzii']))
print(statistics.median(data['Nota_Acordata']))

################################################
#### Identify the stdev of each numeric variable

print(statistics.stdev(data['Frecventa_Procesor_(GHz)']))
print(statistics.stdev(data['Capacitate_Memorie_RAM_(GB)']))
print(statistics.stdev(data['Pret_Nou_(Lei)']))
print(statistics.stdev(data['Pret_Vechi_(Lei)']))
print(statistics.stdev(data['Procentaj_Reducere_(%)']))
print(statistics.stdev(data['Numar_Recenzii']))
print(statistics.stdev(data['Nota_Acordata']))

#############
#### Outliers

### Discover the outliers for each numeric variable

###########

print(sns.boxplot('Frecventa_Procesor_(GHz)', data=data, whis = 1.75, width = 0.2))

###########

print(sns.boxplot('Capacitate_Memorie_RAM_(GB)', data=data, whis = 2, width = 0.2))

###########

print(sns.boxplot('Pret_Nou_(Lei)', data=data, whis = 1.75, width = 0.2))

###########

print(sns.boxplot('Pret_Vechi_(Lei)', data=data, whis = 1.75, width = 0.2))

###########

print(sns.boxplot('Procentaj_Reducere_(%)', data=data, width = 0.2))

###########

print(sns.boxplot('Numar_Recenzii', data=data, whis = 2, width = 0.2))

###########

print(sns.boxplot('Nota_Acordata', data=data, width = 0.2))





