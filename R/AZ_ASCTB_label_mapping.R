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
colnames(az_as_mapping)<-c("Az","Asctb")

#write.csv(ab,file = "LabelMapping.csv")


json <- jsonlite::fromJSON("./Data/config.json")
urls<-json$references$url
file_name<-json$references$file_name
organ_name<-json$references$name
asctb_url<-json$references$asctb_url


#Azimuth data
az_kidney=read_csv(urls[1],skip=10)
View(az_kidney)
az_kidney_ct=az_kidney[grepl("ID", c(colnames(az_kidney)), ignore.case = T)]
az_kidney_all_cts<-data.frame(name = c(t(az_kidney_ct)))

az_kidney_label=az_kidney[grepl("^AS.*LABEL$", c(colnames(az_kidney)), ignore.case = T)]
az_kidney_all_label<-data.frame(name = c(t(az_kidney_label)))

az_kidney_label_og=az_kidney[grepl("^AS/[0-9]$", c(colnames(az_kidney)), ignore.case = T)]
az_kidney_all_label_og<-data.frame(name = c(t(az_kidney_label_og)))

#View(az_kidney_all_label)
#View(az_kidney_all_cts)
#View(az_kidney_all_label_og)

az_kidney_all_cts_labels<-data.frame(az_kidney_all_cts,az_kidney_all_label,az_kidney_all_label_og)
colnames(az_kidney_all_cts_labels)<-c("CT/ID","CT/LABEL_Author","CT/LABEL")
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
View(asctb_kidney_all_ct)

asctb_kidney_label= asctb_kidney[grepl("^CT.*LABEL$", c(colnames(asctb_kidney)), ignore.case = T)]
asctb_kidney_all_label<-data.frame(name = c(t(asctb_kidney_label)))
View(asctb_kidney_all_label)

asctb_kidney_label_og= asctb_kidney[grepl("^CT/[0-9]$", c(colnames(asctb_kidney)), ignore.case = T)]
asctb_kidney_all_label_og<-data.frame(name = c(t(asctb_kidney_label_og)))


asctb_kidney_all_cts_labels<-data.frame(asctb_kidney_all_ct,asctb_kidney_all_label,asctb_kidney_all_label_og)
colnames(asctb_kidney_all_cts_labels)<-c("CT/ID","CT/LABEL_Author","CT/LABEL")
View(asctb_kidney_all_cts_labels)


az_kidney_all_cts_labels<-unique(az_kidney_all_cts_labels)
View(az_kidney_all_cts_labels)

#ASCTB
asctb_kidney_all_cts_labels<-unique(asctb_kidney_all_cts_labels)
View(asctb_kidney_all_cts_labels)

uq_as=unique(asctb_kidney_ct)
#view(uq_as)

uq_az=unique(az_kidney_ct)
#view(uq_az)

as_set<- unique(data.frame(name=c(t(uq_as))))
az_set<- unique(data.frame(name=c(t(uq_az))))


ct_in_as_set<-function(a){
  if (length(as_set[as_set==a])>=2){
    return (TRUE)
  }
  else{
    return (FALSE)
  }
}

ct_in_superclass<-function(a){
  if (a %in% super_class_ct){
    return (TRUE)
  }
  else{
    return (FALSE)
  }
}

check_and_append_super_class_ct<-function(az_ini_row,az_colu){
  az_colu=az_colu-1
  while(az_colu>=1){
    if(ct_in_superclass(uq_az[az_ini_row,az_colu][[1]])){}
    else{
      super_class_ct=append(super_class_ct,uq_az[az_ini_row,az_colu][[1]])
    }
    az_colu=az_colu-1
  }
}

tf<-function(a,b){
  if(identical(a[[1]],b)){
    return (TRUE)}
  else{
    return (FALSE)
  }
}

as_set<- unique(data.frame(name=c(t(uq_as),stringAsFactors=FALSE)))
az_set<- unique(data.frame(name=c(t(uq_az),stringAsFactors=FALSE)))


az_as<-list()
super_class_ct<-list()
az_colu=ncol(uq_az)
az_rows=nrow(uq_az)
az_ini_row<-1


while(az_colu>=1){
  az_ini_row<-1
  while(az_ini_row!=az_rows+1){
    as_colu=ncol(uq_as)
    as_rows=nrow(uq_as)
    ct_found=0
    while(ct_found==0 && as_colu>=1){
      as_ini_row=1
      while(as_ini_row!=as_rows+1){
        if(tf(uq_az[az_ini_row,az_colu],uq_as[as_ini_row,as_colu])){
          check_and_append_super_class_ct(az_ini_row,az_colu)
          ct_found=1
        }
        else{
          if(ct_in_as_set(uq_az[az_ini_row,az_colu][[1]])){}
          else{
            az_as<-append(az_as,uq_az[az_ini_row,az_colu][[1]])
            az_as<-unique(az_as)
          }
        }
        as_ini_row<-as_ini_row+1
      }
      as_colu<-as_colu-1
    }
    az_ini_row<-az_ini_row+1
  }
  az_colu<-az_colu-1
}



#az_as<-append(az_as,super_class_ct)
az_as<-data.frame(unlist(az_as))
super_class_ct<-append(super_class_ct,"1")
super_class_ct<-data.frame(unlist(super_class_ct))



colnames(az_as)<-"CT/ID"
colnames(super_class_ct)<-"CT/ID"
#View(az_as)
#View(super_class_ct)

View(asctb_kidney_all_cts_labels)
View(az_kidney_all_cts_labels)


View(az_kidney_all_cts_labels)
az_as=setdiff(az_as,super_class_ct)
#View(az_as)

az_as_w_labels<-merge(x=az_as,y=az_kidney_all_cts_labels,by="CT/ID",all.x=TRUE)
View(az_as_w_labels)
View(az_as)


colnames(az_as_mapping)<-c("CT/LABEL","Asctb")
View(az_as_mapping)
az_as_w_labels_1<-merge(x=az_as_w_labels,y=az_as_mapping,by="CT/LABEL",all.x=TRUE)
View(az_as_w_labels_1)

az_as_w_labels_2<-az_as_w_labels_1[is.na(az_as_w_labels_1$Asctb) | az_as_w_labels_1$Asctb=='other',]

colnames(az_as_w_labels_2)<-c("AZ-CT/LABEL","AZ-CT/ID","AZ-CT/LABEL_Author","ASCTB-CT/LABEL")

az_as_w_labels_3 <- subset(az_as_w_labels_2, select = c("AZ-CT/LABEL","AZ-CT/ID"))

View(az_as_w_labels_3)
write.csv(az_as_w_labels_2,"./Data/cts_missing_in_asctb_kidney.csv",row.names = FALSE)
