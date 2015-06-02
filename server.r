# Contributed by Joe Cheng, February 2013
# Requires googleVis version 0.4.0 and shiny 0.4.0 or higher
# server.R
library(googleVis)
library(shiny)
require(stringr)
# 
# UEFA <- read.csv("UEFA.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
# UEFA$V1 <- "UEFA"
# 
# AFC  <- read.csv("AFC.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
# AFC$V1 <- "AFC"
# 
# CAF  <- read.csv("CAF.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
# CAF$V1 <- "CAF"
# 
# OFC  <- read.csv("OFC.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
# OFC$V1 <- "OFC"
# 
# CONCACAF  <- read.csv("CONCACAF.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
# CONCACAF$V1 <- "CONCACAF"
# 
# CONMEBOL  <- read.csv("CONMEBOL.csv",sep=";",header = FALSE,stringsAsFactors = FALSE)
# CONMEBOL$V1 <- "CONMEBOL"
# 
# FIFA <- rbind(UEFA,AFC,CAF,OFC,CONCACAF,CONMEBOL)[,-ncol(UEFA)]
# 
# names(FIFA) <- c("Conf","Rank","Country","TotalPoints","Previous Points","Imp","Positions","Avg15","AVGWGT15","Avg14","AVGWGT14","Avg13","AVGWGT13","Avg12","AVGWGT12")
# 
# CPI <- read.csv("CPI.csv",sep=";",header = TRUE, skip = 2,stringsAsFactors = FALSE)
# 
# # names(CPI)[2] <- "Country"
# 
# names(CPI) <- c("CountryRank1","Country","WBcode","Region","CountryRank2","CPIscore0","Surveys","SE",
#                 "Lower","Upper","MIN","MAX","AFDB","BF_SGI","BF_BTI","IMD","ICRG","WB","WEF","WJP","EIU","GI","PERC","FH")
# 
# CPI <- rbind(CPI,NA)
# 
# 
# 
# FIFA_CPI <- merge(x = FIFA, y = CPI, by = "Country", all.x = TRUE)
# 
# # head(FIFA_CPI)
# 
# FIFA_CPI[str_detect(FIFA_CPI$Country,paste(paste("\\<",c('American Samoa','Andorra','Anguilla','Antigua and Barbuda','Aruba','Belize','Bermuda','British Virgin Islands',
#                                                          'Brunei Darussalam','Cape Verde Islands','Cayman Islands','China PR','Chinese Taipei','Congo','Congo DR','Cook Islands','Curaçao',
#                                                          'England','Equatorial Guinea','Faroe Islands','Fiji','FYR Macedonia','Grenada','Guam','Korea DPR','Korea Republic','Liechtenstein',
#                                                          'Macau','Maldives','Montserrat','New Caledonia','Northern Ireland','Palestine','Republic of Ireland','San Marino',
#                                                          'São Tomé e Príncipe','Scotland','Solomon Islands','St. Kitts and Nevis','St. Lucia','St. Vincent and the Grenadines',
#                                                          'Tahiti','Tonga','Turks and Caicos Islands','US Virgin Islands','USA','Vanuatu','Wales'),"\\>",sep=""),collapse="|")),
#          c(which(str_detect(names(FIFA_CPI),"WBcode")):ncol(FIFA_CPI))] <-
#   
#   CPI[c(176, #'American Samoa',
#         176, #'Andorra',
#         176, #'Anguilla',
#         176, #'Antigua and Barbuda',
#         176, #'Aruba',
#         176, #'Belize',
#         176, #'Bermuda',
#         176, #'British Virgin Islands',
#         176, #'Brunei Darussalam',
#         176, #'Cape Verde Islands',
#         176, #'Cayman Islands',
#         which(str_detect(CPI$Country,"China")), #'China PR',
#         176, #'Chinese Taipei',
#         which(str_detect(CPI$Country,"Congo Republic")), #'Congo',
#         which(str_detect(CPI$Country,"Democratic Republic of the Congo")), #'Congo DR',
#         176, #'Cook Islands',
#         176, #'Curaçao',
#         which(str_detect(CPI$Country,"United Kingdom")), #'England',
#         176, #'Equatorial Guinea',
#         176, #'Faroe Islands',
#         176, #'Fiji',
#         which(str_detect(CPI$Country,"The FYR of Macedonia")), #'FYR Macedonia',
#         176, #'Grenada',
#         176, #'Guam',
#         which(str_detect(CPI$Country,"Korea [(]North[)]")), #'Korea DPR',
#         which(str_detect(CPI$Country,"Korea [(]South[)]")), #'Korea Republic',
#         176, #'Liechtenstein',
#         176, #'Macau',
#         176, #'Maldives',
#         176, #'Montserrat',
#         176, #'New Caledonia',
#         which(str_detect(CPI$Country,"United Kingdom")), #'Northern Ireland',
#         176, #'Palestine',
#         which(str_detect(CPI$Country,"Ireland")), #'Republic of Ireland',
#         176, #'San Marino',
#         176, #'São Tomé e Príncipe',
#         which(str_detect(CPI$Country,"United Kingdom")), #'Scotland',
#         176, #'Solomon Islands',
#         176, #'St. Kitts and Nevis',
#         176, #'St. Lucia',
#         176, #'St. Vincent and the Grenadines',
#         176, #'Tahiti',
#         176, #'Tonga',
#         176, #'Turks and Caicos Islands',
#         176, #'US Virgin Islands',
#         which(str_detect(CPI$Country,"United States")), #'USA',
#         176, #'Vanuatu',
#         which(str_detect(CPI$Country,"United Kingdom")) #'Wales'
#   ),c(which(str_detect(names(CPI),"WBcode")):ncol(CPI))]
# 
# FIFA_CPI[str_detect(FIFA_CPI$Country,"Ivoi"),c(which(str_detect(names(FIFA_CPI),"WBcode")):ncol(FIFA_CPI))] <- 
#   CPI[which(str_detect(CPI$Country,"Ivoire")),c(which(str_detect(names(CPI),"WBcode")):ncol(CPI))]
# 
# # head(FIFA_CPI)
# 
# FIFA_CPI$Points <- as.numeric(unlist(lapply(str_split(FIFA_CPI$TotalPoints,"[(]"),function(x) x[[1]])))
# 
# FIFA_CPI$wCPI <- (FIFA_CPI$CPIscore0 - range( FIFA_CPI$CPIscore0,na.rm=TRUE)[1]) / ((range( FIFA_CPI$CPIscore0,na.rm=TRUE)[2] - range( FIFA_CPI$CPIscore0,na.rm=TRUE)[1] ) /50)
# 
# for(i in 1:length(unique(FIFA_CPI$Conf))){
#   FIFA_CPI$wCPI[is.na(FIFA_CPI$wCPI) & FIFA_CPI$Conf == unique(FIFA_CPI$Conf)[i]] <- mean(FIFA_CPI$wCPI[FIFA_CPI$Conf == unique(FIFA_CPI$Conf)[i]],na.rm=TRUE)
# }
# 
# FIFA_CPI$wFIFA <- (FIFA_CPI$Points - range( FIFA_CPI$Points,na.rm=TRUE)[1]) / ((range( FIFA_CPI$Points,na.rm=TRUE)[2] - range( FIFA_CPI$Points,na.rm=TRUE)[1] ) /50)
# 
# 
# FIFA_CPI$vWeight <- FIFA_CPI$wCPI + FIFA_CPI$wFIFA 
# 
# FIFA_CPI$vote <- -1
# 
# save(FIFA_CPI,file="FIFA_CPI.RData")
load("FIFA_CPI.RData")

