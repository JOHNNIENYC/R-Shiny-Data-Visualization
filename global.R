library(shiny)
library(shinydashboard)
library(plotly)
library("readxl")
library(tidyverse)
library(googleVis)
library(DT)
library(dplyr)

state_data_2016 <- read_excel("state_M2016_dl.xlsx")
state_data_2017 <- read_excel("state_M2017_dl.xlsx")
state_data_2018 <- read_excel("state_M2018_dl.xlsx")
state_data_2019 <- read_excel("state_M2019_dl.xlsx")
state_data_2020 <- read_excel("state_M2020_dl.xlsx")


df_2016 <- state_data_2016 %>% select(., STATE, OCC_CODE, OCC_TITLE, OCC_GROUP, TOT_EMP, JOBS_1000, H_MEAN,
                                      A_MEAN, H_MEDIAN, A_MEDIAN) 
#summary(df_2016) check row number
vec2016 <- rep(c(2016), times = 37561)
df_2016$YEAR = vec2016

df_2017 <- state_data_2017 %>% select(., STATE, OCC_CODE, OCC_TITLE, OCC_GROUP, TOT_EMP, JOBS_1000, H_MEAN,
                                      A_MEAN, H_MEDIAN, A_MEDIAN) 
#add column "YEAR
vec2017 <- rep(c(2017), times = 36992)
df_2017$YEAR = vec2017

df_2018 <- state_data_2018 %>% select(., STATE, OCC_CODE, OCC_TITLE, OCC_GROUP, TOT_EMP, JOBS_1000, H_MEAN,
                                      A_MEAN, H_MEDIAN, A_MEDIAN) 
df_2018_ <- state_data_2018 %>% select(., ST, STATE, OCC_CODE, OCC_TITLE, OCC_GROUP, TOT_EMP, JOBS_1000, H_MEAN,
                                      A_MEAN, H_MEDIAN, A_MEDIAN) 
#add column "YEAR
vec2018 <- rep(c(2018), times = 36897)
df_2018$YEAR = vec2018

names(state_data_2019) <- toupper(names(state_data_2019))
df_2019 <-state_data_2019 %>% select(., AREA_TITLE, OCC_CODE, OCC_TITLE, O_GROUP, TOT_EMP, JOBS_1000,H_MEAN,
                                     A_MEAN, H_MEDIAN, A_MEDIAN) 
colnames(df_2019)[colnames(df_2019) == "AREA_TITLE"] <- "STATE"
colnames(df_2019)[colnames(df_2019) == "O_GROUP"] <- "OCC_GROUP"
#add column "YEAR
vec2019 <- rep(c(2019), times = 36382)
df_2019$YEAR = vec2019

names(state_data_2020) <- toupper(names(state_data_2020))
df_2020 <-state_data_2020 %>% select(., AREA_TITLE, OCC_CODE, OCC_TITLE, O_GROUP, TOT_EMP, JOBS_1000,H_MEAN,
                                     A_MEAN, H_MEDIAN, A_MEDIAN) 
colnames(df_2020)[colnames(df_2020) == "AREA_TITLE"] <- "STATE"
colnames(df_2020)[colnames(df_2020) == "O_GROUP"] <- "OCC_GROUP"
#add column "YEAR
vec2020 <- rep(c(2020), times = 36085)
df_2020$YEAR = vec2020

#consolidate the 5 separate data table

df_consolidate <- rbind(df_2016, df_2017, df_2018, df_2019, df_2020)

#convert salary data (character) into numeric number for calculation
df_consolidate$TOT_EMP <- as.numeric(df_consolidate$TOT_EMP)
df_consolidate$JOBS_1000 <-as.numeric(df_consolidate$JOBS_1000)
df_consolidate$H_MEAN <-as.numeric(df_consolidate$H_MEAN)
df_consolidate$A_MEAN <-as.numeric(df_consolidate$A_MEAN)
df_consolidate$H_MEDIAN <-as.numeric(df_consolidate$H_MEDIAN)
df_consolidate$A_MEDIAN <-as.numeric(df_consolidate$A_MEDIAN)

#remove missing value 
df_consolidate <- na.omit(df_consolidate)

df_consolidate$OCC_CODE <- str_sub(df_consolidate$OCC_CODE, 1,2) 


df_detailed_occupation_by_major <-df_consolidate %>% filter (., YEAR == "2016", OCC_GROUP == "detailed", STATE =="New York") 
df_major_occupatoin <-df_consolidate %>% filter (YEAR == "2016", OCC_GROUP == "major", STATE =="New York" )

df1 <- df_consolidate %>% select (.,STATE, OCC_CODE, OCC_TITLE, OCC_GROUP, YEAR ) %>% filter(.,STATE == "Alabama", OCC_GROUP == "major",YEAR == "2016")
df_major_test <- df1 %>% select(., OCC_CODE, OCC_TITLE) %>% rename (.,OCC_TYPE = OCC_TITLE)
df_join <- inner_join (df_major_test, df_consolidate, by = "OCC_CODE")
df_join_major <-df_join %>% filter(.,OCC_GROUP == "major")
