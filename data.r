library(lubridate)
library(mongolite)
library(shinyWidgets)
library(tidyverse)
library(plyr)
library(dplyr)
date = sample(seq(as.Date('2016/01/01'), as.Date('2019/01/20'), by="day"), 2000,replace = T)
businesspartner = sample(c("Phil_Customer","HCL_Customer","Google_customer","no partner"),2000,replace = T)
store = sample(c("Manila-1","Manila-2","Calamba-1","Calamba-2","Cebu","Davao","Makati","Quezon","Baguio"),2000,replace = T)
loyalty = sample(c("Platinum","Gold","Silver","Bronze","no level"),2000,replace = T)
customer_id =round(runif(2000, min=111231, max=111360)) 

products =sample(c("sun flower oil",
                   "chilli powder",
                   "besan",
                   "urad dal",
                   "suji ravva",
                   "toor dal",
                   "raw peanuts",
                   "poha",
                   "Soap",
                   "detergent",
                   "refined sugar",
                   "chana dal",
                   "brown sugar",
                   "ghee",
                   "salt",
                   "pink salt",
                   "bathroom cleaner",
                   "musquito repelant",
                   "fabric liquid",
                   "floor cleaner",
                   "steel scrub",
                   "dhoop sticks",
                   "phenyl",
                   "milk",
                   "cream biscuit",
                   "air freshner",
                   "pooja oil",
                   "kitchen towels",
                   "Pestiscide spray",
                   "instant noodles",
                   "tissue"),2000,replace = T)

arules = data.frame(products,date,businesspartner,store,loyalty,customer_id)
arules$month = months(arules$date)
arules$year = year(arules$date)
arules$weekday = weekdays(as.Date(arules$date))

b =toJSON( arules,pretty = FALSE, force = FALSE)

mongo <- mongo(collection = "data", db = "hello", url = "mongodb://localhost",
               verbose = TRUE)

mongo$insert(fromJSON(b))








