## ----setup, include=FALSE----------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ---- message=FALSE, warning =FALSE------------------------------------------------------------------------------------------------
#install.packages(c("dplyr", "dbplyr", "RSQLite", "stringr", "purrr"))


## ---- message=FALSE, warning =FALSE------------------------------------------------------------------------------------------------
library(dplyr)
library(dbplyr)
library(RSQLite)
library(stringr)
library(purrr)


## ----------------------------------------------------------------------------------------------------------------------------------
cuff_data.db <- DBI::dbConnect(RSQLite::SQLite(), './cuffData.db')


## ----------------------------------------------------------------------------------------------------------------------------------
dplyr::tbl(cuff_data.db, sql("SELECT name FROM sqlite_master WHERE type='table'")) 

## ----------------------------------------------------------------------------------------------------------------------------------
RSQLite::dbListTables(cuff_data.db) 


## ----------------------------------------------------------------------------------------------------------------------------------
tbl(cuff_data.db, sql("SELECT * FROM genes LIMIT 10"))


## ----------------------------------------------------------------------------------------------------------------------------------
genes <- tbl(cuff_data.db, "genes") 

genes %>%
  select(gene_id, gene_short_name, locus) %>%
  head(10)

show_query(head(genes, 10))


## ----------------------------------------------------------------------------------------------------------------------------------
genes %>%
  filter(substr(locus,1,4) == "chr1") %>%
  select(gene_id, gene_short_name, locus)  %>%
  head(10)
  
genes %>%
  filter(substr(locus,1,4) == "chr1") %>%
  select(gene_id, gene_short_name, locus) %>%
  show_query()


## ----------------------------------------------------------------------------------------------------------------------------------
genes %>%
  collect() %>%
  group_by(substr(locus,1,str_locate(locus, ":"))) %>%
  tally() 


## ----------------------------------------------------------------------------------------------------------------------------------
genes %>%
  collect() %>%
  filter(str_starts(locus, "chr1:")) %>%
  tally()


## ----------------------------------------------------------------------------------------------------------------------------------
genes %>%
  collect() %>%
  tally() 


## ----------------------------------------------------------------------------------------------------------------------------------
genes %>%
  summarize(
    n=n_distinct(gene_id)
    )

genes %>%
  summarize(
    n=n_distinct(gene_id)
    ) %>% 
  show_query()


## ----------------------------------------------------------------------------------------------------------------------------------
geneExpDiffData <- tbl(cuff_data.db, "geneExpDiffData")
head(geneExpDiffData, 10)

geneExpDiffData %>%
  collect() %>%
  tally() 


## ----------------------------------------------------------------------------------------------------------------------------------
geneData <- tbl(cuff_data.db, "geneData")
head(geneData, 10)

geneData %>%
  collect() %>%
  tally() 


## ----------------------------------------------------------------------------------------------------------------------------------
genes %>%
  inner_join(geneExpDiffData, by="gene_id") %>%
  select(-c(class_code, nearest_ref_id, length, coverage)) %>%
  filter(status == "OK" & significant == "yes") %>%
  head(10)

genes %>%
  inner_join(geneExpDiffData, by="gene_id") %>%
  select(-c(class_code, nearest_ref_id, length, coverage)) %>%
  filter(status == "OK" & significant == "yes") %>%
  show_query()

genes %>%
  inner_join(geneExpDiffData, by="gene_id") %>%
  select(-c(class_code, nearest_ref_id, length, coverage)) %>%
  filter(status == "OK" & significant == "yes") %>%
  tally()


## ----------------------------------------------------------------------------------------------------------------------------------
library(purrr)

diffExp <- reduce(
  list(genes, geneExpDiffData),
  right_join) %>%
  select(-c(class_code, nearest_ref_id, length, coverage)) %>%
  filter(status == "OK" & significant == "yes") 

diffExp %>% head(10)

diffExp %>% tally()

## ----------------------------------------------------------------------------------------------------------------------------------
library(purrr)

diffExp <- reduce(
  list(genes, geneExpDiffData),
  right_join) %>%
  select(-c(class_code, nearest_ref_id, length, coverage)) %>%
  filter(status == "OK" & significant == "yes" & !is.na(test_stat)) %>%
  arrange(log2_fold_change, q_value)

diffExp <- reduce(
  list(genes, geneExpDiffData),
  right_join) %>%
  select(-c(class_code, nearest_ref_id, length, coverage)) %>%
  filter(status == "OK" & significant == "yes" & !is.na(test_stat)) %>%
  arrange(log2_fold_change, q_value) %>%
  show_query()

diffExp %>% head(10)

diffExp %>% tally()

