#Quick CowVisit Analysis (QCVA-02-05-2025)
#Analysis requested by Dr. Efrén Ramirez-Bibriesca

#Credits ----------------------------------------------------------------------

#This code was written in February 5th, 2025 (02/05/2025)
#by José Eduardo Nieto Domínguez 
#(https://orcid.org/0009-0003-9136-1839)
#
#If you require any assistance in running it, or have any questions,
#please email me at: "nietodominguez.je@gmail.com"
#
#I will be happy to help, in spanish or english!
#
#P.S. Enjoy this ASCII Elegant Penguin!
#     __
#   _|_|_      Best regards!
#   ('v')             -JEND.
#  //-x-\\
#  (\_=_/)
#   ^^ ^^

#Working Directory ------------------------------------------------------------

#NOTE: Please update line 26 with the Working Directory you are going to use.
#For personal replicability, I am leaving my own local working directory here.

setwd("C:/Users/nieto/OneDrive/Documents/Investigación/Análisis de datos/Análisis_QCVA-02-05-2025")

#Libraries ---------------------------------------------------------------------

#NOTE: Remove these commented lines in case you don't have the libraries installed

#install.packages("tidyverse")
#install.packages("lubridate")
#install.packages("openxlsx")

#If you already have these libraries installed, procede without changing anything

library(tidyverse) #For data wrangling
library(lubridate) #To work with dates
library(openxlsx)  #To create the final Excel files (xlsx)


#Data frames -------------------------------------------------------------------

#load raw data from 130
rfids130 <- read.csv("rfids 130.csv") |>
  #convert ScanTime to POSIXct so we can work with times
  mutate(ScanTime = as.POSIXct(ScanTime, format = "%Y-%m-%d %H:%M:%S")) |>
  #Keep only the "In" values
  filter(InOrOut == "In")

#load raw data from 147
rfids147 <- read.csv("rfids 147.csv") |>
  #convert ScanTime to POSIXct so we can work with times
  mutate(ScanTime = as.POSIXct(ScanTime, format = "%Y-%m-%d %H:%M:%S")) |>
  #Keep only the "In" values
  filter(InOrOut == "In")

#Function to filter out data with a difference greater than 240 minutes --------

filter_time_diff <- function(data) {
  data <- data[order(data$ScanTime), ]
  keep <- c(TRUE, diff(data$ScanTime) > minutes(240))
  return(data[keep, ])
}

#Apply filter_time_diff to each CowTag in each data frame ----------------------

condensed_rfids130 <- rfids130 |>
  #Group the data frame using the CowTag values
  group_by(CowTag) |>
  #Apply the filter_time_diff function
  do(filter_time_diff(.)) |>
  ungroup() |>
  #Split the ScanTime column in two individual columns: Date and Time
  mutate(Date = as.Date(ScanTime),
         Time = format(as.POSIXct(ScanTime), "%H:%M:%S")) |>
  #Remove the ScanTime column
  select(-ScanTime)

condensed_rfids147 <- rfids147 |>
  #Group the data frame using the CowTag values
  group_by(CowTag) |>
  #Apply the filter_time_diff function
  do(filter_time_diff(.)) |>
  ungroup() |>
  #Split the ScanTime column in two individual columns: Date and Time
  mutate(Date = as.Date(ScanTime),
         Time = format(as.POSIXct(ScanTime), "%H:%M:%S")) |>
  #Remove the ScanTime column
  select(-ScanTime)

#Visit counting for each cow ---------------------------------------------------

visits130 <- condensed_rfids130 |>
  group_by(CowTag, Date) |>
  summarise(InCount = sum(InOrOut == "In")) |>
  ungroup()
    
visits147 <- condensed_rfids147 |>
  group_by(CowTag, Date) |>
  summarise(InCount = sum(InOrOut == "In")) |>
  ungroup()

#Save as Excel files -------------------------------------------------------

write.xlsx(visits130, "Visits130v4.xlsx")
write.xlsx(visits147, "Visits147v4.xlsx")

#Confirmation message ----------------------------------------------------------
cat("All done!\n")