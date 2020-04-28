library(readr)
library(dplyr)
library(purrr)
devtools::load_all("../andre_rocc/")

cerrado_endemics <- search_flora(domain = "Cerrado",
                                 endemism = TRUE,
                                 lifeform = c("Árvore", "Arbusto"))
write_csv(cerrado_endemics, "./output/01_all_names.csv")

# Check names
check_names_df <- purrr::map_df(cerrado_endemics$scientificName,
                          ~rocc::check_string(scientificName = .))
write_csv(check_names_df, "./output/02_check_string.csv")

table(check_names_df$scientificName_status)

# ikinci kez para terminar de limpiar
check_names_iki <- purrr::map_df(check_names_df$scientificName_new,
                          ~rocc::check_string(scientificName = .))
write_csv(check_names_iki, "./output/03_double_check_string.csv")
table(check_names_iki$scientificName_status)
#prfct
check_names_iki %>% filter(scientificName_status != "possibly_ok") %>% View()
