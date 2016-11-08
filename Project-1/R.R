setwd ("/Users/vivek/Documents/MS/Data Mining/Project 1")
data <- read.csv("Dallas_Police_Public_Data_-_RMS_Incidents-With_GeoLocation.csv")
#' Change to the folder with the file (use Session tab or setwd)

dim(data)
summary(data)

#' # Start creating a new "clean" data frame
data_clean <- data[, c("IncidentNum","PCClass","Premise","StrName", "City", "ZipCode", "Division","GeoLocation", "Date1", "Year1", "Month1", "Day1","Time1",	"Date1DayOfYear","CallReceived","CompName", "CompRace","CompAgeAtOffenseTime","CompSex", "Status",  "UCROffDesc" , "Gang", "Drug")]
summary(data_clean)
data_clean3 <- data_clean[!duplicated(data_clean$IncidentNum),]
#' # Here are some examples:
#'
#'
#' ## Fix dates/time
head(data_clean$ReportedDate)


#install.packages("lubridate", dependencies = TRUE)
install.packages("lubridate")
library(lubridate)

d <- parse_date_time(as.character(data_clean$ReportedDate), "%m/%d/%Y %H:%M:%S", tz = ":US/Central")
#d <- parse_date_time(as.character(data_clean$ReportedDate), "%m/%d/%Y %H:%M:%S", tz = "CST")
# Note: use tz = ":US/Central" on Macs with OS X

head(d)
hour(d[1:5])
day(d[1:5])
month(d[1:5])

# put new data back into the data.frame
data_clean3$ReportedDate <- d

# example of adding time
d[1]
d[1] + hours(18)


#' # Fix nominal variables
summary(data_clean)
data_clean$ZipCode <- as.factor(data_clean$ZipCode)
data_clean$Beat <- as.factor(data_clean$Beat)
summary(data_clean)

#' # Fix geolocation
gl <- as.character(data_clean$GeoLocation)
start <- regexpr("\\(", gl)
end <- regexpr("\\)", gl)
gl <- substr(gl, start+1, end-1)
#gl[gl==""] <- "NA, NA"
gl <- strsplit(gl, ", ")
lon <- sapply(gl, FUN = function(x) as.numeric(x[1]))
lat <- sapply(gl, FUN = function(x) as.numeric(x[2]))
data_clean$lon <- lon
data_clean$lat <- lat
data_clean$GeoLocation <- NULL # remove

summary(data_clean)

#' # Save clean data
save(data_clean, file = "data_clean.rda")

#' now we can always load the cleaned data with
load("data_clean.rda")
#' # Save in excel


install.packages('rJava', type='source')
library("rJava")
  
.jinit()
#install rjava, xlsx, xlsxjars
library(xlsx)
#write.xlsx(data_clean3, "/Users/vivek/Documents/MS/Data Mining/Project 1/mydata.xlsx")
write.csv(data_clean3, "/Users/vivek/Documents/MS/Data Mining/Project 1/new.csv")


#fixing the city variable
data_clean3$City[data_clean3$City == ""] <- NA
data_clean3$City[data_clean3$City == "D"] <- "DALLAS"
data_clean3$City[data_clean3$City == "DAL"] <- "DALLAS"
data_clean3$City[data_clean3$City == "DALAS"] <- "DALLAS"
data_clean3$City[data_clean3$City == "Dallas"] <- "DALLAS"

data_clean3$City <- factor(data_clean3$City)
summary(data_clean3)

