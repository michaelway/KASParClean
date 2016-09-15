#' Converts several KASPar annotated  CSV files into a single PED file
#' @note This software requires a sample file with the first 6 columns of a ped file
#' @note and a map file with the names of variants
#' @param name - the prefix of the ped and map file
#' @param sample - a text file containing the first 6 lines of the ped file
#' @return A PED file
#' @export
#' @example
#' KASPar_plink(KASPar_plink(samples, "samples.txt")


KASPar_plink <- function(name,
                         samples)
{
  map=read.table(paste(name, ".map", sep = ""))
  ped=paste(name, ".ped", sep = "")
  
  pheno=read.table(samples, header=TRUE)
  
  length(map)
  
  map[2,1]
  
  out=pheno
  for(i in 1:nrow(map)){
    SNP=paste(map[i, 2], ".txt", sep = "")
    rs=read.table(SNP, header=TRUE)
    A1=paste(map[i, 2], ".A1", sep = "")
    A2=paste(map[i, 2], ".A2", sep = "")
    rs$GENO=NULL
    rs$rsid=NULL
    rs$Dir=NULL
    rs$Geno=NULL
    names(rs)[2] <- A1
    names(rs)[3] <- A2
    out=merge(out, rs, by="SID", all.x=TRUE)  
  }
  
  
  #Reformat the dataframe so that it is more similar to 
  out <- out[c(2,1,3:ncol(out))]
  
  
  #Write output to a ped file
  write.table(out,
              file=ped,
              na="0", 
              col.names = FALSE,
              row.names = FALSE,
              quote= FALSE)
}
