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
    sFile<-"UCI HAR Dataset/test/subject_test.txt"
    
  }
  else if ( resultSet == 'train')
  {
    yFile<-"UCI HAR Dataset/train/y_train.txt"
    xFile<-"UCI HAR Dataset/train/X_train.txt"
    sFile<-"UCI HAR Dataset/train/subject_train.txt"
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
# Read the subject file
#
con <-unz(toFile,sFile)
subject<-readLines(con)
close(con)

#
# The number of lines in x and y files must match
#
    if ( length(x) != length(y) || length(x) != length(subject)) {
     stop("subject, x and y file length mismatch - data files corrupt")
   }

#
# Go through the x lines and process
#
  measurementTypes <- c("Walking","walking upstairs","walking downstairs","sitting","standing","Laying")
  distSubjects <- unique(subject)
  lenMeasures <- length(measurementTypes)
  lenDistSubjects<-length(distSubjects)
  vectLen<-lenMeasures*lenDistSubjects
 
  nos<-vector(mode='list',length=vectLen)

  for (i in 1:length(y)) {
    tmp<-gsub('^( *)|)( *)$','',x[i]) # Remove preceeding & trailing spaces
    tmp<-strsplit(tmp,'( +)') # Split the string at the spaces
    posSubject<-match(subject[i],distSubjects)
    posMeasure<-as.numeric(y[i])
    vecPos<-(posSubject - 1) * lenMeasures + posMeasure
 
    nos[[vecPos]]<-c(nos[[vecPos]],as.numeric(unlist(tmp))) # coerce to numbers vector
  }

#
# Build data frame
#
  df<-data.frame(subject=numeric(),result.set=character(),activity=character(),average=numeric(),std.deviation=numeric(),stringsAsFactors=FALSE)
  i<-1
  for ( k in 1:length(distSubjects) ) {
    for ( j in 1:length(measurementTypes)) {
        
      vecPos<-(k - 1) * lenMeasures + j
      
      df[i,1]<-distSubjects[k]
      df[i,2]<-resultSet
      df[i,3]<-measurementTypes[j]
      df[i,4]<-mean(nos[[vecPos]])
      df[i,5]<-sd(nos[[vecPos]])
      i<-i+1
    }
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
