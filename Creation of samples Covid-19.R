############################################################
#
#
# Giorgio Cassina & Tobias Ackermann
# Covid 19 - Opendata project
# Vizualisation of data - Graphs
# Spring 2020 
#
#
############################################################

setwd(dirname(file.choose()))
library(openxlsx)
library(dplyr)

#### Upload and prepare the data (got them from: https://www.coop.ch/it/azienda/ubicazioni-e-orari-d-apertura.retail.html, https://filialen.migros.ch/it/filter:markets-[super.voi.mp]/center:46.8182,8.2275/zoom:8) ####
migros <- read.csv('MIGROS.csv')
coop <- read.csv('COOP.csv')
cop1 <- read.csv('cop1.csv')
cop2 <- read.csv('cop2.csv')
cop3 <- read.csv('cop3.csv')
cop4 <- read.csv('cop4.csv')
cop5 <- read.csv('cop5.csv')

# Combine different scraper to get one dataframe about COOPs
coop<-rbind(coop,cop1,cop2,cop3,cop4,cop5)
coop <-coop %>% distinct(propertyName1, propertyName2, propertyName3, propertyName4, .keep_all = TRUE)

# Rename the variables
colnames(coop)[colnames(coop) == 'propertyName1'] <- 'name'
colnames(coop)[colnames(coop) == 'propertyName2'] <- 'adress'
colnames(coop)[colnames(coop) == 'propertyName3'] <- 'cap'
colnames(coop)[colnames(coop) == 'propertyName4'] <- 'place'
colnames(migros)[colnames(migros) == 'propertyName1'] <- 'name'
coop[] <- lapply(coop, as.character)
migros[] <- lapply(migros, as.character)

i<-1
for (i in 1:length(migros$propertyName2)) {
migros$adress[i] <- unlist(strsplit(migros$propertyName2[i], ","))[1]
migros$cap[i] <- unlist(strsplit(unlist(strsplit(migros$propertyName2[i], ", "))[2]," "))[1]
migros$place[i] <- unlist(strsplit(unlist(strsplit(migros$propertyName2[i], ", "))[2]," "))[2]
}
migros$propertyName2 <- NULL

#### Create the sample stations and Rastätte ####

# FFS station (first draft and then additional stations were added manually)

FFS<-data.frame(URL=c('https://goo.gl/maps/dnj2Pit8isTxcKC16','https://goo.gl/maps/bSAXwV3VyY5zYnUA6','https://goo.gl/maps/5NhppGmiXNdYMVV39','https://goo.gl/maps/FkTSEEwCyhgnLXVQA','https://goo.gl/maps/aUN99FiVhqJGFyhA6','https://goo.gl/maps/FxYCjiZAtDKj8Ef5A','https://goo.gl/maps/pGj7cEbdHoSZ1D1U7','https://goo.gl/maps/YCnn99jfRfdzEjfH6','https://goo.gl/maps/Vn1ucGX9E8NKBF8c7','https://goo.gl/maps/dJwjgtTnANHjNZ3q8','https://goo.gl/maps/wgnEZ5QDmAoZRTZJ7','https://goo.gl/maps/nFUBxjxYab8C47P36','https://goo.gl/maps/W7caJFwG85GgzPxe9','https://goo.gl/maps/czaAHu2NKNQUYpqC8','https://goo.gl/maps/TcZLKPWDG6cZvJPa6','https://goo.gl/maps/s1kFH4YTqP8UEw1h7','https://goo.gl/maps/sUf6oSSbn8TGPcQRA','https://goo.gl/maps/9BMk8rfubhbdB5JX9','https://goo.gl/maps/nSxs5cQKi2285tFA6','https://goo.gl/maps/vosKQPjVrLwvoUd38','https://goo.gl/maps/aE1BqscHivsb1MAn6','https://goo.gl/maps/z43P7ZQZSetjQMY2A','https://goo.gl/maps/QMQwBuiVLwC2QeR46','https://goo.gl/maps/GLZWoYVQrEGZp8d47','https://goo.gl/maps/mpJ1b9K4hR9FCxSx8','https://goo.gl/maps/oFVV5nocQPcc22HC9','https://goo.gl/maps/s3BKdGHdJxFqaQAG9','https://goo.gl/maps/pFq5EcvCFmAp9vGw9'),
                  Name=c('Chur FFS','Winterthur FFS','Wil FFS','Romanshorn FFS','Luzern FFS','Zug FFS','Zürich Oerlikon FFS','Aarau FFS','Basel FFS','Delémont FFS','Solothurn FFS','Biel/Bienne FFS','Genève FFS','Chiasso FFS','Bellinzona FFS','Lugano FFS','Landquart FFS','Baden FFS','Oensingen FFS','Murten/Morat FFS','Saint-Maurice FFS','Langenthal FFS','Lyss FFS','Payerne FFS','Le Locle FFS','Sierre FFS','Gampel-Steg FFS','Palézieux FFS'))

