#!/usr/bin/env python


import pandas as pd
import requests
import csv
from numpy import array

import config

def main():
    data = []
    fin = []
    urls = pd.read_csv(config.URL_PATH_INPUT_TEST, sep=';')
    url_list = urls.iloc[:, 0].tolist()
    for url in url_list:
        short = url
        print(url)
        part = unshorten_url(url)
        # print(dx)
        slash = str(part).split('/')
        a = array(slash)
        if a.shape[0] == 8:

            location = slash[5]
            long = slash[6].split(',')[0].replace('@', '')
            lat = slash[6].split(',')[1]
            line = (location + "," + long + "," + lat + "," + short)
            fin.append(line)
        else:
            print(slash)
    print('ATTENTION: LOOK IN THE .CSV - THERE MIGHT BE AN URL THAT HAS ONE ORE MORE SEMICOLONS IN IT - REMOVE THEM')
    with open("long_lat_out.csv", "w") as f:
        wr = csv.writer(f, delimiter="\n")
        wr.writerow(fin)


def unshorten_url(url):
    return requests.head(url, allow_redirects=True).url


if __name__ == '__main__':
    main()
