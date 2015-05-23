library(rCharts)

### CREDITS
# http://stefan-wilhelm.net/interactive-highcharts-heat-maps-in-r-with-rcharts/

### Load the data file
data <- read.csv("citizenIniatives_ch.csv", stringsAsFactors = F)

### Get only the year from each date (not an elegant solution here, better to use date)
data$year <- as.numeric(substr(data$date,1, 4))

# add the count of the observations (initiatives) per year. The count starts at 0 each year
data <- do.call(rbind, by(data, data$year, function(dd) cbind(dd, n = as.numeric(0:(nrow(dd)-1)))))
rownames(data) <- NULL

# change the names of the data.frame to be highcharts friendly
colnames(data) <- c('date', 'name', 'value', 'x', 'y')


### PLOT
a <- Highcharts$new()
a$chart(zoomType = "xy", type = 'heatmap', width = 1000)
# Pass the data as JSON
a$series(name = "", data =  rCharts::toJSONArray2(data, json = F, names = T))


# Define the color scale
a$addParams(colorAxis = list(min = 0, max = 100, stops = list(list(0, '#ab3d3f'), list(0.499, '#EED8D9'),list(0.5, '#ADC2C2'),list(1, '#336666'))))
a$yAxis(lineWidth = 0, minorGridLineWidth = 0, lineColor = 'transparent', title = list(text = ""),
	labels = list(enabled = FALSE), minorTickLength = 0, tickLength =  0, gridLineWidth =  0, minorGridLineWidth = 0)

a$addAssets(js = c("https://code.highcharts.com/modules/heatmap.js"))
a


# formatter <- "#! function() { return '<div class=\"tooltip\" style=\"color:#686868;font-size:0.8em\">In <b>' + this.point.x + ',</b> the initative:<br><i>' +
# 	this.point.name + '</i>gathered <b>' + this.point.value + '%</b> of yes</div>'; } !#"

# formatter <- paste0("#! function() { return '<div class=\"tooltip\" style=\"color:#686868;font-size:0.8em\">",
# 	trad[eval(paste("tp", "In", sep = ".")), lang], " <b>'+ this.point.x + ',</b> ", gsub("'", " ", trad[eval(paste("tp", typeShort, sep = ".")),lang]),
# 	 ":<br><br><i>' + this.point.name + '</i><br>", trad[eval(paste("tp", "yield", sep = ".")),lang], " <b>' + this.point.value + '%</b> ",
# 	  trad[eval(paste("tp", "ofyes", sep = ".")),lang], "</div>'; } !#")
#
# a$tooltip(formatter = formatter, useHTML = T, borderWidth = 2, backgroundColor = 'rgba(255,255,255,0.8)')


a









		# rename data for highcharts
		colnames(data) <- c('name', 'x', 'y', 'value')
		# add HTML break for name longer than given threshold
		data$name <- gsub('(.{1,50})(\\s|$)', '\\1\\<br\\>', data$name)




