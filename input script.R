library(magrittr)
library(dplyr)
library(ggplot2).
library(tidyr)

data <- read.csv("raw_db", col.names = c('id', 
                                         'timestamp', 
                                         'title', 
                                         'school', 
                                         'department', 
                                         'administrator', 
                                         'author', 
                                         'state', 
                                         'city', 
                                         'latitude', 
                                         'logitude', 
                                         'link', 
                                         'published_date', 
                                         'tags', 
                                         'abstract', 
                                         'text')
                          , stringsAsFactors = F)

