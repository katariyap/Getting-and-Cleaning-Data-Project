library(plyr)
##set working directory as USI HAR Dataset and reading train files
training_datax<-read.table("./train/X_train.txt",header=F,sep="")
training_datay<-read.table("./train/y_train.txt",header=F,sep="")
subject_train<-read.table("./train/subject_train.txt",header=F,sep="")
feature<-read.table("./features.txt",header=F,sep="")
activity_label<-read.table("./activity_labels.txt",header=F,sep="")

##reading test files
test_datax<-read.table("./test/X_test.txt",header=F,sep="")
test_datay<-read.table("./test/y_test.txt",header=F,sep="")
subject_test<-read.table("./test/subject_test.txt",header=F,sep="")

##Ans1:Mearge two data sets
x_merge<-rbind(training_datax,test_datax)
y_merge<-rbind(training_datay,test_datay)
subject_merge<-rbind(subject_train,subject_test)
##Ans2:Extract only the measurements for mean and s.d for each measurement
Mean_sd<-grep("-(mean|std)\\(\\)",feature[,2])
#subsetting the dataset
x_sub<-x_merge[,Mean_sd]
##appliying column names from feature file
names(x_sub) <- feature[Mean_sd, 2]
##Ans3:Uses descriptive activity names to name the activities in the data set
colnames(y_merge)="activity"
y_merge[, 1] <- activity_label[y_merge[, 1], 2]
##Appropriately labels the data set with descriptive variable names
colnames(subject_merge)="Subject"
tidy_data<-cbind(x_merge,y_merge,subject_merge)
##creates a second, independent tidy 
##data set with the average of each variable 
##for each activity and each subject
data_mean<-ddply(tidy_data, .(Subject, activity), function(x) colMeans(x[, 1:66]))
write.table(data_mean,"data_mean.txt",row.names=FALSE)
