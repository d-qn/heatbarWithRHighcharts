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


One can usually easily create an interactive chart with a oneliner in rCharts. 
However to create a heatmap, the procedure is slighty more complicated since the current version of rCharts 0.4.5 does not include the heatmap extensions yet.
To produce a heatmap with highcharts you need to have the variables named 'x', 'y' and 'value'. If you wish to have a text description for each of your data point, a variable 'name'. 



Also a legal note about Highcharts, it is only free for non-commercial usage. Please refer to its [licence](http://www.highcharts.com/products/highcharts/#non-commercia) for commercial usage.


### Credits
* The procedure to create a heatmap from Rcharts comes from
* RCharts
* Highcharts










