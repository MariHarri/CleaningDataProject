setlabels.file<-read.table('features.txt')
colnames(data)<-setlabels.file[,2]

#clearing out all but the mean and std columns from data; total 79 variables
x<-grepl('mean',colnames(data))
y<-grepl('std',colnames(data))
data.meanstd<-cbind(data[,x],data[,y])

#reading in observations for each activity and merging them
testactobs.file<-read.table('test/y_test.txt')
trainactobs.file<-read.table('train/y_train.txt')
activitynames.file<-read.table('activity_labels.txt')
activity.obs<-rbind(testactobs.file,trainactobs.file)
#renaming the activities by their descriptive names rather than 1:6
temp<-data.frame(a=(1:6),b=activitynames.file[,2])
activity.obs[]<-lapply(activity.obs,function(x) temp[match(x,temp$a),'b'])
#adding this column to the main data
data.meanstd['Activity']<-activity.obs

#reading in observations for each subject and merging them
testsubjobs.file<-read.table('test/subject_test.txt')
trainsubjobs.file<-read.table('train/subject_train.txt')
subject.obs<-rbind(testsubjobs.file,trainsubjobs.file)
#adding this column to the main data
data.meanstd['Subject']<-subject.obs

#creating new data set with averages for each activity for each subject
#using dplyr and a for loop. This produces a tibble with 180 obs of 81
#variables, preserving the variables for subject and activity
library(dplyr)
averages=data.frame()
for(i in 1:30){
    averages<-rbind(averages,(data.meanstd %>% 
                                  filter(Subject==i) %>%
                                  group_by(Activity) %>%
                                  summarise_at(c(1:80),mean)))
}

