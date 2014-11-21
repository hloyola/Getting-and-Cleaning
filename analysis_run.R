
#All start with the download and decompress of the data available at the URL for this project.

##Moving to the train folder
setwd("~/coursera/getting data/project/UCI HAR Dataset/train")

#These are the variables on the training data set.
x_data <- read.table("X_train.txt",header=F,sep="")
dim(x_data) #7352x561


#Naming columns based on names on feature.txt file
feat <- read.table("~/coursera/getting data/project/UCI HAR Dataset/features.txt",header=F,sep="")
#dim(feat) #561 x 2

vars <- feat[,2]

#names of x_data
names(x_data) <- vars


#Getting the activity data
y_data1 <- read.table("y_train.txt",header=F,sep="")


#this correspond to activity codes name
names(y_data1) <- "activity"

#Getting the subjects code data
subj1 <- read.table("subject_train.txt",header=F,sep="") 

#These are subject codes name
names(subj1) <- "subjects"


#Binding by column order Subject,Activities,train data files

satrn <- cbind(subj1,y_data1,x_data)

##Moving to the test folder
setwd("~/coursera/getting data/project/UCI HAR Dataset/test")

#Getting the test data
x_data2 <- read.table("X_test.txt",header=F,sep="") 

#names of x_data2
names(x_data2) <- vars


#this correspond to activity codes
y_data2 <- read.table("y_test.txt",header=F,sep="")

#Name of
names(y_data2) <- "activity"

#These are subject codes and variable name
subj2 <- read.table("subject_test.txt",header=F,sep="")
names(subj2) <- "subjects"


#Binding by column order Subject,Activities,train data files

sates <- cbind(subj2,y_data2,x_data2)



###Joining by rows satrn and sates files

alldata <- rbind(satrn,sates)
dim(alldata) #10299 x 563


#Cleaning (optional in this case)
#rm(feat,sates,satrn,subj1,subj2,vars,x_data,x_data2,y_data1,
#y_data2)

#Extracting the measurement with the mean and standard deviation for each measurement.

#Getting the variable index with the string "mean" on it.
var.names <- names(alldata)
#var.names

i_mean <- grep("mean",var.names)


#getting the variable index with the string "std" on it.

i_sd <- grep("std",var.names)


#Subsetting columns "subject", "activity" and the variables with the string "mean" or "std" 
#on its names from the "alldata" file.

file1 <- alldata[,c(1,2)]


means.vars <- alldata[i_mean]


std.vars <- alldata[i_sd]


#Making a file with the previous data.frames

small.file <- cbind(file1,means.vars,std.vars)


##Cleaning again (optional)
#rm(alldata,file1,i_mean,i_sd,means.vars,std.vars,var.names) 



##Labeling "activity" variable codes. This is done by creating a factor type variable.

act.lab <- read.table("~/coursera/getting data/project/UCI HAR Dataset/activity_labels.txt",header=F,sep="")


small.file$activity <- factor(small.file$activity,
	levels = act.lab[,1],
	labels = act.lab[,2])


##Transforming the names on the "small.file"

##get the names of "small.file"
txt1 <- names(small.file)

##replace the characters "mean","()" and "-" with "Mean","" and "_" respectively.
repl <- gsub("mean","Mean",txt1)

repl <- gsub("[()]","",repl)

repl <- gsub("[-]","_",repl)

##rename the variables on small.file file with the transformed names
names(small.file) <- repl


## Compute the averages for the variables in 'small.file', grouped according to subject and activity.

#There are different ways to do this, I use the plyr #package.

library(plyr)

tidydata <- ddply(small.file, .(activity,subjects), numcolwise(mean))

#tidydata[1:6,1:5] (optional, just to look at)

##Writing the requested data frame.
write.table(tidydata,"~/coursera/getting data/project/Tidydat.txt",sep=";",row.names=FALSE)















