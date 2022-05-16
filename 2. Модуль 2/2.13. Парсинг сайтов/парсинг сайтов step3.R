# ########################
# Parsing 5 pages ########
##########################
pages <- seq(from = 0, to = 40, by = 10)

res_5_pages <- data.frame()

query <- "russia+weather"

for (p in pages) {
  
  url <- paste0("https://www.google.com/search?q=",query, "&start=", p)
  message(url)
  world_news_html <- read_html(url, encoding = "CP1251")
  
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
    n <- length(search_pars$boby) + 1
    search_pars$boby[[n]] <- html_text(search_res_text[[i]])
  }
  
  # Get links
  search_links <- html_nodes(world_news_html, css = ".r a")
  for (i in 1:length(search_links)) {
    n <- length(search_pars$links) + 1
    search_pars$links[[n]] <- html_attr(search_links[[i]], "href")
  }
  
  search_output <- dplyr::bind_cols(search_pars)
  res_5_pages   <- dplyr::bind_rows(res_5_pages, search_output)
  rm(list = c("search_output", "search_pars"))
  Sys.sleep(3)
}
