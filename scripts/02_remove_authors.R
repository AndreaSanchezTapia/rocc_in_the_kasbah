library(magrittr)
devtools::load_all("../andre_rocc/")
library(dplyr)
library(purrr)
#testing only the output of remove_authors
cerrado_endemics <- readr::read_csv("./output/01_all_names.csv")
remove_authors <- cerrado_endemics$scientificName %>%
  purrr::map(., ~flora::remove.authors(taxon = .))
#names(remove_authors) <- cerrado_endemics$scientificName
test <- unlist(remove_authors)
head(test)#it's a named vector
final <- data.frame(names_original = names(test), names_wo_authors = test)
test_remove <- final %>%
  mutate(
  Genus = stringr::word(names_wo_authors, 1),
  Epithet = stringr::word(names_wo_authors, 2),
  Anything_else = stringr::word(names_wo_authors, 3)
  ) %>% mutate(empty = is.na(Anything_else))
test_remove %>% count(empty)
test_remove_summary <- test_remove %>% filter(empty == FALSE)
#there are vars, subsp and f. we knew that
#tira de todas as var?
  test_remove_summary %>%
  filter(Anything_else %in% c("var.")) %>% View()
  View(test_remove_summary)
#APARENTEMENTE SIM, NAO PRECISA FAZER ANTES VAR E DEPOIS R_A

  #tira de todas as SUBSP?
  test_remove_summary %>%
  filter(Anything_else %in% c("subsp.")) %>% View()
  View(test_remove_summary)
#APARENTEMENTE SIM, NAO PRECISA FAZER ANTES VAR E DEPOIS R_A
#var e subsp. tira bem os autores

  #tira de todas as f.?
  dotf <- test_remove_summary %>%
  filter(Anything_else %in% c("f."))
  readr::write_csv(x = dotf, path = "./output/06_sample_with_dotf.csv")
nrow(dotf)
  View(test_remove_summary)
#APARENTEMENTE SIM, NAO PRECISA FAZER ANTES VAR E DEPOIS R_A
#var e subsp. tira bem os autores

readr::write_csv(test_remove_summary, "./output/05_test_remove_authors.csv")


errors <- test_remove_summary %>%
  filter(!Anything_else %in% c("var.", "f.", "subsp."))
  readr::write_csv(errors, "./output/05_test_remove_authors.csv")
  check_errors <- rocc::check_string(errors$names_wo_authors)
check <- check_errors
check %<>% rename(names_wo_authors = scientificName)
resumen <- dplyr::left_join(errors, check)
names(resumen)
resumen %<>% select(names_original, names_wo_authors, scientificName_status, scientificName_new)
names(resumen)
readr::write_csv(resumen, "07_remove_then_check_string.csv")
