# Interactive heatmap-barchat with R/highcharts


## Introduction

This document describes the procedure to create an interactive a heatmap-barchart ("heatbar"??). A screenshot below, interactive examples of such graphic can be seen here:



This chart is fully created in R, by leveraging [highcharts](http://www.highcharts.com) (javacript charting library) from R. It takes only about a dozen lines of R code to create such interactive chart. 

If you are already proficient with javacript, such as with [d3](http://d3js.org) or [Highcharts](http://www.highcharts.com) (not my case), there is probably not much to gain for you from this tutorial. 

But if you mainly know R and wishes to create such an interactive chart, please read on :-)

## About the graphic type
The live example shows all Swiss people's initiatives, each square being a ballot colored based on the % of yes votes. So on one hand, it is a bar/column chart showing the number of ballots over the years. On the other hand, it is a heatmap with each ballot being colored according to the % of yes. 

The interactivity with a tooltip showing the title of each ballot is a nice explorative feature.

So technically, this graphic is simply a heatmap coerced into a column chart. One could achieve something similar with an interactive dot chart. 


## Create the chart

### Getting started

You will need to have installed the R package [rCharts](http://rcharts.io), a wonderful wrapper for multiple javascript charting libraries. For that you need devtools installed. In R

```R
install.packages("devtools")
require(devtools)
install_github('rCharts', 'ramnathv')
library(rCharts)

# Load the data file
data <- read.csv("citizenIniatives_ch.csv", stringsAsFactors = F)
```


### Reshape the data

The data file contains just 3 columns: the date of each vote, the % of yes and the title of the vote. To create a heatmap we will aggregate all the votes by year (x dimension) and count the number of votes each year (y dimension).

```
# Get only the year from each date (not an elegant solution here, better to use date)
data$year <- as.numeric(substr(data$date,1, 4))

# add the count of the observations (initiatives) per year. The count starts at 0 each year
data <- do.call(rbind, by(data, data$year, function(dd) cbind(dd, n = as.numeric(0:(nrow(dd)-1)))))
rownames(data) <- NULL
```

One can usually easily create an interactive chart with a oneliner in rCharts. 
However to create a heatmap, the procedure is slighty more complicated since the current version of rCharts 0.4.5 does not include the heatmap extensions yet.

The extra steps for a heatmap means that you need to have variables named: 'x', 'y' and 'value'. If you wish to have a text description for each of your data point, a variable 'name' is needed.

```
# change the names of the data.frame to be highcharts friendly
colnames(data) <- c('date', 'name', 'value', 'x', 'y')
```



```
# Create a new highchart instance
a <- Highcharts$new()
a$chart(zoomType = "xy", type = 'heatmap', width = 1000)
# Pass the data as JSON 
a$series(name = "", data =  rCharts::toJSONArray2(data, json = F, names = T))
```


Also a legal note about Highcharts, it is free for non-commercial usage. Please refer to its [licence](http://www.highcharts.com/products/highcharts/#non-commercia) for commercial usage.


### Credits
* The workaround to create an interactive Highcharts heatmap in R with rCharts comes from [Stefan Wilhelm](http://stefan-wilhelm.net/interactive-highcharts-heat-maps-in-r-with-rcharts/)
* The aweseome [rCharts](http://rcharts.io) by [Ramnath Vaidyanathan](https://github.com/ramnathv)
* Highcharts










