library(readr)
library(purrr)
library(dplyr)
devtools::load_all("../andre_rocc/")

#load checked names
names_cerrado <- read_csv("./output/03_double_check_string.csv")

# using a loop to catch errors in check_flora()
  res <- list()
  for (i in 1:length(unique(names_cerrado$scientificName_new))) {
    res[[i]]  <- check_flora(unique(names_cerrado$scientificName_new)[i])
    print(i)
  }
  beepr::beep(2)
#the list has to have names for bind_rows
names(res) <- unique(names_cerrado$scientificName_new)

#some elements have synonyms: potential problem with output.
res$`Pilocarpus pennatifolius`

# here I take only the $taxon dataframe and join everything
# later I perceived that I included hybrids in this approach so maybe that explains part of the non-accepted names
res_taxon <- res %>%
  purrr::map_df(., ~.$taxon)
count(res_taxon, scientificname, taxonomicstatus)#yeah, here :(

# take the synonyms and join everything
res_syns <- res %>%
  purrr::map_df(., ~.$synonyms)
head(res_taxon)
head(res_syns)
dim(res_taxon)
dim(res_syns)

write_csv(res_taxon, "./output/08_taxon_results.csv")
write_csv(res_syns, "./output/09_synonyms_results.csv")
count(res_taxon, taxonomicstatus)
count(res_taxon, taxonomicstatus, synonyms)#aqui erros na base
count(res_taxon, taxonomicstatus, is.na(acceptednameusage))#aqui erros na base
res_taxon %>% filter(is.na(taxonomicstatus)) %>% View()
res_taxon %>% filter(is.na(taxonomicstatus), is.na(acceptednameusage)) %>% View()
# we have to explore these outputs and what comes next.
# maybe a dataframe with the original name and the synonyms that will be used for occurrence search.

#but first I want to run everything faster.

#using purrr is supposed 1. to work 2. to be faster # none of this happened.
check_taxon_res <- names_cerrado %>%
  #i took the ybrids out
  filter(scientificName_status != "hybrid_species") %>%
  select(scientificName_new) %>%
  #I should have run distinct but I didn't
  distinct() %>%
  pull() %>%
  purrr::map(.,
             .f = function(x) {
               rocc::check_flora(scientificName = x,
                                 get_synonyms = TRUE,
                                 infraspecies = FALSE)
               })
#plus I think there's a problem with infraspecies parameter.
