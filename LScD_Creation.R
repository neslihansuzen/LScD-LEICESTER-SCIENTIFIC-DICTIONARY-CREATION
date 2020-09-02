# This script contains the code for creating LScD (Leicester Scientific Dictionary) from LSC (Leicester Scientfic Corpus) or any other 
#   corpus with appropriate structure (vide readme) of original csv files. 

# The outputs of the code are: 
# 1) Metadata file with all fields of original csv files exclude field 'abstract'. For LSC 
#    this file will contain fields List_of_Authors, Title, WoS_Categories, Research_Areas, 
#    Total_Times_Cited and Times_cited_in_WoS_Core_Collection. 
# 2) File of abstracts: All abstracts in the corpus after pre-processing steps defined in 
#    preprocessing function below. This file contains stemmed of words. All stop words are deleted.
# 3) LScD file: ordered list of words from LSC with the number of documents containing the word and 
#    the occurance of the word in entire corpus when the corpus is considered as one large document.
# 4) DTM(document term matrix of all documents)

# Libraries needed
library(tm)
library(SnowballC)
library(slam)
library(plyr)
library(gtools)

# Paramaters of script
# Change paths below by your actual paths

# Directory with source files (.csv)
sourceDir = "\\.\\LSC"
# Directory to write metadata files and file of abstracts (processed documents)
outDirectory = "\\.\\LScD"
# File name of List of prefixes
prefFileName = "\\.\\list_of_prefixes.csv"
# File name of List of substitution
substFileName = "\\.\\list_of_substitution.csv"


# Split is the number of rows to be contained in each element of the list while splitting 'abstract' in the function 'Split_abstract' below.
# We splitted abstract as 50000 documents in each element of the list
split = 50000

# Import all .csv files from the data directory and unite them into a single data frame called LSC
file.names = list.files(sourceDir, "\\.csv$",full.names = TRUE)
file.names = mixedsort(file.names)
LSC = do.call(rbind,lapply(file.names, read.csv))
rm(file.names)

# Split dataframe into two parts. ABSTRACTS MUST be in the THIRD column!
metaD = LSC[-3]  # remove abstracts
# Save metadata
save(metaD, file=paste0(outDirectory, '\\MetaData.RData'))
abstract = LSC[3]
rm(metaD, LSC)

# List of prefixes and substitution should be imported form the files defined above
list_of_prefixes = read.csv(prefFileName)
list_of_substitution = read.csv(substFileName)

# Function which creates regular expression pattern for whole list of prefixes 
ListOfPrefixes = function(data){
    words = unlist(c(data))
    pattern = paste0("[[:space:]-]",words)
    pattern = paste0(pattern, collapse = "|")
    pat = paste0("(", pattern,")","-","([[:alnum:][:space:]-])")
    return(pat)
}

pattern = ListOfPrefixes(list_of_prefixes)

# Function for pre-process the collection of texts
# 'data' is the collection of texts ('LSC') in the one column data frame
# 'pattern' is pattern to process prefixes (vide function ListOfPrefixes above)
# 'list_of_substitution' is data frame with two columns: word(s) to find in the first 
#     column and replacement in the second column
#
# Return list of pre-processed abstracts in the VCorpus format
preprocessing = function(data, pattern, list_of_substitution){
  
    # Add space to the beginning and the end of the text
    data = paste0(' ', data$Abstract,' ')
    doc = as.character(data)
    # Remove all characters excluding words, numbers and minus(-), non-alphanumeric characters 
    doc = gsub("[^[:alnum:]-]", " ", doc) 
    # Normalise all cases in the text to lower case
    doc = tolower(doc)
    # Unite prefix with the next word
    doc = gsub(pattern,"\\1\\2",doc)
    # Substitute words from specified list 
    words = as.character(list_of_substitution[,1])
    words2 = as.character(list_of_substitution[,2])
        for(i in  1:length(words)){
          pat = paste0("[[:space:]-]", words[i])
          pat2 =  paste0(" ", words2[i])
          doc = gsub(pat,pat2,doc)
        }
    # Remove all other '-'
    doc = gsub("[^[:alnum:][:space:]]", " ", doc)
    # Remove numbers, keep words with numbers
    doc = gsub("\\b\\d+\\b", " ", doc)
    # Convert to VCorpus
    doc = VCorpus(VectorSource(doc))
    # Get rid of variety of ending for words so that they are uniform. This require the library(SnowballC) 
    doc = tm_map(doc, stemDocument)
    # Remove stop words
    doc = tm_map(doc, removeWords, stopwords("english"))  
    # Strip white spaces
    doc = tm_map(doc, stripWhitespace) 
    # Tell R  to treat the pre-processed documents as text documents
    doc = tm_map(doc, PlainTextDocument)  
    
    return(doc)
}

