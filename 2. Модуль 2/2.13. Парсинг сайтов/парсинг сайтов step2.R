# Web scrapping
library(rvest)

# ########################
# Simple scrapping########
##########################

# read html
world_news_html <- read_html("https://www.google.com/search?q=world+news", encoding = "CP1251")

results <- html_nodes(world_news_html, css = "#resultStats") %>% html_text()

# Get all search result data

search_pars <- list()

# Get titles
search_res_titles <- html_nodes(world_news_html, css = ".r")

for (i in 1:length(search_res_titles)) {
   n <- length(search_pars$titles) + 1
   search_pars$titles[[n]] <- html_text(search_res_titles[[i]])
}

# Get body
search_res_text <- html_nodes(world_news_html, css = ".s .st")

for (i in 1:length(search_res_text)) {
  n <- length(search_pars$body) + 1
  search_pars$body[[n]] <- html_text(search_res_text[[i]])
}

# Get links
search_links <- html_nodes(world_news_html, css = ".r a")

for (i in 1:length(search_links)) {
  n <- length(search_pars$links) + 1
  search_pars$links[[n]] <- html_attr(search_links[[i]], "href")
}


search_output <- dplyr::bind_cols(search_pars)

