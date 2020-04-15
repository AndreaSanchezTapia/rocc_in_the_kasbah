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
test_remove_summary <- test_remove %>% filter(empty == FALSE) %>%
#there are vars, subsp and f. we knew that
  filter(!Anything_else %in% c("subsp.", "var.", "f."))
View(test_remove_summary)

readr::write_csv(test_remove_summary, "./output/05_test_remove_authors.csv")
