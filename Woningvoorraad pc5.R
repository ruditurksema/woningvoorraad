# Woningvoorraad pc5  https://www.cbs.nl/nl-nl/maatwerk/2019/36/woningvoorraad-gemeente-wijk-buurt-en-pc5-2012-2019

library(readxl)
library(tidyverse)
library(tidylog)
library(tidyverse)
library(rgdal)
library(tmap)

# data

wv_2019 <- read_excel("Tabel C1 woningvoorraad 2019.xlsx")

# omrekenen naar pc4

wv_2019$pc4 <- as.factor(str_extract(wv_2019$PC5, "[0-9]{4}"))

wv_2019_pc4 <- wv_2019 %>%
  group_by(pc4) %>%
  summarise(woningvoorraad_pc4 = sum(Woningvoorraadsom, na.rm = T))

wv_2019_pc4 %>%
  ggplot(aes(woningvoorraad_pc4)) + geom_histogram() + theme_minimal()

# koppelen met cbs-data op pc4

pc4 <- readOGR(dsn = "~/Documents/R/Shapes/ESRI_PC4_kustlijn_2017R1-shp/ESRI_PC4_kustlijn_2017R1.shp")

pc4@data <- left_join(pc4@data, wv_2019_pc4, by = c('pc4' = 'pc4'))

pal2 <- c('#f1eef6','#bdc9e1','#74a9cf','#2b8cbe','#045a8d')

qtm(pc4, fill="woningvoorraad_pc4", fill.n = 5, fill.palette = pal2, fill.style = "quantile", borders = NULL,
    basemaps = c("CartoDB.Positron", "OpenStreetMap", "Esri.WorldTopoMap"),
    fill.title="Woningvoorraad per pc4 (2019, data: CBS)", 
    legend.text.size = .8, legend.title.size = .8) + tm_legend(legend.position = c("left", "top"))


