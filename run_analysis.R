#
# run_analysis.R
#
# Prepares the data set by carry out the following operations
# 1. download the zip data file if it doesn't exist in the current directory



# Function downloadData(url,toFile,overwrite=False)
#
# Purpose: downloads and saves the file to the current working directory unzipping it
#          if it doesn't exist or overwrite = True
#
# Parameters: url - The url of the file
#             toFile - the filename of the file to save 
#             overwrite - if TRUE it will overwrite
#                         if FALSE and file already exists will not download
#
downloadData<-function(url, toFile,overwrite=False) {
  if ( ! file.exists(toFile) || overwrite == TRUE) {
    if ( file.exists(toFile) ) {
        file.remove(toFile)
    }
    download.file(url,toFile)
    
  }
}

processData<-function(resultSet,toFile) {
  
#
# Set up the appropriate files based on the resultSet type
#
  if (resultSet == 'test') {
    yFile<-"UCI HAR Dataset/test/y_test.txt"
    xFile<-"UCI HAR Dataset/test/X_test.txt"
  }
  else if ( resultSet == 'train')
  {
    yFile<-"UCI HAR Dataset/train/y_train.txt"
    xFile<-"UCI HAR Dataset/train/X_train.txt"
  }
  else
  {
    stop("Invalid resultSet Type")
  }
#
# Read the X file
#
  con <-unz(toFile,xFile)
  x<-readLines(con)
  close(con)
#
# Read the y file
#
  con <-unz(toFile,yFile)
  y<-readLines(con)
  close(con)

#
# The number of lines in x and y files must match
#
    if ( length(x) != length(y)) {
     stop("x and y file length mismatch - data files corrupt")
   }

#
# Go through the x lines and process
#
  nos<-vector(mode='list',length=6)

  for (i in 1:length(y)) {
    tmp<-gsub('^( *)|)( *)$','',x[i]) # Remove preceeding & trailing spaces
    tmp<-strsplit(tmp,'( +)') # Split the string at the spaces
    indx<-as.numeric(y[i])
    nos[[indx]]<-c(nos[[indx]],as.numeric(unlist(tmp))) # coerce to numbers vector
  }
#
# Declare the measurement Types
#
  measurementTypes=c("Walking","walking upstairs","walking downstairs","sitting","standing","Laying")

#
# Build data frame
#
  df<-data.frame(subject=character(),activity=character(),average=numeric(),std.deviation=numeric(),stringsAsFactors=FALSE)
  for ( i in 1:length(measurementTypes)) {
    df[i,1]<-resultSet
    df[i,2]<-measurementTypes[i]
    df[i,3]<-mean(nos[[i]])
    df[i,4]<-sd(nos[[i]])
  }
  df
}



#
# Main function
#
main<-function(forceDownload=FALSE) {
#
# Download the data if required
#
  downloadData("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","data.zip",forceDownload)
#
# Create a data frame of the processed results
#
  train<-processData("train","data.zip") # The training data sets
  test<-processData("test","data.zip")   # The test data sets

  res<-rbind(train,test)
  write.table(res,"results.txt",row.names=FALSE)
  res
}
  
dat<-main()
