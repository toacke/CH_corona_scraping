############################################################
#
#
# Giorgio Cassina & Tobias Ackermann
# Covid 19 - Opendata project
# Vizualisation of data on maps
# Spring 2020 
#
#
############################################################
#SETTINGS####
rm(list = ls())
setwd(dirname(file.choose()))
#lib <- c("ggplot2","ggswissmaps","dplyr")
#install.packages(lib)
library(ggplot2)
library(ggswissmaps)
library(purrr)
library(stats)
#LOADING THE MAPS####
#for additional information on the package ggswissmaps look at:
#vignette("ggswissmaps_intro", package = "ggswissmaps")


#COORDINATES #####
city <- read.csv("long_lat_out.csv")
names(city) <- c("City","lat", "long", "URL")
city$group <- as.integer(runif(126, min=1, max=26))
city$long <- city$long*10000 #cause bring them to format
city$lat <- city$lat*10000 #cause bring them to format
#coordinate longitude: (w-e)
test <- city$long
test <- test+d[1]+(6.699034*(test-o[1]))
#6.699034 is approximately the factor that was used to scale the coordinates of the maps$long
range(test)
city$long <- test
#coordinateslatitude (s-n)
test <- city$lat
test <- test+d[1] +(9.577713*(test-o[1]))
#9.577713 is approximately the factor that was used to scale the coordinates of the maps$long
range(test)
city$lat <- test
#
city <- city[1:93,]# removing the gasstations (caus no long lat)

#add variable for matching from the overal data to the citys by using the url that was scrapped
setwd(paste0(getwd(),'/urls'))
url <- read.csv2('urls.csv')
names(url)[1] <- 'URL'
setwd('..')
#you have to know which urls did not work in long_lat.py to get rid of them!
# as there are only 3 i do it manually
url <- url[-c(109,116,126)] 
city <- merge(url, city, by = 'URL')
rm(list = c('url','o','r','d','test'))

#TRANSPORT DATA ####
library(dplyr)
transpall<-read.csv('all_transport.csv')
#data preparation
transpall$place <- as.character(transpall$place)
transpall$day_of_week <- as.character(transpall$day_of_week)
transpall$scrape_time <- as.character(transpall$scrape_time)
transpall$url <- as.character(transpall$url)

i<-1
for (i in 1:length(transpall$place)) {
  transpall$name[i] <- unlist(strsplit(transpall$place[i], "; "))[2]
}

i<-1
for (i in 1:length(transpall$place)) {
  transpall$date[i] <- unlist(strsplit(transpall$scrape_time[i], '_'))[1]
}
transpall$date <- as.integer(transpall$date)

transpall <- transpall %>% mutate(SBB = case_when(grepl('FFS', transpall$place) ~ 1,
                                                  grepl('SBB', transpall$place) ~ 1,
                                                  T ~ 0))
for(i in 1:length(transpall$url)){
  transpall$url[i] <- unlist(strsplit(as.character(transpall$url[i]), ';'))[1]
}
names(transpall)[2] <- "URL"
#attaching the datas
city <- merge(city, transpall, by = 'URL')
rm(list = c('i', 'transpall'))

#CALCULATIONS ####
city$diff <- city$popularity_percent_normal-city$popularity_percent_current
hist(city$diff)
save(city, file = "city.Rdata")

#TEST FOR AGGREGATED DATA ####
av_day <- city %>%
              group_by(URL, date) %>%
              summarise(Difference = as.numeric(mean(diff, na.rm = T)),
                        long = unique(long),
                        lat = unique(lat),
                        Name = unique(Name),
                        group = unique(group))

#MAPPING ####
# any df containing long, lat and group element

maping <- function(data){
  ggplot2::ggplot(data = data, ggplot2::aes(x = long, y = lat, group = group)) +
    ggplot2::geom_polygon() +
    ggplot2::theme_void() +
    coord_equal()
}
# now you caneasliy plot all the maps in shp_df
#purrr::map(ggswissmaps::shp_df, ~maping(.x))
#but saving data is more important
g1k15 <- shp_df[["g1k15"]]
g1s15 <- shp_df[["g1s15"]]
save(g1k15, file = "Kantone.Rdata")
save(g1s15, file = "Lakes.Rdata")
