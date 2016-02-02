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

###Run Function

Set the working directory to the location of your input data and run the KASPar_process() function on your input text file.
```
KASPar_process("SNP1.txt")
```
This will produce two files:

1. A log file with a summary of the dataset (e.g. *SNP1.txt.log*)
2. A PDF with scatterplots of all of the plates that underwent genotyping and total scatterplots of the raw and cleaned data (e.g. *SNP1.txt.pdf*)
3. A CSV file containing the processed genotype data (e.g. *SNP1.txtclean.csv*)

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

##KASPar_annotate.R
> To add allele information to cleaned CSV files with genotpye data

###Input
A cleaned CSV file with genotype data produced by KASPar_process():
```
head SNP1.txtclean.csv

"SID","Call","X.Fluor","Y.Fluor"
"100-5001","Both Alleles",3.12140191401555,2.52532041325145
"100-5002","Allele X",3.49869861144719,0.754659786030618
"100-5003","Both Alleles",2.73446946476066,2.19985079057008
"100-5004","Allele Y",0.873242389355671,2.64290033708375
"100-5005","Both Alleles",2.72005190329054,2.12250154310087
"100-5006","Both Alleles",3.11544896061942,2.47444093367094
"100-5007","Allele Y",0.911502060072728,2.5749911231616
"100-5008","Allele Y",0.839293863530369,2.80873076179237
"100-5009","Both Alleles",3.20637720762011,2.50169945236819

```
###Run Function

In the same  working directory after running the KASPar_process() function, you can edit the default allele codes of the cleaned CSV file using KASPar_annotate():

There are 5 parameters for the function:

1. The CSV filename
2. The reference major allele code (default = "A1")
3. The reference minor allele code (default = "A1")
4. The variant rs identification number (default = "rs123456")
5. The strand orientation of the allele coding (.g. FWD or REV)

```
KASPar_annotate("SNP1.txtclean.csv", 
                RefMajor="A2", 
                RefMinor="A1", 
                rsid="rs123456", 
                direction=NA)
```

This will produce an output .txt file with the name of the rsid chosen or the default.

For example
```
head rs123456.txt

SID Geno A1 A2 rsid Dir
A1 CT C T rs123456 NA
A2 CT C T rs123456 NA
A3 CT C T rs123456 NA
A4 TT T T rs123456 NA
A5 CT C T rs123456 NA
A6 CT C T rs123456 NA
A7 CT C T rs123456 NA
A8 CT C T rs123456 NA
A9 CC C C rs123456 NA

```

##KASPar_plink.R
> If you want to create a PED and MAP file for analysis using PLINK using data for several variants

###Input
This function takes in two input files 

1. A samples file
2. A MAP file

**This function must be run after you have run the previous two functions for all of the variants that you are interested in analysing in PLINK.**

###Sample file
The sample file contains information on all of the samples that you want in your final PED file.  Hence, it is essentially the first six columns of a ped file with a header line.

Please use the same gender and phenotype coding schema as for plink (e.g. Males=1, Females=2, Unknown =0)

For example:
```
head sample.txt

FID	SID	PID	MID	Gender	All
1	100-5001	0	0	2	2
2	100-5002	0	0	1	2
3	100-5003	0	0	1	2
4	100-5004	0	0	1	2
5	100-5005	0	0	2	2
6	100-5006	0	0	2	0
7	100-5007	0	0	2	2
8	100-5008	0	0	1	2
9	100-5009	0	0	1	2
10	100-5010	0	0	2	2

```
**N.B. The sample IDs must match those given in the earlier files exactly otherwise this will produce a blank ped file**


###MAP file
The MAP file is exactly the same as a PLINK format file where:

1. 1st column = chromosome
2. 2nd column = Variants names **N.B. It is very important that these rsid are identical to the processed to the names of the .txt files from the previous function otherwise it wont work**
3. 3rd column = variant size in centimorgans
4. 4th column = genomic coordinates of variant

For example:
```
head example.map

7	rs11082773	0	47221491
3	rs28350	0	42418446
4	rs153409	0	16790483
10	rs36056997	0	49664218
1	rs4027132	0	29467931
2	rs9861686	0	12037492

```
###Run Function

```
KASPar_plink(samples, 
             "samples.txt")

```
**N.B. You dont need the .MAP suffix for the name of the map file in this function**

