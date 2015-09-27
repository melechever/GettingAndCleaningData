#Author: Melany Echeverría
#Optional, Comment next line if you already have dplyr package installed
install.packages("dplyr")
library(dplyr)
#read data sets
data_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
data_test<-read.table("./UCI HAR Dataset/test/X_test.txt")

#read features
features<-read.table("./UCI HAR Dataset/features.txt")

#read activity levels
activity<-read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity)<-c("V1","Activity")

#read subject
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train)<-c("Subject")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test)<-c("Subject")

#read levels
levels_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
levels_test<-read.table("./UCI HAR Dataset/test/y_test.txt")

#merge activity, subject and levels 
sub_lev_train<-cbind(subject_train,levels_train)
train<-merge(sub_lev_train,activity,by="V1")

sub_lev_test<-cbind(subject_test,levels_test)
test<-merge(sub_lev_test,activity,by="V1")

#rename columns of data sets
colnames(data_train)<-features[,2]
colnames(data_test)<-features[,2]

#data sets
dat_train<-cbind(train,data_train)	
dat_test<-cbind(test,data_test)     

#Hack to clean data and avoid duplicated names error
dat_train<- dat_train[,-1]
dat_test<- dat_test[,-1]

#select only colunms with mean and sdt
train_data<- select(dat_train,contains("subject"), contains("activity"), contains("mean"), contains("std"))
test_data<- select(dat_test,contains("subject"), contains("activity"), contains("mean"), contains("std"))

#join train and test data
data<-rbind(train_data,test_data)

#create data
tidy_data<-(data %>% 
  group_by(Subject,Activity) %>% 
  summarise_each(funs(mean)))

#Write file
write.table(tidy_data,"./mean_std_data.txt",sep=",",row.name=FALSE)