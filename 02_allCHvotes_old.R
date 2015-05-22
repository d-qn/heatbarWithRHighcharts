library("swiTheme")
library("swiRcharts")
library("dplyr")

############################################################################################
###		SETTINGS
############################################################################################

# download the raw file without footer!!!
votefile <- "data/VOTES_allCH.csv"

# PLOT SETTINGS
plot.height <- 400
outputDir <- "graphics"

if(!file.exists(outputDir)) {
	dir.create(outputDir)
}

############################################################################################
###		load initiative data
############################################################################################

votes.read <- read.csv(votefile, check.names = F, stringsAsFactors = F, encoding = "latin1")
# reverse order
votes.read <- votes.read[rev(as.numeric(rownames(votes.read))),]

#### create new column with vote type (3 types)
### the different vote types
# referendum obligatoire, referendum facultatif, initiative populaire, contre-projet de l'assemblée fédérale, see http://www.bfs.admin.ch/bfs/portal/fr/index/themen/17/03/blank/key/eidg__volksinitiativen.html
# unique(votes.read$Institutions)

type <- rep('', nrow(votes.read))
idx.subset <- grep('initiative',votes.read$Institutions, ignore.case = T)
type[idx.subset] <- 'initiative'
idx.subset <- grep('(Constitutional|Mandatory).*Referendum',votes.read$Institutions, ignore.case = T)
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


# filter columns
votes <- votes.read %>% select(`Date of Votes`, `type`, `Title in English`, `Title in German`, `Title in French`, `Title in Italien`, `Yes [%]`, `Theme codes`, `Result`)
# transform date to date
votes$date <- as.Date(votes$`Date of Votes`)

votes$year <- as.numeric(substr(votes$`Date of Votes`,1, 4))
# add counter iniitiative per year
votes <- do.call(rbind, by(votes, list(votes$year, votes$type), function(ii) {
	cbind(ii, n = as.numeric(0:(nrow(ii)-1)))
}))

############################################################################################
###		Plot each vote type and translations language
############################################################################################

trad <- read.csv("allCH_ballots - translations.tsv", sep ="\t", row.names = 1, stringsAsFactors = F)

# votetype <- levels(votes$type)[2]
# lang <- 'fr'

for(votetype in levels(votes$type)) {

	for(lang in colnames(trad)) {

		#### Perform language specifc operations
		typeShort <- gsub(" ", "", votetype)
		tmpOuputfile <- paste0(outputDir, "/", typeShort, ".html")
		output.html <- paste0(typeShort, "_", lang, "_heatmap.html")

		# Define which vote colname to use
		col.subset <- c( switch(lang,
			fr = "Title in English",
			en = "Title in English",
			de = "Title in German",
			it = "Title in Italian",
			"Title in English"
		), c('year', 'n',  'Yes [%]', 'Result'))

		# filter votes data
		data <- votes %>% filter(type == votetype) %>% select(one_of(col.subset))

		# Perform vote type specific stuff
		# heatmap colors
		color0.5 <- '#ADC2C2'
		color1 <- '#336666'
		if(typeShort == 'faculativeReferendum') {
			color0.5 <- '#C2C2D1'
			color1 <- '#333366'
		}
		if(typeShort == 'mandatoryReferendum') {
			color0.5 <- '#D1D1C2'
			color1 <- '#666633'
		}

		# rename data for highcharts
		colnames(data) <- c('name', 'x', 'y', 'value', 'result')
		# add HTML break for name longer than given threshold
		data$name <- gsub('(.{1,50})(\\s|$)', '\\1\\<br\\>', data$name)

		a <- Highcharts$new()
		# use type='heatmap' for heat maps
		a$chart(zoomType = "xy", type = 'heatmap', height = plot.height, plotBackgroundColor = "#f7f5ed", spacing = 5)
		a$series(hSeries2(data, "result"))

		a$addParams(colorAxis =
		  list(min = 0, max = 100, stops = list(
			  list(0, '#ab3d3f'),
		      list(0.499, '#EED8D9'),
		      list(0.5, color0.5),
		      list(1, color1)
		  ))
		)

		a$legend(align='center',
		         layout='horizontal',
		         margin=-42,
				 width = 100,
		         verticalAlign='top',
		         symbolHeight=5
				 )

		a$xAxis(min = min(data$x), max = max(data$x), ceiling = max(data$x), maxPadding = 0, tickAmount = 2,title = list(text = ""))
		a$yAxis(min = min(data$y), max = max(data$y),
			maxPadding = 0, lineWidth = 0, minorGridLineWidth = 0, lineColor = 'transparent', title = list(text = ""),
			labels = list(enabled = FALSE), minorTickLength = 0, tickLength =  0, gridLineWidth =  0, minorGridLineWidth = 0)

		# formatter <- "#! function() { return '<div class=\"tooltip\" style=\"color:#686868;font-size:0.8em\">In <b>' + this.point.x + ',</b> the initative:<br><i>' +
		# 	this.point.name + '</i>gathered <b>' + this.point.value + '%</b> of yes</div>'; } !#"
		formatter <- paste0("#! function() { return '<div class=\"tooltip\" style=\"color:#686868;font-size:0.8em\">",
			trad[eval(paste("tp", "In", sep = ".")), lang], " <b>'+ this.point.x + ',</b> ", gsub("'", " ", trad[eval(paste("tp", typeShort, sep = ".")),lang]),
			 ":<br><br><i>' + this.point.name + '</i><br>", trad[eval(paste("tp", "yield", sep = ".")),lang], " <b>' + this.point.value + '%</b> ",
			  trad[eval(paste("tp", "ofyes", sep = ".")),lang], "</div>'; } !#")

		a$tooltip(formatter = formatter, useHTML = T, borderWidth = 2, backgroundColor = 'rgba(255,255,255,0.8)')

		a$addAssets(c("https://code.highcharts.com/modules/heatmap.js"))
		a$save(destfile = tmpOuputfile)
		a

		yRange <- paste(range(data$x), collapse = "-")

		hChart2responsiveHTML(tmpOuputfile, output.html = output.html, output = outputDir, h2 = trad[eval(paste("title", typeShort, sep = ".")),lang],
		descr = paste0(trad[eval(paste("descr1", typeShort, sep = ".")),lang], " ", yRange, trad[eval(paste("descr2", typeShort, sep = ".")),lang]),
			source = trad["source",lang], h3 = "", author = 'Duc-Quang Nguyen | <a href = "http://www.swissinfo.ch">swissinfo.ch</a>')
		browseURL(file.path(outputDir, output.html))
	} # end loop language

} # end loop votetype

############################################################################################
###		KEYWORDS ANALYSIS
############################################################################################





