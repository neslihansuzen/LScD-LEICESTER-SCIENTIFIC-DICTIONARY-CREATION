   # LSD (LEICESTER SCIENTIFIC DICTIONARY) CREATION
This repository contains R code to create a dictionary from a corpus of documents


   ## What is 'LSD_Creation.R'?

'LSD_Creation' is an R code that processes the collection of texts and create the list of words from the collection. This script provides a detailed explanation of the code and includes information on the pre-processing steps were performed, and output files were created.

The code is written for building LSD from LSC to be used by Neslihan Suzen for her PhD project, and it can be used for other corpuses for a wide verity of applications that includes pre-processing the collection of texts, creating DTM and producing a list of words from the collection of texts. The code can be also used to reproduce LSD.

Use of the LSC is subject to acceptance of request of the link by email. To access the LSC for research purposes, please email to ns433@le.ac.uk. For more information, see(link to figsahe for LSC)  LSD can be found in ...(refer to LSD in fogshare)


   ## Usage for 'LSD_Creation.R'

'LSD_Creation.R' can be easily downloaded from GitHub.

The code requires the following R packages: tm, SnowballC, slam, plyr. Packages can be installed by

    install.packages(c("tm","SnowballC","slam","plyr"))

'LSD_Creation.R' contains 4 parameters of paths 'sourceDir', 'outDirectory', 'prefFileName' and 'substFileName' described below:

     sourceDir     : Directory with source files (.csv files)
     outDirectory  : Directory to write metadata files and processed documents
     prefFileName  : Directory for the file 'List of prefixes'
     substFileName : Directory for the file 'List of substitution'
  
These locations should be changed by the user for reading and writing files. 

The code consists of three functions, 'pattern' to create gsub pattern for list of prefixes, 'preprocessing' to process the collection of texts and 'Split_abstract' to split the dataframe of asbstracts into several sub dataframes for running the function 'Preprocessing' fatster. Preprocessing function consists the following operations:

   1.	**Removing punctuations and special characters:** This is the process of substitution of all non -alphanumeric characters by space exclusing '-' 
   2.	**Lowercasing the text data:** Entire collection of texts are converted to lowercase. 
   3.	**Uniting prefixes of words:** Words containing prefixes joined with character "-" are united as a word. The list of prefixes united for this research are listed in the file "list_of_prefixes.csv". 
   4.	**Substitution of words:** Some of words joined with "-" in the abstracts of the LSC require an additional process of substitution to avoid losing the meaning of the word before removing the character "-". The full list of such words and decision taken for substitution are presented in the file "list_of_substitution.csv". 
   5.	**Removing the character "-":** All remaining character "-" are replaced by space. 
   6.	**Removing numbers:** All digits which are not included in a word are replaced by space. All words that contain digits and letters are kept for this study.
   7.	**Stemming:** In this process, multiple forms of a specific word are eliminated and words that have the same base in different grammatical forms are mapped to the same stem. 
   8.	**Stop words removal:** All English stop words listed in the tm package are removed.


   ## Guide for Usage the Code
     
This guide is for building LSD from LSC:

    1. Install libraries
    2. Prepare (or use) the list of words for substitution and list of prefixes  
    3. Change paths of directories for reading and writing files, and list of substitution and prefixes
    4. Run the code

      
  ##  Outputs of the Code
    
All output files are saved in the 'outDirectory'. The outputs of the code are listed below:
  
   1.**MetaData.RData:** MetaData file contains all fields in documents of LSC excluding abstracts. For LSD, this file will contain fields List_of_Authors, Title, Categories, Research_Areas, Total_Times_Cited and Times_cited_in_Core_Collection.
   2.**Abstracts.RData:** The file contains all abstracts after pre-processing steps defined above.This file contains stemmed of words. All stop words are deleted. 
   3.**DTM.RData:** DTM is the Document Term Matrix constructed from the Corpus. In DTM, rows correspond to documents in the collection and columns correspond to terms (words). Each entry of the matrix is the number of times the word occurs in the corresponding document.
   4.**LSD.RData/LSD.csv:** LSD is the ordered list of unique words with the number of documents containing the word and the number of appearance of the word in the corpus. Words are sorted by the number of documents containing words in descending order. All words are in lowercase and their stem forms.   
  
  
  
  ## Warning
 
The code can be applied for list of texts from any source with changes of parameter. We note that the structure of the corpus such as file format and names (also the position) of fields should be taken into account to apply our code.
For LSC, abstracts must be in the THIRD column. 
  
  
  
