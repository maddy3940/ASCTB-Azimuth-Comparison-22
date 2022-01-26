library(jsonlite)
library(tidyverse)
library(gsheet)
library(dplyr)


json <- jsonlite::fromJSON("./Data/config.json")
urls<-json$references$url
file_name<-json$references$file_name
organ_name<-json$references$name
asctb_url<-json$references$asctb_url


#Azimuth data
az_kidney=read_csv(urls[1],skip=10)
az_kidney_ct=az_kidney[grepl("ID", c(colnames(az_kidney)), ignore.case = T)]

#ASCTB data
asctb_kidney <- gsheet2tbl(asctb_url)

# Remove out the top 10 meta info rows
asctb_kidney <- asctb_kidney[10:nrow(asctb_kidney),]

# Remove out the top row which was just the colnames
colnames(asctb_kidney) <- asctb_kidney[1,]
asctb_kidney <- as.data.frame(asctb_kidney[2:nrow(asctb_kidney),])
asctb_kidney_ct<-asctb_kidney[grepl("^CT.*ID$", c(colnames(asctb_kidney)), ignore.case = T)]

#View(asctb_kidney_ct)
#View(az_kidney_ct)

head(asctb_kidney_ct)
head(az_kidney_ct)

#TP
ncol(az_kidney_ct)
nrow(az_kidney_ct)

ncol(asctb_kidney_ct)
nrow(asctb_kidney_ct)


uq_as=unique(asctb_kidney_ct)
#view(uq_as)
#View(asctb_kidney_ct)

uq_az=unique(az_kidney_ct)
#view(uq_az)
#View(az_kidney_ct)

#########################

as_set<- unique(data.frame(name=c(t(uq_as))))
az_set<- unique(data.frame(name=c(t(uq_az))))



tf<-function(a,b){
  #cat(a[[1]],b,identical(a[[1]],b),"\n")
  if(identical(a[[1]],b)){
    return (TRUE)}
  else{
    return (FALSE)
  }
}
#a='a'
#b='b'
#cat(a,b)

ct_in_superclass<-function(a){
  
  if (a %in% super_class_ct){
    return (TRUE)
  }
  else{
    return (FALSE)
  }
}

check_and_append_super_class_ct<-function(as_ini_row,as_colu){
  as_colu=as_colu-1
  #print(as_colu)
  while(as_colu>=1){
    #print(uq_as[as_ini_row,as_colu])
    if(ct_in_superclass(uq_as[as_ini_row,as_colu])){}
    else{
      super_class_ct=append(super_class_ct,uq_as[as_ini_row,as_colu])
    }
    as_colu=as_colu-1
  }
}

ct_in_az_set<-function(a){
  
  if (length(az_set[az_set==a])>=1){
    return (TRUE)
  }
  else{
    return (FALSE)
  }
}

#length(az_set[az_set=='CL:0000115'])


as_az<-list()
super_class_ct<-list()
as_colu=ncol(uq_as)
as_rows=nrow(uq_as)
as_ini_row<-1

while(as_colu>=1){
  as_ini_row=1
  while (as_ini_row!=as_rows+1) {
    az_colu=ncol(uq_az)
    az_rows=nrow(uq_az)
    ct_found=0
    
    #print(uq_as[as_ini_row,as_colu])
    #ct_s=ct_s+1
    while(ct_found==0 && az_colu>=1){
      az_ini_row=1
      while (az_ini_row!=az_rows+1) {
        
        if(tf(uq_az[az_ini_row,az_colu],uq_as[as_ini_row,as_colu])){
          check_and_append_super_class_ct(as_ini_row,as_colu)
          ct_found=1
        }
        else{
          if(ct_in_az_set(uq_as[as_ini_row,as_colu])){}
          else{
            #print("qqq")
            as_az<-append(as_az,uq_as[as_ini_row,as_colu])
            as_az<-unique(as_az)
          }
        }
        #print(uq_az[az_ini_row,az_colu][[1]])
        #ct_z=ct_z+1
       az_ini_row=az_ini_row+1 
      }
      az_colu=az_colu-1
    }
    
    as_ini_row<-as_ini_row+1 
  }
  as_colu=as_colu-1
}



#as_az<-append(as_az,super_class_ct)
as_az<-data.frame(unlist(as_az))
super_class_ct<-append(super_class_ct,"1")
super_class_ct<-data.frame(unlist(super_class_ct))

#super_class_ct<-append(super_class_ct,"CL:1000742")


colnames(as_az)<-"cts_missing_in_az_kidney"
colnames(super_class_ct)<-"cts_missing_in_az_kidney"
#View(as_az)
#View(super_class_ct)

as_az=setdiff(as_az,super_class_ct)
#View(as_az)

write.csv(as_az,"./Data/cts_missing_in_az_kidney.csv",row.names = FALSE)







