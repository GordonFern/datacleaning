#
# view_results.R
#
# Purpose R code to load the data set from the assignment and display it to
# the data set to a View grid


dat<-read.table("https://raw.githubusercontent.com/GordonFern/datacleaning/master/results.txt",sep=" ",header=TRUE)
View(dat)