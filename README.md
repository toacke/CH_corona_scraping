# Project about the effects of the Covid outbreak in Switzerland

-----
## What does this repository provide:

- [x] scraper for google popular times
- [x] R files that were used to further aggregate the data
- [x] Data that can be used for replications of the [App](url_for_the_app_shinyapps.tio)
- [x] Report of the workflow that was used

-----

This project is about scrapping google's popular times from public transportation, gas stations at highways and grocery shops in switzerland.

## Data scraping
First, we like to thank [Philip Shemella](https://github.com/philshem/gmaps_popular_times_scraper) - you need to read this, otherwise the scripts won't run! - for his work and the scraper he built that we modified and used for collecting data. Since our script is built on his initial imputs, we will not explain here some dependencies already explained in Philip's repository.

As you can find every information on running the scraper in his GitHub repository we will focus on our work here:

The main scripts that we focus on is a_scraper.py that will scrap all urls defined in the /urls/*.csv and will make one file in the folder /data_average. 
This data can be used as baseline to plot current popularity against. 

The output looks as followed:
```
place,url,scrape_time,day_of_week,hour_of_day,popularity_percent_normal,
AnRYn1F8NfSGLexf7,https://goo.gl/maps/AnRYn1F8NfSGLexf7,20200318_163629,Wednesday,13,38,
AnRYn1F8NfSGLexf7,https://goo.gl/maps/AnRYn1F8NfSGLexf7,20200318_163629,Wednesday,14,45,
AnRYn1F8NfSGLexf7,https://goo.gl/maps/AnRYn1F8NfSGLexf7,20200318_163629,Wednesday,15,61,
AnRYn1F8NfSGLexf7,https://goo.gl/maps/AnRYn1F8NfSGLexf7,20200318_163629,Wednesday,16,79,
AnRYn1F8NfSGLexf7,https://goo.gl/maps/AnRYn1F8NfSGLexf7,20200318_163629,Wednesday,17,90,
AnRYn1F8NfSGLexf7,https://goo.gl/maps/AnRYn1F8NfSGLexf7,20200318_163629,Wednesday,18,88,
```

We recommend to run this script prior to the following.

The second script, c_scarper.py will do similar stuff but will write one file each time it goes in to scraping.
The file then contains the url, date-time, average and current frequencies. 
As the current frequency are only reported for the moment the file accesses google, this file contains only one line - the line that meets the hour of scrapping if - and only if there is current frequency. 
Otherwise the file will be deleted. 


Data in csv format is saved to `data/`. 

The output looks as followed:
```
place,url,scrape_time,day_of_week,hour_of_day,popularity_percent_normal,percent_current
AnRYn1F8NfSGLexf7,https://goo.gl/maps/AnRYn1F8NfSGLexf7,20200318_163629,Wednesday,16,79,30
```

To collapse the data in one file you can either use one of these solutions: 
You can use the code ([csv2sql.py](https://raw.githubusercontent.com/philshem/gmaps_popular_times_scraper/master/csv2sql.py)) to convert to a SQLite3 database. 
Or this in the [command line](https://stackoverflow.com/a/40922632/2327328)

    awk 'FNR==NR||FNR>1' data/*.csv > all.csv

But as we run in to that problem, the 'awk' is not working with a lot of files (>3000)


## Urls 
For scraping we rely on urls that were both scraped using chrome extension 'Simple scraper' and gathered manually by looking up places in google maps and copy the shortened urls in to the .csv that then will be used by the scraper. 
For our project we took two samples so far:

1. Public transport stations in Switzerland. The goal is to monitor traffic during the outbreak and compare frequencies depending on the measures taken by the government.
2. A list of stores was scraped via R from "Migros" and "Coop" - the two largest grocery-store chains in Switzerland. For each grocery-store chain we selected a stratified random sample selecting a number of stores per each canton (6 when it was possible, otherwise 3). The aim here is to display how the coronavirus influence Swiss people's consumption patterns.


## Scraping initialisation

Here comes the code that will allow for hourly running the scrapper.
That will be run in the terminal.

	cd /Folder/where/your/cod lies

	crontab -e 
	
	#Press i to inset code
	
	0 * * * * cd /Folder/with/script/in/it && /usr/bin/python3  name_of_file.py
	
    #0 * * * * – sets the timer that the code will be run each hour at 00 Minutes.

if you do not know where the python3 module is located just type in the terminal

	which python3
	
	#Press Esc to exit code and insert :wq afterwards

So now the crontab should have your command saved to check this insert:
	
	crontab -l
	
The following shows what processes are running at the moment: 

	ps -ef | grep cron | grep -v grep

As mentioned above, there will be a lot of files in /data. Thus, it is recommended to also crontab an other command that automatically -

- does the awk
- combines the newly created .csv with an older one, already containing data
- deletes the files in /data, /html and /logs



## Data visualisation

For the data visualisation we used R.
Initially we grab the longitude and latitude positions of the places related to the urls by running long_lat.py.
Then we prepared the data.

The visualisations were done in R with ggplot and at a later stage then implemented in a shiny-app.






