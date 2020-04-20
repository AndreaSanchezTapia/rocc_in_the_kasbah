library(readr)
library(dplyr)
library(purrr)
devtools::load_all("../andre_rocc/")

cerrado_all <- search_flora(domain = "Cerrado")
cerrado_endemics <- search_flora(domain = "Cerrado",
                                 endemism = TRUE)
write_csv(cerrado_endemics, "./output/01_all_names.csv")

# Check names
check_names_df <- purrr::map_df(cerrado_endemics$scientificName,
                          ~rocc::check_string(scientificName = .))
write_csv(check_names_df, "./output/02_check_string.csv")

table(check_names_df$scientificName_status)

# I did a semi-thorough checking of the results and reported them to Sara.
# Flora output has authors so we have to assume that check_string will get lots of authors all the time.
check_names_df %>% filter(scientificName_status == "forma") %>% View()
check_names_df %>% filter(scientificName_status == "hybrid_species") %>% View()
check_names_df %>% filter(scientificName_status == "subspecies") %>% View()
check_names_df %>% filter(scientificName_status == "variety") %>% View()
check_names_df %>% filter(scientificName_status == "name_w_authors") %>% head() %>% View()
check_names_df %>% filter(scientificName_status == "indet") %>% View()
# ikinci kez para terminar de limpiar
check_names_iki <- purrr::map_df(check_names_df$scientificName_new,
                          ~rocc::check_string(scientificName = .))
write_csv(check_names_iki, "./output/03_double_check_string.csv")
table(check_names_iki$scientificName_status)
check_names_iki %>% filter(scientificName_status == "hybrid_species") %>% View()
check_names_iki %>% filter(scientificName_status == "indet") %>% View()
check_names_iki %>% filter(scientificName_status == "name_w_non_ascii") %>% View()
check_names_iki %>% filter(scientificName_status == "species_nova") %>% View()

#no more need for the third check because everything that was not possibly ok has no way to resolve