#write.csv(FFS,'FFS.csv')

# Private mobility: highway service areas (search in google maps for (only first 40):'area di servizio vicino a Svizzera', 'raststätte, svizzera', 'aire de service suisse')

highway <- data.frame(URL=c('https://goo.gl/maps/fn7N9x4ZVpPYieK16','https://goo.gl/maps/a6XzUwbjVYnfrxFR7','https://goo.gl/maps/fyuQteguxythucrp7','https://goo.gl/maps/v73Jbh4EYtURsjFn9','https://goo.gl/maps/fGtbSTZTsv2g3ue18','https://goo.gl/maps/aPhETgw93Mdtcz8Y7','https://goo.gl/maps/oVME2G2q1FDNHG2j6','https://goo.gl/maps/WEbh1dBv2VUVsJh97','https://goo.gl/maps/UqCsMMV98bxB2SwT9','https://goo.gl/maps/SMCacWyvx6TN22vv6','https://goo.gl/maps/kNzpszCtTwdCy3Fx6','https://goo.gl/maps/ubfCpgsZivbJaNp8A','https://goo.gl/maps/CKQDxF7dWwLpcd7w9','https://goo.gl/maps/52aBySFKMiDDCwnG8','https://g.page/Forrenberg?share','https://goo.gl/maps/wToSr68BB7rbfj3t5','https://goo.gl/maps/ZbqmiexPuwWgQda28','https://goo.gl/maps/AFojHhkg7RSsdnpbA','https://goo.gl/maps/HZCqFeHrJaa2xeqt7','https://goo.gl/maps/PPdkCocwWgs1X5a6A','https://goo.gl/maps/nQXgsHKjtdCAoXpi9','https://g.page/Lurag?share','https://goo.gl/maps/X2VZjxcTQoE8DWoh7','https://goo.gl/maps/6fYmw1AA27Pbm9rF7','https://goo.gl/maps/GTGBkh1rWS4Df6DR8','https://goo.gl/maps/CekcyE8JuaxZYSpH8','https://goo.gl/maps/23uEcw4ciLjfhTSq5','https://goo.gl/maps/iQdYrqamLzDsxUua9','https://goo.gl/maps/pdBRjehB9mJcuPWR6','https://goo.gl/maps/iDLZPCkoi48XQLJQ6','https://goo.gl/maps/h3mwvocM9BjqLauT7','https://g.page/R-Imbiss?share','https://goo.gl/maps/QS5EKigfoheB1jSV9','https://goo.gl/maps/W7s8nNMcRticVZyj6','https://goo.gl/maps/CuZoFe8n324J8FYs9','https://goo.gl/maps/8LQS4j8j2iBdWRsw5'),
                      Name=c('Area di servizio autostradale Coldrerio Nord-Sud - Porta Ticino Easy Stop SA','Ristorante Area di servizio Ambrì-Piotta','Area di servizio autostradale San Gottardo Sud - Stalvedro Easy Stop SA','Area di servizio autostradale Coldrerio Sud-Nord - Porta Ticino Easy Stop SA','Shell Monte Carasso','Autogrill Aran-Villette','Aire de repos La Tuffière','Aire de repos Chamoson / Ardon','Aire de Repos Crans-près-Céligny (Jura)','Aire de repos Cime de l Est','Aire De Repos Crans-près-Céligny (Lac)','Aire de Repos Le Pertit','Gotthard Raststätte Fahrtrichtung Nord','Raststätte Autogrill Pratteln','Raststätte Forrenberg Nord','Autogrill Raststätte Münsingen Ost','Autobahn-Raststätte St. Margrethen','Viamala Raststätte Thusis AG','Raststätte Knonaueramt AG','Autobahnraststätte Gunzgen Nord','Raststätte Glarnerland AG','Lurag Luzerner Raststätten AG','Raststätte Kemptthal','Raststätte Grauholz','Rest Station Rheintal West Restaurant','Raststätte Rheintal Ost','Raststätte Thurau Süd','Raststätte Pratteln-Nord','Raststätte Neuenkirch','Raststätte Kölliken-Süd','Raststätte Gunzgen Süd','R-Imbiss Raststätte Hurst-Nord','Raststätte Grauholz Süd','Raststätte Pieterlen','Restoroute de Bavois S.A.','Aire de repos La Côte'))
