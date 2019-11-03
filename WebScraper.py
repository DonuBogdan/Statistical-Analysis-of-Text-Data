from bs4 import BeautifulSoup
import requests
import pandas as pd
import os

# here we will add all laptops
records = []
# number of page
pageIndex = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]

for i in pageIndex:
    # take source code of a web page
    # e.g: https://www.emag.ro/laptopuri/p2/c
    # e.g: https://www.emag.ro/laptopuri/p3/c
    url = 'https://www.emag.ro/laptopuri/p' + str(i) + '/c'
    source = requests.get(url).text
    # print(source)

    # parsing the text into html format
    soup = BeautifulSoup(source, "html.parser")

    # here we take each object (laptop) and save it in a list 
    results = soup.find_all('div', attrs = {'class': 'card-item js-product-data'})

    for result in results:
        diff_infos = result.get('data-name')
        new_price = result.find('p', attrs = {'class': 'product-new-price'}).text
        old_price = result.find('p', attrs = {'class': 'product-old-price'}).text
        nr_of_reviews = result.find('span', attrs = {'class': 'hidden-xs'}).text
        rating = result.find('div', attrs = {'class': 'star-rating-inner'}).get('style')
        try:
            availability = result.find('p', attrs = {'class': 'product-stock-status text-availability-in_stock'}).text
        except:
            availability = 'ultimul produs in stoc'
        
        records.append((diff_infos, new_price, old_price, nr_of_reviews, rating, availability))

df = pd.DataFrame(records, columns = ['diff_infos', 'new_price', 'old_price', 'nr_of_reviews', 'rating', 'availability'])

# export the df in a csv file
os.chdir('D:/MASTER/AN_2/Sem 1/NLP')
df.to_csv('emag_Laptopuri.csv', index = False, encoding = 'cp1252')