# FIFA_CPI$wVote <- FIFA_CPI$vote * FIFA_CPI$vWeight


shinyServer(function(input, output) {
  
  datasetInput <- reactive({
    ## UEFA
    if(input$Albania) FIFA_CPI[FIFA_CPI$Country == "Albania","vote"] <- 1
    if(input$Andorra) FIFA_CPI[FIFA_CPI$Country == "Andorra","vote"] <- 1
    if(input$Armenia) FIFA_CPI[FIFA_CPI$Country == "Armenia","vote"] <- 1
    if(input$Austria) FIFA_CPI[FIFA_CPI$Country == "Austria","vote"] <- 1
    if(input$Azerbaijan) FIFA_CPI[FIFA_CPI$Country == "Azerbaijan","vote"] <- 1
    if(input$Belarus) FIFA_CPI[FIFA_CPI$Country == "Belarus","vote"] <- 1
    if(input$Belgium) FIFA_CPI[FIFA_CPI$Country == "Belgium","vote"] <- 1
    if(input$BosniaandHerzegovina) FIFA_CPI[FIFA_CPI$Country == "Bosnia and Herzegovina","vote"] <- 1
    if(input$Bulgaria) FIFA_CPI[FIFA_CPI$Country == "Bulgaria","vote"] <- 1
    if(input$Croatia) FIFA_CPI[FIFA_CPI$Country == "Croatia","vote"] <- 1
    if(input$Cyprus) FIFA_CPI[FIFA_CPI$Country == "Cyprus","vote"] <- 1
    if(input$CzechRepublic) FIFA_CPI[FIFA_CPI$Country == "Czech Republic","vote"] <- 1
    if(input$Denmark) FIFA_CPI[FIFA_CPI$Country == "Denmark","vote"] <- 1
    if(input$England) FIFA_CPI[FIFA_CPI$Country == "England","vote"] <- 1
    if(input$Estonia) FIFA_CPI[FIFA_CPI$Country == "Estonia","vote"] <- 1
    if(input$FaroeIslands) FIFA_CPI[FIFA_CPI$Country == "Faroe Islands","vote"] <- 1
    if(input$Finland) FIFA_CPI[FIFA_CPI$Country == "Finland","vote"] <- 1
    if(input$France) FIFA_CPI[FIFA_CPI$Country == "France","vote"] <- 1
    if(input$FYRMacedonia) FIFA_CPI[FIFA_CPI$Country == "FYR Macedonia","vote"] <- 1
    if(input$Georgia) FIFA_CPI[FIFA_CPI$Country == "Georgia","vote"] <- 1
    if(input$Germany) FIFA_CPI[FIFA_CPI$Country == "Germany","vote"] <- 1
    if(input$Greece) FIFA_CPI[FIFA_CPI$Country == "Greece","vote"] <- 1
    if(input$Hungary) FIFA_CPI[FIFA_CPI$Country == "Hungary","vote"] <- 1
    if(input$Iceland) FIFA_CPI[FIFA_CPI$Country == "Iceland","vote"] <- 1
    if(input$Israel) FIFA_CPI[FIFA_CPI$Country == "Israel","vote"] <- 1
    if(input$Italy) FIFA_CPI[FIFA_CPI$Country == "Italy","vote"] <- 1
    if(input$Kazakhstan) FIFA_CPI[FIFA_CPI$Country == "Kazakhstan","vote"] <- 1
    if(input$Latvia) FIFA_CPI[FIFA_CPI$Country == "Latvia","vote"] <- 1
    if(input$Liechtenstein) FIFA_CPI[FIFA_CPI$Country == "Liechtenstein","vote"] <- 1
    if(input$Lithuania) FIFA_CPI[FIFA_CPI$Country == "Lithuania","vote"] <- 1
    if(input$Luxembourg) FIFA_CPI[FIFA_CPI$Country == "Luxembourg","vote"] <- 1
    if(input$Malta) FIFA_CPI[FIFA_CPI$Country == "Malta","vote"] <- 1
    if(input$Moldova) FIFA_CPI[FIFA_CPI$Country == "Moldova","vote"] <- 1
    if(input$Montenegro) FIFA_CPI[FIFA_CPI$Country == "Montenegro","vote"] <- 1
    if(input$Netherlands) FIFA_CPI[FIFA_CPI$Country == "Netherlands","vote"] <- 1
    if(input$NorthernIreland) FIFA_CPI[FIFA_CPI$Country == "Northern Ireland","vote"] <- 1
    if(input$Norway) FIFA_CPI[FIFA_CPI$Country == "Norway","vote"] <- 1
    if(input$Poland) FIFA_CPI[FIFA_CPI$Country == "Poland","vote"] <- 1
    if(input$Portugal) FIFA_CPI[FIFA_CPI$Country == "Portugal","vote"] <- 1
    if(input$RepublicofIreland) FIFA_CPI[FIFA_CPI$Country == "Republic of Ireland","vote"] <- 1
    if(input$Romania) FIFA_CPI[FIFA_CPI$Country == "Romania","vote"] <- 1
    if(input$Russia) FIFA_CPI[FIFA_CPI$Country == "Russia","vote"] <- 1
    if(input$SanMarino) FIFA_CPI[FIFA_CPI$Country == "San Marino","vote"] <- 1
    if(input$Scotland) FIFA_CPI[FIFA_CPI$Country == "Scotland","vote"] <- 1
    if(input$Serbia) FIFA_CPI[FIFA_CPI$Country == "Serbia","vote"] <- 1
    if(input$Slovakia) FIFA_CPI[FIFA_CPI$Country == "Slovakia","vote"] <- 1
    if(input$Slovenia) FIFA_CPI[FIFA_CPI$Country == "Slovenia","vote"] <- 1
    if(input$Spain) FIFA_CPI[FIFA_CPI$Country == "Spain","vote"] <- 1
    if(input$Sweden) FIFA_CPI[FIFA_CPI$Country == "Sweden","vote"] <- 1
    if(input$Switzerland) FIFA_CPI[FIFA_CPI$Country == "Switzerland","vote"] <- 1
    if(input$Turkey) FIFA_CPI[FIFA_CPI$Country == "Turkey","vote"] <- 1
    if(input$Ukraine) FIFA_CPI[FIFA_CPI$Country == "Ukraine","vote"] <- 1
    if(input$Wales) FIFA_CPI[FIFA_CPI$Country == "Wales","vote"] <- 1 
    
    ##AFC
    if(input$Afghanistan) FIFA_CPI[FIFA_CPI$Country == "Afghanistan","vote"] <- 1
    if(input$Australia) FIFA_CPI[FIFA_CPI$Country == "Australia","vote"] <- 1
    if(input$Bahrain) FIFA_CPI[FIFA_CPI$Country == "Bahrain","vote"] <- 1
    if(input$Bangladesh) FIFA_CPI[FIFA_CPI$Country == "Bangladesh","vote"] <- 1
    if(input$Bhutan) FIFA_CPI[FIFA_CPI$Country == "Bhutan","vote"] <- 1
    if(input$BruneiDarussalam) FIFA_CPI[FIFA_CPI$Country == "Brunei Darussalam","vote"] <- 1
    if(input$Cambodia) FIFA_CPI[FIFA_CPI$Country == "Cambodia","vote"] <- 1
    if(input$ChinaPR) FIFA_CPI[FIFA_CPI$Country == "China PR","vote"] <- 1
    if(input$ChineseTaipei) FIFA_CPI[FIFA_CPI$Country == "Chinese Taipei","vote"] <- 1
    if(input$Guam) FIFA_CPI[FIFA_CPI$Country == "Guam","vote"] <- 1
    if(input$HongKong) FIFA_CPI[FIFA_CPI$Country == "Hong Kong","vote"] <- 1
    if(input$India) FIFA_CPI[FIFA_CPI$Country == "India","vote"] <- 1
    if(input$Indonesia) FIFA_CPI[FIFA_CPI$Country == "Indonesia","vote"] <- 1
    if(input$Iran) FIFA_CPI[FIFA_CPI$Country == "Iran","vote"] <- 1
    if(input$Iraq) FIFA_CPI[FIFA_CPI$Country == "Iraq","vote"] <- 1
    if(input$Japan) FIFA_CPI[FIFA_CPI$Country == "Japan","vote"] <- 1
    if(input$Jordan) FIFA_CPI[FIFA_CPI$Country == "Jordan","vote"] <- 1
    if(input$KoreaDPR) FIFA_CPI[FIFA_CPI$Country == "Korea DPR","vote"] <- 1
    if(input$KoreaRepublic) FIFA_CPI[FIFA_CPI$Country == "Korea Republic","vote"] <- 1
    if(input$Kuwait) FIFA_CPI[FIFA_CPI$Country == "Kuwait","vote"] <- 1
    if(input$Kyrgyzstan) FIFA_CPI[FIFA_CPI$Country == "Kyrgyzstan","vote"] <- 1
    if(input$Laos) FIFA_CPI[FIFA_CPI$Country == "Laos","vote"] <- 1
    if(input$Lebanon) FIFA_CPI[FIFA_CPI$Country == "Lebanon","vote"] <- 1
    if(input$Macau) FIFA_CPI[FIFA_CPI$Country == "Macau","vote"] <- 1
    if(input$Malaysia) FIFA_CPI[FIFA_CPI$Country == "Malaysia","vote"] <- 1
    if(input$Maldives) FIFA_CPI[FIFA_CPI$Country == "Maldives","vote"] <- 1
    if(input$Mongolia) FIFA_CPI[FIFA_CPI$Country == "Mongolia","vote"] <- 1
    if(input$Myanmar) FIFA_CPI[FIFA_CPI$Country == "Myanmar","vote"] <- 1
    if(input$Nepal) FIFA_CPI[FIFA_CPI$Country == "Nepal","vote"] <- 1
    if(input$Oman) FIFA_CPI[FIFA_CPI$Country == "Oman","vote"] <- 1
    if(input$Pakistan) FIFA_CPI[FIFA_CPI$Country == "Pakistan","vote"] <- 1
    if(input$Palestine) FIFA_CPI[FIFA_CPI$Country == "Palestine","vote"] <- 1
    if(input$Philippines) FIFA_CPI[FIFA_CPI$Country == "Philippines","vote"] <- 1
    if(input$Qatar) FIFA_CPI[FIFA_CPI$Country == "Qatar","vote"] <- 1
    if(input$SaudiArabia) FIFA_CPI[FIFA_CPI$Country == "Saudi Arabia","vote"] <- 1
    if(input$Singapore) FIFA_CPI[FIFA_CPI$Country == "Singapore","vote"] <- 1
    if(input$SriLanka) FIFA_CPI[FIFA_CPI$Country == "Sri Lanka","vote"] <- 1
    if(input$Syria) FIFA_CPI[FIFA_CPI$Country == "Syria","vote"] <- 1
    if(input$Tajikistan) FIFA_CPI[FIFA_CPI$Country == "Tajikistan","vote"] <- 1
    if(input$Thailand) FIFA_CPI[FIFA_CPI$Country == "Thailand","vote"] <- 1
    if(input$TimorLeste) FIFA_CPI[FIFA_CPI$Country == "Timor-Leste","vote"] <- 1
    if(input$Turkmenistan) FIFA_CPI[FIFA_CPI$Country == "Turkmenistan","vote"] <- 1
    if(input$UnitedArabEmirates) FIFA_CPI[FIFA_CPI$Country == "United Arab Emirates","vote"] <- 1
    if(input$Uzbekistan) FIFA_CPI[FIFA_CPI$Country == "Uzbekistan","vote"] <- 1
    if(input$Vietnam) FIFA_CPI[FIFA_CPI$Country == "Vietnam","vote"] <- 1
    if(input$Yemen) FIFA_CPI[FIFA_CPI$Country == "Yemen","vote"] <- 1
    
    ##CAF
    if(input$Algeria) FIFA_CPI[FIFA_CPI$Country == "Algeria","vote"] <- 1
    if(input$Angola) FIFA_CPI[FIFA_CPI$Country == "Angola","vote"] <- 1
    if(input$Benin) FIFA_CPI[FIFA_CPI$Country == "Benin","vote"] <- 1
    if(input$Botswana) FIFA_CPI[FIFA_CPI$Country == "Botswana","vote"] <- 1
    if(input$BurkinaFaso) FIFA_CPI[FIFA_CPI$Country == "Burkina Faso","vote"] <- 1
    if(input$Burundi) FIFA_CPI[FIFA_CPI$Country == "Burundi","vote"] <- 1
    if(input$Cameroon) FIFA_CPI[FIFA_CPI$Country == "Cameroon","vote"] <- 1
    if(input$CapeVerdeIslands) FIFA_CPI[FIFA_CPI$Country == "Cape Verde Islands","vote"] <- 1
    if(input$CentralAfricanRepublic) FIFA_CPI[FIFA_CPI$Country == "Central African Republic","vote"] <- 1
    if(input$Chad) FIFA_CPI[FIFA_CPI$Country == "Chad","vote"] <- 1
    if(input$Comoros) FIFA_CPI[FIFA_CPI$Country == "Comoros","vote"] <- 1
    if(input$Congo) FIFA_CPI[FIFA_CPI$Country == "Congo","vote"] <- 1
    if(input$CongoDR) FIFA_CPI[FIFA_CPI$Country == "Congo DR","vote"] <- 1
    if(input$CotedIvoire) FIFA_CPI[FIFA_CPI$Country == "Côte d'Ivoire","vote"] <- 1
    if(input$Djibouti) FIFA_CPI[FIFA_CPI$Country == "Djibouti","vote"] <- 1
    if(input$Egypt) FIFA_CPI[FIFA_CPI$Country == "Egypt","vote"] <- 1
    if(input$EquatorialGuinea) FIFA_CPI[FIFA_CPI$Country == "Equatorial Guinea","vote"] <- 1
    if(input$Eritrea) FIFA_CPI[FIFA_CPI$Country == "Eritrea","vote"] <- 1
    if(input$Ethiopia) FIFA_CPI[FIFA_CPI$Country == "Ethiopia","vote"] <- 1
    if(input$Gabon) FIFA_CPI[FIFA_CPI$Country == "Gabon","vote"] <- 1
    if(input$Gambia) FIFA_CPI[FIFA_CPI$Country == "Gambia","vote"] <- 1
    if(input$Ghana) FIFA_CPI[FIFA_CPI$Country == "Ghana","vote"] <- 1
    if(input$Guinea) FIFA_CPI[FIFA_CPI$Country == "Guinea","vote"] <- 1
    if(input$GuineaBissau) FIFA_CPI[FIFA_CPI$Country == "Guinea-Bissau","vote"] <- 1
    if(input$Kenya) FIFA_CPI[FIFA_CPI$Country == "Kenya","vote"] <- 1
    if(input$Lesotho) FIFA_CPI[FIFA_CPI$Country == "Lesotho","vote"] <- 1
    if(input$Liberia) FIFA_CPI[FIFA_CPI$Country == "Liberia","vote"] <- 1
    if(input$Libya) FIFA_CPI[FIFA_CPI$Country == "Libya","vote"] <- 1
    if(input$Madagascar) FIFA_CPI[FIFA_CPI$Country == "Madagascar","vote"] <- 1
    if(input$Malawi) FIFA_CPI[FIFA_CPI$Country == "Malawi","vote"] <- 1
    if(input$Mali) FIFA_CPI[FIFA_CPI$Country == "Mali","vote"] <- 1
    if(input$Mauritania) FIFA_CPI[FIFA_CPI$Country == "Mauritania","vote"] <- 1
    if(input$Mauritius) FIFA_CPI[FIFA_CPI$Country == "Mauritius","vote"] <- 1
    if(input$Morocco) FIFA_CPI[FIFA_CPI$Country == "Morocco","vote"] <- 1
    if(input$Mozambique) FIFA_CPI[FIFA_CPI$Country == "Mozambique","vote"] <- 1
    if(input$Namibia) FIFA_CPI[FIFA_CPI$Country == "Namibia","vote"] <- 1
    if(input$Niger) FIFA_CPI[FIFA_CPI$Country == "Niger","vote"] <- 1
    if(input$Nigeria) FIFA_CPI[FIFA_CPI$Country == "Nigeria","vote"] <- 1
    if(input$Rwanda) FIFA_CPI[FIFA_CPI$Country == "Rwanda","vote"] <- 1
    if(input$SaoTomeePrincipe) FIFA_CPI[FIFA_CPI$Country == "São Tomé e Príncipe","vote"] <- 1
    if(input$Senegal) FIFA_CPI[FIFA_CPI$Country == "Senegal","vote"] <- 1
    if(input$Seychelles) FIFA_CPI[FIFA_CPI$Country == "Seychelles","vote"] <- 1
    if(input$SierraLeone) FIFA_CPI[FIFA_CPI$Country == "Sierra Leone","vote"] <- 1
    if(input$Somalia) FIFA_CPI[FIFA_CPI$Country == "Somalia","vote"] <- 1
    if(input$SouthAfrica) FIFA_CPI[FIFA_CPI$Country == "South Africa","vote"] <- 1
    if(input$SouthSudan) FIFA_CPI[FIFA_CPI$Country == "South Sudan","vote"] <- 1
    if(input$Sudan) FIFA_CPI[FIFA_CPI$Country == "Sudan","vote"] <- 1
    if(input$Swaziland) FIFA_CPI[FIFA_CPI$Country == "Swaziland","vote"] <- 1
    if(input$Tanzania) FIFA_CPI[FIFA_CPI$Country == "Tanzania","vote"] <- 1
    if(input$Togo) FIFA_CPI[FIFA_CPI$Country == "Togo","vote"] <- 1
    if(input$Tunisia) FIFA_CPI[FIFA_CPI$Country == "Tunisia","vote"] <- 1
    if(input$Uganda) FIFA_CPI[FIFA_CPI$Country == "Uganda","vote"] <- 1
    if(input$Zambia) FIFA_CPI[FIFA_CPI$Country == "Zambia","vote"] <- 1
    if(input$Zimbabwe) FIFA_CPI[FIFA_CPI$Country == "Zimbabwe","vote"] <- 1
    
    ##CONCACAF
    if(input$Anguilla) FIFA_CPI[FIFA_CPI$Country == "Anguilla","vote"] <- 1
    if(input$AntiguaandBarbuda) FIFA_CPI[FIFA_CPI$Country == "Antigua and Barbuda","vote"] <- 1
    if(input$Aruba) FIFA_CPI[FIFA_CPI$Country == "Aruba","vote"] <- 1
    if(input$Bahamas) FIFA_CPI[FIFA_CPI$Country == "Bahamas","vote"] <- 1
    if(input$Barbados) FIFA_CPI[FIFA_CPI$Country == "Barbados","vote"] <- 1
    if(input$Belize) FIFA_CPI[FIFA_CPI$Country == "Belize","vote"] <- 1
    if(input$Bermuda) FIFA_CPI[FIFA_CPI$Country == "Bermuda","vote"] <- 1
    if(input$BritishVirginIslands) FIFA_CPI[FIFA_CPI$Country == "British Virgin Islands","vote"] <- 1
    if(input$Canada) FIFA_CPI[FIFA_CPI$Country == "Canada","vote"] <- 1
    if(input$CaymanIslands) FIFA_CPI[FIFA_CPI$Country == "Cayman Islands","vote"] <- 1
    if(input$CostaRica) FIFA_CPI[FIFA_CPI$Country == "Costa Rica","vote"] <- 1
    if(input$Cuba) FIFA_CPI[FIFA_CPI$Country == "Cuba","vote"] <- 1
    if(input$Curacao) FIFA_CPI[FIFA_CPI$Country == "Curaçao","vote"] <- 1
    if(input$Dominica) FIFA_CPI[FIFA_CPI$Country == "Dominica","vote"] <- 1
    if(input$DominicanRepublic) FIFA_CPI[FIFA_CPI$Country == "Dominican Republic","vote"] <- 1
    if(input$ElSalvador) FIFA_CPI[FIFA_CPI$Country == "El Salvador","vote"] <- 1
    if(input$Grenada) FIFA_CPI[FIFA_CPI$Country == "Grenada","vote"] <- 1
    if(input$Guatemala) FIFA_CPI[FIFA_CPI$Country == "Guatemala","vote"] <- 1
    if(input$Guyana) FIFA_CPI[FIFA_CPI$Country == "Guyana","vote"] <- 1
    if(input$Haiti) FIFA_CPI[FIFA_CPI$Country == "Haiti","vote"] <- 1
    if(input$Honduras) FIFA_CPI[FIFA_CPI$Country == "Honduras","vote"] <- 1
    if(input$Jamaica) FIFA_CPI[FIFA_CPI$Country == "Jamaica","vote"] <- 1
    if(input$Mexico) FIFA_CPI[FIFA_CPI$Country == "Mexico","vote"] <- 1
    if(input$Montserrat) FIFA_CPI[FIFA_CPI$Country == "Montserrat","vote"] <- 1
    if(input$Nicaragua) FIFA_CPI[FIFA_CPI$Country == "Nicaragua","vote"] <- 1
    if(input$Panama) FIFA_CPI[FIFA_CPI$Country == "Panama","vote"] <- 1
    if(input$PuertoRico) FIFA_CPI[FIFA_CPI$Country == "Puerto Rico","vote"] <- 1
    if(input$StKittsandNevis) FIFA_CPI[FIFA_CPI$Country == "St. Kitts and Nevis","vote"] <- 1
    if(input$StLucia) FIFA_CPI[FIFA_CPI$Country == "St. Lucia","vote"] <- 1
    if(input$StVincentandtheGrenadines) FIFA_CPI[FIFA_CPI$Country == "St. Vincent and the Grenadines","vote"] <- 1
    if(input$Suriname) FIFA_CPI[FIFA_CPI$Country == "Suriname","vote"] <- 1
    if(input$TrinidadandTobago) FIFA_CPI[FIFA_CPI$Country == "Trinidad and Tobago","vote"] <- 1
    if(input$TurksandCaicosIslands) FIFA_CPI[FIFA_CPI$Country == "Turks and Caicos Islands","vote"] <- 1
    if(input$USVirginIslands) FIFA_CPI[FIFA_CPI$Country == "US Virgin Islands","vote"] <- 1
    if(input$USA) FIFA_CPI[FIFA_CPI$Country == "USA","vote"] <- 1
    
    ##CONMEBOL
    if(input$Argentina) FIFA_CPI[FIFA_CPI$Country == "Argentina","vote"] <- 1
    if(input$Bolivia) FIFA_CPI[FIFA_CPI$Country == "Bolivia","vote"] <- 1
    if(input$Brazil) FIFA_CPI[FIFA_CPI$Country == "Brazil","vote"] <- 1
    if(input$Chile) FIFA_CPI[FIFA_CPI$Country == "Chile","vote"] <- 1
    if(input$Colombia) FIFA_CPI[FIFA_CPI$Country == "Colombia","vote"] <- 1
    if(input$Ecuador) FIFA_CPI[FIFA_CPI$Country == "Ecuador","vote"] <- 1
    if(input$Paraguay) FIFA_CPI[FIFA_CPI$Country == "Paraguay","vote"] <- 1
    if(input$Peru) FIFA_CPI[FIFA_CPI$Country == "Peru","vote"] <- 1
    if(input$Uruguay) FIFA_CPI[FIFA_CPI$Country == "Uruguay","vote"] <- 1
    if(input$Venezuela) FIFA_CPI[FIFA_CPI$Country == "Venezuela","vote"] <- 1
    
    ##OFC
    if(input$AmericanSamoa) FIFA_CPI[FIFA_CPI$Country == "American Samoa","vote"] <- 1
    if(input$CookIslands) FIFA_CPI[FIFA_CPI$Country == "Cook Islands","vote"] <- 1
    if(input$Fiji) FIFA_CPI[FIFA_CPI$Country == "Fiji","vote"] <- 1
    if(input$NewCaledonia) FIFA_CPI[FIFA_CPI$Country == "New Caledonia","vote"] <- 1
    if(input$NewZealand) FIFA_CPI[FIFA_CPI$Country == "New Zealand","vote"] <- 1
    if(input$PapuaNewGuinea) FIFA_CPI[FIFA_CPI$Country == "Papua New Guinea","vote"] <- 1
    if(input$Samoa) FIFA_CPI[FIFA_CPI$Country == "Samoa","vote"] <- 1
    if(input$SolomonIslands) FIFA_CPI[FIFA_CPI$Country == "Solomon Islands","vote"] <- 1
    if(input$Tahiti) FIFA_CPI[FIFA_CPI$Country == "Tahiti","vote"] <- 1
    if(input$Tonga) FIFA_CPI[FIFA_CPI$Country == "Tonga","vote"] <- 1
    if(input$Vanuatu) FIFA_CPI[FIFA_CPI$Country == "Vanuatu","vote"] <- 1
    
    FIFA_CPI$vWeight <- ((input$weight/100)*FIFA_CPI$wCPI)*2 + (((100-input$weight)/100)*FIFA_CPI$wFIFA)*2

    FIFA_CPI$wVote <- FIFA_CPI$vote * FIFA_CPI$vWeight
    FIFA_CPI
  })
  
  datageo <- reactive({
    Data_geo <- datasetInput()
    
    Data_geo <- rbind(Data_geo,NA)
    Data_geo[nrow(Data_geo),c("Country","vote")] <- c("United Kingdom",
                                                              sort(table(Data_geo[str_detect(Data_geo$Country,pattern = "England|Scotland|Wales|Northern"),"vote"]),decreasing=TRUE)[1])
    
    Data_geo[nrow(Data_geo),c("wVote")] <- mean(c(Data_geo[Data_geo$Country == "England","wVote"],
                                                  Data_geo[Data_geo$Country == "Scotland","wVote"],
                                                  Data_geo[Data_geo$Country == "Wales","wVote"],
                                                  Data_geo[Data_geo$Country == "Northern","wVote"]))
    
    Data_geo[Data_geo$Country == "China PR","Country"] <- "China"
    Data_geo[Data_geo$Country == "USA","Country"] <- "United States"
    Data_geo[Data_geo$Country == "Congo DR","Country"] <- "Democratic Republic of the Congo"
    Data_geo[Data_geo$Country == "Korea Republic","Country"] <- "South Korea"
    Data_geo[Data_geo$Country == "Korea DPR","Country"] <- "North Korea"
    Data_geo[Data_geo$Country == "Chinese Taipei","Country"] <- "Taiwan"

    Data_geo
  })
  
  output$gvis <- renderGvis({
    Data_geo <- datageo()
    
    selVar <- "vote"
    if(input$weigh) selVar <- "wVote"
    Optt <- "{values:[-1,0,1],colors:[\'red', \'white\', \'green']}"
    if(input$weigh) Optt <- "{values:[-100,0,100],colors:[\'red', \'white\', \'green']}"
    

    
    gvisGeoChart(Data_geo, locationvar="Country", 
                 colorvar=selVar,
                 options=list(width="100%",projection="kavrayskiy-vii",colorAxis=Optt))
  })
  
  output$bar <- renderGvis({
    Data_sel <- datasetInput()
    Data_bar <- data.frame(Candidate = c("Ali","Blatter"), Votes = c(nrow(subset(Data_sel,vote == 1)),nrow(subset(Data_sel,vote == -1))))
    
    if(input$weigh)  Data_bar <- data.frame(Candidate = c("Ali","Blatter"), Votes = c(sum(subset(Data_sel,vote == 1)$wVote),abs(sum(subset(Data_sel,vote == -1)$wVote))))
    
    gvisPieChart(Data_bar,options=list(slices="{0: {color: 'green'}, 1: {color: 'red'}}"))
  })
  
  output$dataout <- renderDataTable({
    data <- datageo()
    data <- data[,c("Country","Conf","vote","Points","CPIscore0","wFIFA","wCPI","vWeight","wVote")]
    names(data) <- c("Country","Confed.","Vote","FIFA.Ranking","CPI.Score","relative.FIFA.Ranking","relative.CPI.Score","Vote.Weight","Weighted.Vote")
    data <- subset(data, Country != "United Kingdom")
    data
  })
  
#   output$summary <- renderPrint({
#     dataset <- datageo()
#     dataset
#   })

})