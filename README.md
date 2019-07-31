# WoSL-Dictionary-Creation
This repository contains R code to create dictionary from corpus of documents

# What is 'WoSL_Dictionary_Creation.R'?

'WoSL_Dictionary_Creation' is an R code that processes the collection of texts and create the list of words from the collection. This script provides a detailed explanation of the code and includes information on the pre-processing steps were performed, and output files were created.

The code is written for building WoSL Dictionary from WoSL Corpus to be used by Neslihan Suzen for her PhD project, and it can be used for other corpuses for a wide verity of applications that includes pre-processing the collection of texts, creating DTM and producing a list of words from the collection of texts. The code can be also used to reproduce WoSL Dictionary.


      Usage for 'WoSL_Dictionary_Creation.R'

'WoSL_Dictionary_Creation.R' can be easily downloaded from GitHub.

The code requires the following R packages: tm, SnowballC, slam, plyr. Packages can be installed by

    install.packages(c("tm","SnowballC","slam","plyr"))

'WoSL_Dictionary_Creation.R' contains 4 parameters of paths 'sourceDir', 'outDirectory', 'prefFileName' and 'substFileName' described below:

    sourceDir     : Directory with source files (.csv files)
    outDirectory  : Directory to write metadata files and processed documents
    prefFileName  : Directory for the file 'List of prefixes'
    substFileName : Directory for the file 'List of substitution'
  
These locations should be changed by the user for reading and writing files. 

The code consists of two fuctions, 'pattern' to create gsub pattern for list of prefixes and 'preprocessing' to process the collection of texts. Preprocessing function consists the following operations:

1.	Removing punctuations and special characters: This is the process of substitution of all non -alphanumeric characters by space exclusing '-' 
2.	Lowercasing the text data: Entire collection of texts are converted to lowercase. 
3.	Uniting prefixes of words: Words containing prefixes joined with character "-" are united as a word. The list of prefixes united for this research are listed in the file "list_of_prefixes.csv". 
4.	Substitution of words: Some of words joined with "-" in the abstracts of the WoSL Corpus require an additional process of substitution to avoid losing the meaning of the word before removing the character "-". The full list of such words and decision taken for substitution are presented in the         file "list_of_substitution.csv". 
5.	Removing the character "-": All remaining character "-" are replaced by space. 
6.	Removing numbers: All digits which are not included in a word are replaced by space. All words that contain digits and letters are kept for this study.
7.	Stemming: In this process, multiple forms of a specific word are eliminated and words that have the same base in different grammatical forms are mapped to the same stem. 
8.	Stop words removal: All English stop words listed in the tm package are removed.


## Guide for Usage the Code
     
This guide is for building WoSL Dictionary from WoSL Corpus:

    1. Install libraries
    2. Create directory for writing files
    3. Prepare (or use) the list of words for substitution and list of prefixes  
    4. Change paths of directories for reading and writing files, and list of substitution and prefixes
    5. Run the code

      
    Outputs of the Code
    
All output files are saved in the output directory. The outputs of the code are listed below:
  
    1.MetaData.RData: MetaData file contains all fields in a docuemnt of Wosl Corpus excluding abstract. 
    2.Abstracts.RData: The file contains all abstracts after pre-processing steps defined above. 
    3.DTM.RData: DTM is the Document Term Matrix constructed from the Corpus. In DTM, rows correspond to documents in the collection and columns correspond to terms (words). Each entry of the matrix is the number of times the word occurs in the corresponding document.
    4.WoSL_Dictionary.RData/WoSL_Dictionary.csv: WoSL_Dictionary is the ordered list of unique words with the number of documents containing the word and the number of appearance of the word in the corpus. Words are sorted by the number of documents containing words in descending order. All words are in          lowercase and their stem forms.   
  
  
  
  
  
