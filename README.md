# KASParclean

> KASPar clean is an R package created to speed up the processing of fluorescence genotyping data produced by a LightCycler480.

##Install

To easily install the KASParClean package, install and run the devtools package and run the below in an R window:
```
install.packages("devtools")
library(devtools)
install_github("michaelway/KASParClean")
library(KASParClean)
```

##KASPar_process.R

###Input
 KASPar genotyping on a Roche LightCycler480 , with annotation of genotypes and sample id's, should produce a file similar to below:
```
head SNP1.txt

"Experiment Name"       "Analysis Name" Included        Position        "Sample Name"   X-Fluor Y-Fluor ManualCall      Call    Score   Status Codes    Status Desc
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A1      "ALC1774"       0.610990826705397       1.95442105591779        0       Allele Y        0.988147967354126       " "     " "
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A2      "X"     0.491447925016794       0.425016445203669       1       Negative        0       "*"     "Manually edited"
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A3      "ALC1778"       0.70321906912522        0.668829531080787       1       Unknown 0       "*"     "Manually edited"
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A4      "ALC1940"       0.701478020502951       0.630990856529117       1       Unknown 0       "*"     "Manually edited"
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A5      "ALC1779"       0.599503174642506       2.02752598536611        0       Allele Y        0.971594810928202       " "     " "
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A6      "ALC1941"       1.01934374457513        0.885790187498679       0       Both Alleles    0.99351581201923        " "     " "
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A7      "ALC1780"       0.676238015913822       2.53796638049321        0       Allele Y        0.990610641338266       " "     " "
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A8      "ALC1946"       1.17815529853373        1.05469187155188        0       Both Alleles    0.951235059176491       " "     " "
"SNP1_ALC12_14_15_16_151215"    "Alc12141516_SNP1"      1       A9      "ALC1781"       2.0004486642748 1.63194299174873        0       Both Alleles    0.931919664591459       " "     " "
```
**N.B. It is important that the "Sample Name" and "Call" columns are correctly filled out for later stages.**

###Run Script

Set the working directory to the location of your 
```
KASPar_process("SNP1.txt")
```
This will produce two files:
1. A log file with a summary of the dataset
2. A PDF with scatterplots of all of the plates that underwent genotyping and total scatterplots of the raw and cleaned data

####Log file

```
SNP1.txt.log

#######################################
#######################################

LightCycler480 KASPar Raw Data Processor
Date & Time: Mon Jan 11 14:11:06 2016 
For more info contact: Michael.way.11@ucl.ac.uk 

#######################################
#######################################

KASPar dataframe: SNP1.txt loaded
#######################################

Genotype Calls in Raw Data:

    Allele X     Allele Y Both Alleles     Negative      Unknown 
         553          877         1356          135          151 


Genotype Calls by plate:
                                      
                                       Allele X Allele Y Both Alleles Negative Unknown
  "SNP1_ALC_17_18_19_RFH_CIRR_151215"        58      105          179       22      20
  "SNP1_ALC_8_9_10_12_171215"                68      121          170        9      16
  "SNP1_ALC12_14_15_16_151215"               87      122          133       13      29
  "SNP1_STOPAH1_2+ALC1_2_101215"             68      116          188       10       2
  "SNP1_STOPAH3_4+ALC3_4_151215"             69      100          167       29      19
  "SNP1_STOPAH5_6+ALC5_6_7_151215"           71      119          169       15      10
  "SNP1_STOPAH7_8+ALC8_9_151215"             67      103          179        6      29
  "SNP1_STOPAH9_10+ALC10_13_11_151215"       65       91          171       31      26


Frequencies by plate:
                                      Allele X Allele Y Both Alleles Negative Unknown
                                                                                     
"SNP1_ALC_17_18_19_RFH_CIRR_151215"      15.00    27.00        47.00     5.70    5.20
"SNP1_ALC_8_9_10_12_171215"              18.00    32.00        44.00     2.30    4.20
"SNP1_ALC12_14_15_16_151215"             23.00    32.00        35.00     3.40    7.60
"SNP1_STOPAH1_2+ALC1_2_101215"           18.00    30.00        49.00     2.60    0.52
"SNP1_STOPAH3_4+ALC3_4_151215"           18.00    26.00        43.00     7.60    4.90
"SNP1_STOPAH5_6+ALC5_6_7_151215"         18.00    31.00        44.00     3.90    2.60
"SNP1_STOPAH7_8+ALC8_9_151215"           17.00    27.00        47.00     1.60    7.60
"SNP1_STOPAH9_10+ALC10_13_11_151215"     17.00    24.00        45.00     8.10    6.80
#######################################

Number of duplicates: 715 
Number of conflicts: 3 

Conflict Rate: 0.004195804 

Conflicting samples are :
 "ALC0608" "ALC2224" "ALC2462"

#######################################

Genotype Calls in Clean Data:

    Allele X     Allele Y Both Alleles 
         486          749         1186 


Allele X frequency: 0.4456836
Allele Y freqency: 0.5543164
Minor allele is: X

```
