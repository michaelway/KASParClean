
library(KASParClean)
getwd()


library(roxygen2)
library(devtools)

document()

KASPar_process(KASPar="examples/SNP1.txt", output = TRUE)

KASPar_annotate("examples/SNP1.clean.csv", 
                RefMajor="C", 
                RefMinor="G", 
                rsid="rs123456", 
                direction="FWD")


KASPar_plink("examples/sample", 
             "examples/sample.txt")