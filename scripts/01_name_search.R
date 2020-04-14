library(readr)
library(dplyr)
library(purrr)
devtools::load_all("../andre_rocc/")

cerrado_endemics <- search_flora(domain = "Cerrado",
                                 endemism = TRUE)
cerrado_all <- search_flora(domain = "Cerrado")
write_csv(cerrado_endemics, "./output/01_all_names.csv")

# Check names
check_names_df <- purrr::mapdf(cerrado_endemics$scientificName,
                          ~rocc::check_string(scientificName = .))
write_csv(check_names_df, "./output/02_check_string.csv")

table(check_names_df$scientificName_status)
# I did a semi-thourough checking of the results and reported them to Sara.
# Flora output has authors so we have to assume that check_string will get lots of authors all the time.

# ikinci kez para terminar de limpiar
check_names_iki <- purrr::map_df(check_names_df$scientificName_new,
                          ~rocc::check_string(scientificName = .))
write_csv(check_names_iki, "./output/03_double_check_string.csv")

#So indet is catching genera and flora also returns families so at least we have to filter that - I'll just do it the third time to have something.
check_names <- check_names_iki %>%
  filter(!scientificName_status %in% c("indet", "family_as_genus"))
table(check_names$scientificName_status)

check_names_üç <- purrr::map_df(check_names$scientificName_new,
                                 ~rocc::check_string(scientificName = .))
write_csv(check_names_üç, "./output/04_checked_names.csv")
table(check_names_üç$scientificName_status)
# paro aqui para resolver el resto - hay cosas que persisten y ya lo sabía


#check taxon
rocc::check_taxon(check_names_df$scientificName_new)
