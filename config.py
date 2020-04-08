import os

# give time to download map tiles
SLEEP_SEC = 5.0

# csv output delimiter
DELIM = ','
HEADER_COLUMNS = ('place', 'url', 'scrape_time', 'day_of_week', 'hour_of_day', 'popularity_percent_normal', 'popularity_percent_current')

# path to chrome and chromedriver
CHROME_BINARY_LOCATION = 'PATH_TO_CHROME_APP/Contents/MacOS/Google Chrome'
CHROMEDRIVER_BINARY_LOCATION = 'PATH_TO_CHROMEDRIVER'

# keep an cache of the source htmls, with a timestamp in the filename
# if so, they should be cleaned out once in a while, since they are 1MB each
SAVE_HTML = True

# put your url or path here to a csv where the first column is a google maps url
# google sheets - export as csv https://stackoverflow.com/a/33727897/2327328
#URL_PATH_INPUT = None
URL_PATH_INPUT = 'urls' + os.sep + 'urls.csv'

DEBUG = False
URL_PATH_INPUT_TEST = 'urls' + os.sep + 'test.csv'