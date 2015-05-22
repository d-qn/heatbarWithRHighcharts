############################################################################################
###		SETTINGS
############################################################################################

#### 1. From the google spreadsheet, download as csv!
votefile <- "../data/allCH_ballots - VOTES_allCH.csv"

############################################################################################
###		load initiative data
############################################################################################

votes.read <- read.csv(votefile, check.names = F, stringsAsFactors = F)
# reverse order
votes.read <- votes.read[rev(as.numeric(rownames(votes.read))),]

#### 2. Create new column with vote type (3 types)
### the different vote types
# referendum obligatoire, referendum facultatif, initiative populaire, contre-projet de l'assemblée fédérale, see http://www.bfs.admin.ch/bfs/portal/fr/index/themen/17/03/blank/key/eidg__volksinitiativen.html
# unique(votes.read$Institutions)

type <- rep('', nrow(votes.read))
idx.subset <- grep('^Initiative',votes.read$Institutions, ignore.case = F)
type[idx.subset] <- 'initiative'
idx.subset <- grep('(Constitutional|Mandatory).*(Referendum|Initiative)', votes.read$Institutions, ignore.case = T)
stopifnot(all(type[idx.subset] == ""))
type[idx.subset] <- 'mandatory Referendum'
idx.subset <- grep('Optional.*referendum',votes.read$Institutions, ignore.case = T)
stopifnot(all(type[idx.subset] == ""))
type[idx.subset] <- 'facultative Referendum'
if(any(type == "")) {
	votes.read[which(type == ""),]
	stop("some vote types are not defined !!!!!!!!!")
}
votes.read$type <- as.factor(type)

############################################################################################
###		subset only the iniatives and some columns
############################################################################################

library(dplyr)
initiatives <- votes.read %>% filter(type == "initiative") %>% select(one_of("Date of Votes", "eng", "Yes [%]"))
colnames(initiatives) <- c('date', 'name', 'yes')
initiatives$date <- as.Date(initiatives$date, format = "%d/%m/%Y")

write.csv(initiatives, file = "citizenIniatives_ch.csv", row.names = F)