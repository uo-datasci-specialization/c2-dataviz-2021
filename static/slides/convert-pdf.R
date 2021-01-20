rmds <- fs::dir_ls(here::here("static", "slides"), regexp = "w\\dp\\d\\.Rmd")
pdfs <- fs::dir_ls(here::here("static", "slides"), glob = "*.pdf")

rmd_weeks <- gsub(".+slides/(.+)\\..+", "\\1", rmds)
pdf_weeks <- gsub(".+slides/(.+)\\..+", "\\1", pdfs)

to_print <- rmds[!rmd_weeks %in% pdf_weeks]

purrr::walk(to_print, pagedown::chrome_print)
