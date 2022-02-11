library(tidyverse)
library(dplyr)
library(reshape)
library(gsheet)

j <- jsonlite::fromJSON("https://raw.githubusercontent.com/hubmapconsortium/azimuth-annotate/main/data/kidney.json",simplifyDataFrame = TRUE)
j<-j$mapping
x<-as_tibble(j)
a<-colnames(x)

l=1
b<-list()
while (l<=length(x)){
  b<-append(b,x[[l]])
  l<-l+1
}

b<-unlist(b)
az_as_mapping<-data.frame(a,b)
colnames(az_as_mapping)<-c("AZ_CT/LABEL","ASCTB_CT/LABEL")


json <- jsonlite::fromJSON("./Data/config.json")
urls<-json$references$url
file_name<-json$references$file_name
organ_name<-json$references$name
asctb_url<-json$references$asctb_url


#Azimuth data
az_kidney=read_csv(urls[1],skip=10)
az_kidney_ct=az_kidney[grepl("ID", c(colnames(az_kidney)), ignore.case = T)]
az_kidney_all_cts<-data.frame(name = c(t(az_kidney_ct)))

az_kidney_label=az_kidney[grepl("^AS.*LABEL$", c(colnames(az_kidney)), ignore.case = T)]
az_kidney_all_label<-data.frame(name = c(t(az_kidney_label)))

az_kidney_label_og=az_kidney[grepl("^AS/[0-9]$", c(colnames(az_kidney)), ignore.case = T)]
az_kidney_all_label_og<-data.frame(name = c(t(az_kidney_label_og)))


az_kidney_all_cts_labels<-data.frame(az_kidney_all_cts,az_kidney_all_label,az_kidney_all_label_og)
colnames(az_kidney_all_cts_labels)<-c("CT/ID","AZ_CT/LABEL_Author","AZ_CT/LABEL")
View(az_kidney_all_cts_labels)

#ASCTB data
asctb_kidney <- gsheet2tbl(asctb_url)
# Remove out the top 10 meta info rows
asctb_kidney <- asctb_kidney[10:nrow(asctb_kidney),]
# Remove out the top row which was just the colnames
colnames(asctb_kidney) <- asctb_kidney[1,]
asctb_kidney <- as.data.frame(asctb_kidney[2:nrow(asctb_kidney),])

asctb_kidney_ct<-asctb_kidney[grepl("^CT.*ID$", c(colnames(asctb_kidney)), ignore.case = T)]
asctb_kidney_all_ct<-data.frame(name = c(t(asctb_kidney_ct)))

asctb_kidney_label= asctb_kidney[grepl("^CT.*LABEL$", c(colnames(asctb_kidney)), ignore.case = T)]
asctb_kidney_all_label<-data.frame(name = c(t(asctb_kidney_label)))

asctb_kidney_label_og= asctb_kidney[grepl("^CT/[0-9]$", c(colnames(asctb_kidney)), ignore.case = T)]
asctb_kidney_all_label_og<-data.frame(name = c(t(asctb_kidney_label_og)))


asctb_kidney_all_cts_labels<-data.frame(asctb_kidney_all_ct,asctb_kidney_all_label,asctb_kidney_all_label_og)
colnames(asctb_kidney_all_cts_labels)<-c("CT/ID","ASCTB_CT/LABEL_Author","ASCTB_CT/LABEL")
View(asctb_kidney_all_cts_labels)

#Az unique
az_kidney_all_cts_labels<-unique(az_kidney_all_cts_labels)
View(az_kidney_all_cts_labels)

az_kidney_ct_n_label<-unique(az_kidney_all_cts_labels[,c(1,3)])
############################
View(az_kidney_ct_n_label)
##############################

#ASCTB unique
asctb_kidney_all_cts_labels<-unique(asctb_kidney_all_cts_labels)
View(asctb_kidney_all_cts_labels)

asctb_kidney_ct_n_label<- unique(asctb_kidney_all_cts_labels[,c(1,3)])
##############################
View(asctb_kidney_ct_n_label)
##############################
View(az_as_mapping)


# AZ - ASCTB 
az_as_view<-merge(x=az_kidney_ct_n_label,y=az_as_mapping,by="AZ_CT/LABEL",all.x=TRUE)
colnames(az_as_view) <- c("AZ_CT/LABEL","AZ_CT/ID","ASCTB_CT/LABEL")
View(az_as_view)


az_as_view_1<-merge(x=az_as_view,y=asctb_kidney_ct_n_label,by="ASCTB_CT/LABEL",all.x=TRUE)
colnames(az_as_view_1) <- c("ASCTB_CT/LABEL","AZ_CT/LABEL","AZ_CT/ID","ASCTB_CT/ID")
az_as_view_1<-az_as_view_1[,c(3,4,2,1)]
View(az_as_view_1)


### ASCTB - AZ
as_az_view<-merge(x=asctb_kidney_ct_n_label,y=az_as_mapping,by="ASCTB_CT/LABEL",all.x=TRUE)
colnames(as_az_view) <- c("ASCTB_CT/LABEL","ASCTB_CT/ID","AZ_CT/LABEL")
View(as_az_view)


as_az_view_1<-merge(x=as_az_view,y=az_kidney_ct_n_label,by="AZ_CT/LABEL",all.x=TRUE)
colnames(as_az_view_1) <- c("AZ_CT/LABEL","ASCTB_CT/LABEL","ASCTB_CT/ID","AZ_CT/ID")
as_az_view_1<-as_az_view_1[,c(3,4,2,1)]
View(as_az_view_1)










