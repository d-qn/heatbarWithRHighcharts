# Create an interactive heatmap-barchat with R/highcharts

## Introduction

This document describes the procedure to create in interactive a heatmap-barchart ("heatbar chart"?). Live examples of such graphic can be seen here:


This chart is fully created from R, by leveraging highcharts (javacript/d3 library) from R. It takes only about a dozen lines of R code to create such interactive chart. 

If you are already proficient with [d3](http://d3js.org) or Highcharts (not my case), there is probably not much to gain for you from this tutorial. 

But if you know some bits of R and wishes to create such interactive chart, please read on :-)

## About the graphic type
The live example shows all Swiss people's initiatives. On one hand, it is a bar/column chart showing the number of initiatives people voted on over the years, each unit of the graphic being a vote. On the other hand, it is a heatmap with each ballot being colored according to the % of yes. 

Such chart primarily conveys the information of a bar/column chart, but has additional information due to the discrete data's nature. The tooltip showing the title of each ballot is also a nice explorative feature.

Technically, this graphic is simply a heatmap coerced into a column chart. One could achieve something similar with an interactive dot chart. 

## Create the chart

### Getting started

You will need to have installed the R package rCharts, a wonderful wrapper for different d3 libraries. For that you need devtools installed. In R

install.package("devtools")
install.package("rCharts")
library(rCharts)

Load the data file

### Reshape the data

The data file contains just 3 columns: the date of each vote, the % of yes and the title of the vote. To create a heatmap we will aggregate all the votes by year (x dimension) and count the number of votes each year (y dimension).



One can usually easily create an interactive chart with oneliner in rCharts. 
However to create a heatmap, the procedure is slighty more complicated as far as I know. It is

Also please note that Highcharts is free for non-commercial usage. 


### Credits
* The procedure to create a heatmap from Rcharts comes from
* RCharts
* Highcharts