#write.csv(highway,'highway.csv')

# combine data stations and Rastätte
mobility <- rbind(FFS,highway)

#write.xlsx(mobility, "mobility.xlsx")

#### Create the MIGORS sample ####

# Getting the PLZ 
chplz<-read.csv('CH_summary.csv', sep = ',') # unique values of PLZ from BFS data: https://www.bfs.admin.ch/bfs/de/home/grundlagen/agvch/gwr-korrespondenztabelle.html

# Filter for cantons with at least 6 MIGROS
filterchplz <- chplz[!chplz$cantone%in%c('AI','GL','JU','OW','UR'),]
cha<-tapply(chplz$PLZ4, chplz$cantone, FUN=unique)
filtercha<-tapply(filterchplz$PLZ4, filterchplz$cantone, FUN=unique)
filtercha[sapply(filtercha, is.null)] <- NULL

# Filter for cantons with less than 6 MIGROS
filterchplzsmall <- chplz[chplz$cantone%in%c('AI','GL','JU','OW','UR'),]
filterchasmall<-tapply(filterchplzsmall$PLZ4, filterchplzsmall$cantone, FUN=unique)
filterchasmall[sapply(filterchasmall, is.null)] <- NULL

# Select 6 random MIGROS for each canton
filterche<-list()
fh<-1
for (fh in 1:21) {
  #set.seed(1234)
  filterche[[fh]]<-sample(migros[migros$cap%in%filtercha[[fh]], 'name'], size=6)
}

# Create MIGROS sample with 6 shops per canton
migrossample<- migros[migros$name%in%unlist(filterche),]

#Select 3 MIGROS for the other cantons
filterchesmall<-list()
fhsm<-1
for (fhsm in 1:5) {
  #set.seed(1234)
  filterchesmall[[fhsm]]<-sample(migros[migros$cap%in%filterchasmall[[fhsm]], 'name'], size=3)
}

# Create MIGROS sample with 3 shops per remaining cantons
migrossamplesmall<- migros[migros$name%in%unlist(filterchesmall),]

# Final MIGROS sample
migrossel <- rbind(migrossample, migrossamplesmall)
#write.xlsx(migrossel, "migrossel.xlsx")

#### Create the COOP sample ####
# Filter for cantons with lat least 6 COOPs
coopchplz <- chplz[!chplz$cantone%in%c('AI','GL'),]
coopcha<-tapply(coopchplz$PLZ4, coopchplz$cantone, FUN=unique)
coopcha[sapply(coopcha, is.null)] <- NULL

# Filter for cantons with less than 6 COOPs
coopchplzsmall <- chplz[chplz$cantone%in%c('AI','GL'),]
coopchasmall<-tapply(coopchplzsmall$PLZ4, coopchplzsmall$cantone, FUN=unique)
coopchasmall[sapply(coopchasmall, is.null)] <- NULL

# Select 6 random COOPs for each canton
cche<-list()
hc<-1
for (hc in 1:24) {
  #set.seed(1234)
  cche[[hc]]<-sample(coop[coop$cap%in%coopcha[[hc]], 'name'], size=6)
}

# Create COOPs sample with 6 shops per canton
coopsample<- coop[coop$name%in%unlist(cche),]

#Select 3 COOPs for the other cantons
fcche<-list()
k<-1
for (k in 1:2) {
  #set.seed(1234)
  fcche[[k]]<-sample(coop[coop$cap%in%coopchasmall[[k]], 'name'], size=3)
}

# Create COOPs sample with 3 shops per remaining cantons
coopsamplesmall<- coop[coop$name%in%unlist(fcche),]

# Final COOPs sample
cooprossel <- rbind(coopsample, coopsamplesmall)
#write.xlsx(cooprossel, "cooprossel.xlsx")
