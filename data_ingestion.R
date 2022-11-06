library(magrittr)

core_packages <- c(
  "ggplot2",
  "dplyr",
  "tidyr",
  "readr",
  "purrr",
  "tibble",
  "stringr",
  "forcats"
)
tidyverse_repositories <- paste0(
  "tidyverse/",
  core_packages
)

get_hex_sticker <- function(package) {
  glue::glue("https://raw.githubusercontent.com/rstudio/hex-stickers/master/SVG/{package}.svg")
}

get_repository_data <- function(repository) {
  package <- strsplit(repository, "/")[[1]][2]
  github_repository <- gh::gh("GET /repos/{repository}", repository = repository)
  top_5_contributors <- gh::gh(glue::glue("GET {github_repository$contributors_url}?q=contributions&order=desc&per_page=5"))
  tags <- gh::gh("GET /repos/{repository}/git/refs/tags", repository = repository)
  
  download_stats <- dlstats::cran_stats(package)
  download_stats <- head(download_stats, nrow(download_stats) - 1)
  
  
  tibble::tibble(
    hex_sticker = get_hex_sticker(github_repository$name),
    repo_url = github_repository$html_url,
    package_name = github_repository$name,
    description =  github_repository$description,
    stargazers = github_repository$stargazers_count,
    watchers = github_repository$watchers_count,
    tags = length(tags),
    download_stats = list(download_stats),
    top_5_contributors = list(top_5_contributors)
  )
}

all_data <- purrr::map(tidyverse_repositories, get_repository_data) %>% 
  dplyr::bind_rows() %>% 
  dplyr::arrange(dplyr::desc(stargazers))

saveRDS(all_data, "all_data.RDS")
