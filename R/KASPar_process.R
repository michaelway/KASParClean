#' @title KASPar_process
#' @description Processes raw roche LightCycler 480 endpoint read genotype data and converts this into a csv file
#' and removes unknown, duplicate and .  It also produces a log file and a PDF containing scatter
#' plots for error checking.
#' @param KASPar: string. The name of the input LightCycler480 .txt file
#' @param output: logical.  Do you want an output .pdf .log and .clean.csv file or to just print qc info to the console?
#' @return If output is true, a log file, a PDF and a CSV with the cleaned data
#' @examples
#' KASPar_process(KASPar="examples/SNP1.txt", output = FALSE)
#' @author Michael Way
#' @export

KASPar_process <- function(KASPar,
                           output = TRUE){
  
  #Remove file suffix
  KASParNoTxt <- sub("^([^.]*).*", "\\1", KASPar) 

  log <-paste(KASParNoTxt,".log", sep="")
  
  if(output==TRUE){
    sink(log)
  }
    
  
  cat("#######################################\n")
  cat("#######################################\n\n")
  cat("LightCycler480 KASPar Raw Data Processor\n") 
  cat("Date & Time:",date(),"\n")
  cat("For more info contact: Michael.way.11@ucl.ac.uk","\n")
  cat("\n#######################################\n")
  cat("#######################################\n\n")
  
  data<-read.table(KASPar, header=TRUE, sep="\t", quote="") 
  data$X.Sample.Name.<-noquote(as.character(data$X.Sample.Name.))
  
  
  cat("KASPar dataframe:", KASPar, "loaded\n")
  
  
  #Process the sample names
  data$X.Sample.Name.<-toupper(as.character(data$X.Sample.Name.))
  
  data$Call<-as.character(data$Call)
  
  cat("#######################################\n\n")
  cat("Genotype Calls in Raw Data:\n")
  raw=table(data$Call)
  print(raw)
  
  cat("\n\nGenotype Calls by plate:\n")
  tab=table(data$X.Experiment.Name., data$Call)
  print(tab)
  cat("\n\nFrequencies by plate:\n")
  ftab=ftable(100*signif(prop.table(tab, 1), 2))
  print(ftab)
  
  
  #Clean samples of unknowns and negatives
  unknown=c("Unknown", "Negative")
  
  df<-subset(data[,c('X.Sample.Name.', 'Call', 'Position', 'X.Fluor', 'Y.Fluor')], data$Call!=unknown[1] & data$Call!=unknown[2]) 
  clean<-df[order(df$X.Sample.Name.) , ]
  
  #Identify duplicate samples in data
  
  df$dup=duplicated(df$X.Sample.Name.) | duplicated(df$X.Sample.Name., fromLast=TRUE) #Identify all duplicates
  
  df<-subset(df[,c('X.Sample.Name.', 'Call')], df$dup==TRUE) 
  
  Ndup=length(df$Call)
  cat("#######################################\n\n")
  cat("Number of duplicates:", Ndup, "\n")
  
  #Logical statements to identify duplicates
  
  df$dup2=duplicated(df[,c('X.Sample.Name.','Call')]) | duplicated(df[,c('X.Sample.Name.','Call')], fromLast=TRUE)
  df=df[order(df$X.Sample.Name.),]
  
  table(df$dup2)
  
  conflicts<-subset(df[,], df$dup2==FALSE)
  conflicts=conflicts$X.Sample.Name.
  conflicts=unique(conflicts)
  
  Ncon=length(conflicts)
  cat("Number of conflicts:", Ncon,"\n\n")
  
  ConRate=Ncon/Ndup
  cat("Conflict Rate:", ConRate, "\n\n")
  cat("Conflicting samples are :\n", conflicts)
  
  #Remove all conflicting samples from data
  if (length(conflicts)>0)
  {
  for(i in 1:length(conflicts))
  {
    clean=subset(clean, X.Sample.Name.!=conflicts[i])
  }
  }
  
  clean$Dup2=duplicated(clean$X.Sample.Name.)
  
  clean <- subset(clean, Dup2==FALSE)
  
  clean$X.Sample.Name.=noquote(clean$X.Sample.Name.)
  
  #Remove double quotation marks
  clean$X.Sample.Name.=gsub("\"", "", clean$X.Sample.Name.)
  
  
  
  cat("\n\n#######################################\n\n")
  cat("Genotype Calls in Clean Data:\n")
  raw=table(clean$Call)
  print(raw)
  
  #Calculate major and minor allele frequencies
  rawframe=as.data.frame(raw, stringsAsFactors=FALSE)
  
  if (!"Both Alleles" %in% rawframe$Var1){
      rawframe[nrow(rawframe)+1,] <- c("Both alleles", 0)
  }
  if (!"Allele X" %in% rawframe$Var1){
      rawframe[nrow(rawframe)+1,] <- c("Allele X", 0)
  }
  if (!"Allele Y" %in% rawframe$Var1){
      rawframe[nrow(rawframe)+1,] <- c("Allele Y", 0)
  }

  print(rawframe, row.names = FALSE)
  
  #Calculate major and minor allele frequencies
  Xfreq=(((2*(as.numeric(subset(rawframe$Freq, rawframe$Var1=="Allele X"))))+(as.numeric(subset(rawframe$Freq, rawframe$Var1 == "Both Alleles")))))/((2*(sum(as.numeric(rawframe$Freq)))))
  Yfreq=(((2*(as.numeric(subset(rawframe$Freq, rawframe$Var1=="Allele Y"))))+(as.numeric(subset(rawframe$Freq, rawframe$Var1 == "Both Alleles")))))/((2*(sum(as.numeric(rawframe$Freq)))))

  
  if(Xfreq<Yfreq){
    MajA=c("Y")
    MinA=c("X")
  } else {
    MajA=c("X")
    MinA=c("Y")
  }
  
  cat("\n\nAllele X frequency:", round(Xfreq, 2))
  cat("\nAllele Y freqency:", round(Yfreq, 2))
  cat("\nMinor allele is:", MinA)
  

  if(output==TRUE){
  
  plot<-paste(KASParNoTxt,".pdf", sep="")
  
  pdf(plot)
  par(mfrow = c(length(unique(data$X.Experiment.Name.))/2, 2),  
      oma = c(5,4,0,0) + 0.1,
      mar = c(0,0,1,1) + 0.3,
      xpd = NA)
  pal<-palette(c("blue", "Green", "Red", "grey", "deeppink"))
  palette(c("blue", "Green", "Red", "grey", "deeppink"))
  #par(cex = 0.6)
  #par(mar =  c(5, 4, 0, 0), oma = c(0, 0, 0, 0))
  par(pty="s")
  min=c(min(data$X.Fluor), min(data$Y.Fluor))
  max=c(max(data$X.Fluor), max(data$Y.Fluor))
  
  for ( i in levels(data$X.Experiment.Name.) ) { 
    x<-with(data, X.Fluor[X.Experiment.Name. == i])
    y<-with(data, Y.Fluor[X.Experiment.Name. == i])
    call<-with(data, Call[X.Experiment.Name. == i])
    plot(x, y, col = as.factor(call), axes=FALSE, frame.plot=TRUE, xlab=NA,ylab=NA, pch=16,cex=0.2)
    title(main=i, cex.main=1)
    legend('topright', legend=levels(as.factor(data$Call)) , pch =16, col=pal, cex=0.35)
  }
  rm(i,x, y, call)
  par(mfrow = c(2, 1))
  
  plot(data$X.Fluor, data$Y.Fluor, col = as.factor(data$Call), xlab="X fluorescence",ylab="Y fluorescence", main="raw data", pch=16,cex=0.55)
  legend('topright', legend=levels(as.factor(data$Call)) , pch =16, col=pal, cex=.55)
  plot(clean$X.Fluor, clean$Y.Fluor, col = as.factor(clean$Call), xlab="X fluorescence",ylab="Y fluorescence", main="clean data", pch=16,cex=0.55)
  legend('topright', legend=levels(as.factor(clean$Call)) , pch =16, col=pal, cex=.55)
  dev.off()

  }
  
  out<-paste(KASParNoTxt,".clean.csv", sep="")
  
  
  #Make the dataframe pretty for the CSV output
  if(output==TRUE){
  names(clean)[1] = "SID"
  clean$Position=NULL
  clean$dup=NULL
  clean$Dup2=NULL
  write.csv(clean, file=out, row.names=FALSE)
  }
  
  if(output==TRUE){
    sink(NULL)
  }

}
