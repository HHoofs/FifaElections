require(googleVis)
require(stringr)

UEFA <- read.csv("UEFA.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
UEFA$V1 <- "UEFA"

AFC  <- read.csv("AFC.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
AFC$V1 <- "AFC"

CAF  <- read.csv("CAF.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
CAF$V1 <- "CAF"

OFC  <- read.csv("OFC.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
OFC$V1 <- "OFC"

CONCACAF  <- read.csv("CONCACAF.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
CONCACAF$V1 <- "CONCACAF"

CONMEBOL  <- read.csv("CONMEBOL.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
CONMEBOL$V1 <- "CONMEBOL"

FIFA <- rbind(UEFA,AFC,CAF,OFC,CONCACAF,CONMEBOL)[,-ncol(UEFA)]

names(FIFA) <- c("Conf","Rank","Country","TotalPoints","Previous Points","Imp","Positions","Avg15","AVGWGT15","Avg14","AVGWGT14","Avg13","AVGWGT13","Avg12","AVGWGT12")

CPI <- read.csv("CPI.csv",sep=";",header = TRUE, skip = 2,stringsAsFactors = FALSE)

# names(CPI)[2] <- "Country"

names(CPI) <- c("CountryRank1","Country","WBcode","Region","CountryRank2","CPIscore0","Surveys","SE",
                "Lower","Upper","MIN","MAX","AFDB","BF_SGI","BF_BTI","IMD","ICRG","WB","WEF","WJP","EIU","GI","PERC","FH")

CPI <- rbind(CPI,NA)



FIFA_CPI <- merge(x = FIFA, y = CPI, by = "Country", all.x = TRUE)

head(FIFA_CPI)

FIFA_CPI[is.na(FIFA_CPI$X.2),"Country"]

FIFA_CPI[str_detect(FIFA_CPI$Country,paste(paste("\\<",c('American Samoa','Andorra','Anguilla','Antigua and Barbuda','Aruba','Belize','Bermuda','British Virgin Islands',
                                             'Brunei Darussalam','Cape Verde Islands','Cayman Islands','China PR','Chinese Taipei','Congo','Congo DR','Cook Islands','Curaçao',
                                             'England','Equatorial Guinea','Faroe Islands','Fiji','FYR Macedonia','Grenada','Guam','Korea DPR','Korea Republic','Liechtenstein',
                                             'Macau','Maldives','Montserrat','New Caledonia','Northern Ireland','Palestine','Republic of Ireland','San Marino',
                                             'São Tomé e Príncipe','Scotland','Solomon Islands','St. Kitts and Nevis','St. Lucia','St. Vincent and the Grenadines',
                                             'Tahiti','Tonga','Turks and Caicos Islands','US Virgin Islands','USA','Vanuatu','Wales'),"\\>",sep=""),collapse="|")),
         c(which(str_detect(names(FIFA_CPI),"WBcode")):ncol(FIFA_CPI))] <-
  
  CPI[c(176, #'American Samoa',
        176, #'Andorra',
        176, #'Anguilla',
        176, #'Antigua and Barbuda',
        176, #'Aruba',
        176, #'Belize',
        176, #'Bermuda',
        176, #'British Virgin Islands',
        176, #'Brunei Darussalam',
        176, #'Cape Verde Islands',
        176, #'Cayman Islands',
        which(str_detect(CPI$Country,"China")), #'China PR',
        176, #'Chinese Taipei',
        which(str_detect(CPI$Country,"Congo Republic")), #'Congo',
        which(str_detect(CPI$Country,"Democratic Republic of the Congo")), #'Congo DR',
        176, #'Cook Islands',
        176, #'Curaçao',
        which(str_detect(CPI$Country,"United Kingdom")), #'England',
        176, #'Equatorial Guinea',
        176, #'Faroe Islands',
        176, #'Fiji',
        which(str_detect(CPI$Country,"The FYR of Macedonia")), #'FYR Macedonia',
        176, #'Grenada',
        176, #'Guam',
        which(str_detect(CPI$Country,"Korea [(]North[)]")), #'Korea DPR',
        which(str_detect(CPI$Country,"Korea [(]South[)]")), #'Korea Republic',
        176, #'Liechtenstein',
        176, #'Macau',
        176, #'Maldives',
        176, #'Montserrat',
        176, #'New Caledonia',
        which(str_detect(CPI$Country,"United Kingdom")), #'Northern Ireland',
        176, #'Palestine',
        which(str_detect(CPI$Country,"Ireland")), #'Republic of Ireland',
        176, #'San Marino',
        176, #'São Tomé e Príncipe',
        which(str_detect(CPI$Country,"United Kingdom")), #'Scotland',
        176, #'Solomon Islands',
        176, #'St. Kitts and Nevis',
        176, #'St. Lucia',
        176, #'St. Vincent and the Grenadines',
        176, #'Tahiti',
        176, #'Tonga',
        176, #'Turks and Caicos Islands',
        176, #'US Virgin Islands',
        which(str_detect(CPI$Country,"United States")), #'USA',
        176, #'Vanuatu',
        which(str_detect(CPI$Country,"United Kingdom")) #'Wales'
        ),c(which(str_detect(names(CPI),"WBcode")):ncol(CPI))]


head(FIFA_CPI)

FIFA_CPI$Points <- as.numeric(unlist(lapply(str_split(FIFA_CPI$TotalPoints,"[(]"),function(x) x[[1]])))



FIFA_CPI[,c("Country","CPIscore0","Points")]

FIFA_CPI$wCPI <- (FIFA_CPI$CPIscore0 - range( FIFA_CPI$CPIscore0,na.rm=TRUE)[1]) / ((range( FIFA_CPI$CPIscore0,na.rm=TRUE)[2] - range( FIFA_CPI$CPIscore0,na.rm=TRUE)[1] ) /50)

for(i in 1:length(unique(FIFA_CPI$Conf))){
  FIFA_CPI$wCPI[is.na(FIFA_CPI$wCPI) & FIFA_CPI$Conf == unique(FIFA_CPI$Conf)[i]] <- mean(FIFA_CPI$wCPI[FIFA_CPI$Conf == unique(FIFA_CPI$Conf)[i]],na.rm=TRUE)
}

FIFA_CPI$wFIFA <- (FIFA_CPI$Points - range( FIFA_CPI$Points,na.rm=TRUE)[1]) / ((range( FIFA_CPI$Points,na.rm=TRUE)[2] - range( FIFA_CPI$Points,na.rm=TRUE)[1] ) /50)


FIFA_CPI$vWeight <- FIFA_CPI$wCPI + FIFA_CPI$wFIFA 


uefaCountr <- sort(UEFA$V3)

for(i in 1:length(sort(UEFA$V3))){
  cat(paste('checkboxInput("',uefaCountr[i],'", "',uefaCountr[i],'",FALSE),',sep=""))
  cat("\n")
}

for(i in 1:length(sort(UEFA$V3))){
  cat(paste('if(input$',gsub(" ","",uefaCountr[i]),') FIFA_CPI[FIFA_CPI$Country == "',uefaCountr[i],'","vote"] <- 1',sep=""))
  cat("\n")
}



afcCountr <- sort(AFC$V3)

for(i in 1:length(sort(afcCountr))){
  cat(paste('checkboxInput("',afcCountr[i],'", "',afcCountr[i],'",FALSE),',sep=""))
  cat("\n")
}

for(i in 1:length(sort(afcCountr))){
  cat(paste('if(input$',gsub(" ","",afcCountr[i]),') FIFA_CPI[FIFA_CPI$Country == "',afcCountr[i],'","vote"] <- 1',sep=""))
  cat("\n")
}


cafCountr <- sort(CAF$V3)

for(i in 1:length(sort(cafCountr))){
  cat(paste('checkboxInput("',cafCountr[i],'", "',cafCountr[i],'",FALSE),',sep=""))
  cat("\n")
}

for(i in 1:length(sort(cafCountr))){
  cat(paste('if(input$',gsub(" ","",cafCountr[i]),') FIFA_CPI[FIFA_CPI$Country == "',cafCountr[i],'","vote"] <- 1',sep=""))
  cat("\n")
}

concacafCountr <- sort(CONCACAF$V3)

for(i in 1:length(sort(concacafCountr))){
  cat(paste('checkboxInput("',concacafCountr[i],'", "',concacafCountr[i],'",FALSE),',sep=""))
  cat("\n")
}

for(i in 1:length(sort(concacafCountr))){
  cat(paste('if(input$',gsub(" ","",concacafCountr[i]),') FIFA_CPI[FIFA_CPI$Country == "',concacafCountr[i],'","vote"] <- 1',sep=""))
  cat("\n")
}

conmebolCountr <- sort(CONMEBOL$V3)

for(i in 1:length(sort(conmebolCountr))){
  cat(paste('checkboxInput("',conmebolCountr[i],'", "',conmebolCountr[i],'",FALSE),',sep=""))
  cat("\n")
}

for(i in 1:length(sort(conmebolCountr))){
  cat(paste('if(input$',gsub(" ","",conmebolCountr[i]),') FIFA_CPI[FIFA_CPI$Country == "',conmebolCountr[i],'","vote"] <- 1',sep=""))
  cat("\n")
}


ofcCountr <- sort(OFC$V3)

for(i in 1:length(sort(ofcCountr))){
  cat(paste('checkboxInput("',ofcCountr[i],'", "',ofcCountr[i],'",FALSE),',sep=""))
  cat("\n")
}

for(i in 1:length(sort(ofcCountr))){
  cat(paste('if(input$',gsub(" ","",ofcCountr[i]),') FIFA_CPI[FIFA_CPI$Country == "',ofcCountr[i],'","vote"] <- 1',sep=""))
  cat("\n")
}