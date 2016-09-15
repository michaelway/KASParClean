#' Process a SNPs cleaned genotype data from csv format
#' @param csv The name of the input csv file
#' @param RefMajor - The reference major allele (e.g. A, G, T, C)
#' @param RefMinor - The reference minor allele (e.g. A, G, T, C)
#' @param rsid - The SNP identification number (is used to name the output)
#' @param direction - The direction of the allele codes (e.g. FWD, REV)
#' @return A text file with genotype and allele annotations
#' @export


KASPar_annotate <- function(csv, 
                            RefMajor="A2", 
                            RefMinor="A1", 
                            rsid="rs123456", 
                            direction=NA){
  
  #Read in data and process CSV data 
  data=read.csv(csv)
  data$X.Fluor=NULL
  data$Y.Fluor=NULL
  
  
  #Calculate major and minor allele frequencies
  count=table(data$Call)
  
  Xfreq=as.numeric((count[3]+(2*count[1]))/(2*sum(count[1:3])))
  Yfreq=as.numeric((count[3]+(2*count[2]))/(2*sum(count[1:3])))
  
  if(Xfreq<Yfreq){
    Minor="x"
  } else {
    Minor="y"
  }
  
  AA=paste(RefMajor, RefMajor, sep="")
  Aa=paste(RefMajor, RefMinor, sep="")
  aa=paste(RefMinor, RefMinor, sep="")
  
  #Create genotype and allele variables
  if(Minor=="x"){
    G1=paste("Allele Y")
    G2=paste("Allele X")
  } else {
    G1=paste("Allele X")
    G2=paste("Allele Y")
  }
  
  data$Geno=as.character(NA)
  data$A1=as.character(NA)
  data$A2=as.character(NA)
  data$rsid=rsid
  data$Dir=direction
  
  G1==data[7,2]
  
  #For loop to create
  for(i in 1:nrow(data)){
    if(data[i,2]==G1){
      data[i,3]=AA
      data[i,4]=RefMajor
      data[i,5]=RefMajor
    }
    else if(data[i,2]==G2){
      data[i,3]=aa
      data[i,4]=RefMinor
      data[i,5]=RefMinor
    }
    else{
      data[i,3]=Aa
      data[i,4]=RefMajor
      data[i,5]=RefMinor    
    }  
  }
  
  name=paste(rsid, ".txt", sep="")
  
  data$Call=NULL
  
  write.table(data, file=name, row.names=FALSE, quote = FALSE)
  
}