# Function to split abstracts into several list of abstracts and write all in a list
# This fucntion is created to make pre-processing function faster as the corpus size is huge
# DF is the 'abstract' to split, and split is the number of rows to be contained in each element of the list
Split_abstract = function(DF, split){
  # Make sure if the number of documents in DF can be divided by the split, 
  #  otherwise write the last list into another list then combine all
  if(nrow(DF) %% split == 0){
    DFlist = lapply(seq(1, nrow(DF), split), function(x, i){x[ i:(i+(split-1)),]}, x=DF)
    return(DFlist)
  }else{
    DFlist = lapply(seq(1, nrow(DF)-(nrow(DF) %% split), split), function(x, i){x[ i:(i+(split-1)),]}, x=DF)
    DFlist2 = list(DF[((nrow(DF)+1)-(nrow(DF) %% split)):nrow(DF),])
    final.list = do.call(c, list(DFlist, DFlist2))
    return(final.list)
  }
}

# Get the list of splitted DFs
List_abstract = Split_abstract(DF=abstract, split)

# Create empty list to be saved splitted abstracts
list = list()
# Read all elements of list separetely and create corpus (as list, each element of the 'corpus' contains approximetely 50000 abstracts)
for(i in 1:length(List_abstract)){
  dt = as.data.frame(List_abstract[[i]])
  colnames(dt) = 'Abstract'
  corpus = preprocessing(dt, pattern, list_of_substitution)
  list[[i]] = corpus
}
# Unite all list of corpuses in the list
# Create VCorpus with all documents in LSC
corpus = do.call(tm:::c.VCorpus, list)

rm(abstract)

# Save pre-processed corpus as VCorpus
save(corpus, file=paste0(outDirectory, '\\Abstracts.RData'))

############################################
# This section of the code creates LScD (Leicester Scientific Dictionary) 
# The outputs of the code are:
#   1) LScD file: ordered list of words from LSC with the number of documents containing the word and the occurance of the word 
#      in entire corpus when the corpus is considered as one large document.The list is also saved as CSV file.
#   2) DTM (document term matrix of all documents).

# Creating DTM with all documents in the corpus
DTM = DocumentTermMatrix(corpus)

# Save DTM to outDirectory
save(DTM, file=paste0(outDirectory, '\\DTM.RData'))
rm(corpus)

# Build the LScD 
# Calculate basic statistics of words in the corpus:
#   1) Calculate the number of documents containing each word (binary representation for existence)
#   2) Calculate the number of appearance of a word in the entire corpus when the corpus is considered as a single large document

# Calculate the number of documents for each word in DTM 
doc.number = table(DTM$j)

# Extract names (words) from DTM and combine with the numbers
names(doc.number) = DTM$dimnames$Terms
doc.number = as.data.frame(doc.number)

# Calculate the number of occurances of words in the corpus
number.occur = as.data.frame(rollup(DTM, 1, na.rm=TRUE, FUN = sum)$v) 

# Unite words, the number of documents and the number of occurances in a table, then order the table by the number of documents
final.table = cbind(doc.number,number.occur)
colnames(final.table) = c('Word', 'Number_of_Documents_Containing_Word','Number_of_Apperance_in_Corpus')
final.table = final.table [order(-final.table$Number_of_Documents_Containing_Word),] 
rm(doc.number,number.occur,DTM)

# Save the final list of words and statistics to outDiroctory as RData and CSV file
save(final.table,file=paste0(outDirectory, '\\LScD.RData'))
write.csv(final.table,file=paste0(outDirectory, '\\LScD.csv'),row.names = FALSE)

