# Work with Google Search Console
devtools::install_github("MarkEdmondson1234/searchConsoleR")
library(searchConsoleR)
library(googleAuthR)

# go to work directory
setwd("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 9")

# Auth
service_token <- scr_auth()

# Get Sites
web_sites <- list_websites()

# Get Stat
gsc_stat <- search_analytics(siteURL    = "http://selesnow.github.io/",
                             startDate  = "2018-08-01",
                             endDate    = "2018-08-13",
                             dimensions =  c("date", "page", "query"),
                             searchType = "web",
                             rowLimit   = 5000)

# Get around limits
devices <- c("DESKTOP", "MOBILE", "TABLET")
sc_result <- list()

for (dev in devices) {
  
  n <- length(sc_result) + 1
  
  sc_result[[n]] <- search_analytics(siteURL    = "http://selesnow.github.io/",
                                     startDate  = "2018-08-01",
                                     endDate    = "2018-08-13",
                                     dimensions =  c("date", "page", "query"),
                                     dimensionFilterExp = paste0("device==", dev),
                                     searchType = "web")
}

gsc_stat <- dplyr::bind_rows(sc_result)

################################################
# Google trends ================================
################################################

devtools::install_github('PMassicotte/gtrendsR')
library(gtrendsR)

# query
res <- gtrends(keyword = c("google adwords", 
                           "яндекс директ", 
                           "google ads", 
                           "facebook ads"), 
               geo     = c("RU", "UA", "KZ", "BY"),
               gprop   = "web",
               time    = "2018-04-01 2018-08-01")

# results
by_city    <- res$interest_by_city
by_region  <- res$interest_by_region
over_time  <- res$interest_over_time

# to tidy
library(tidyr)
library(dplyr)

# by keywords
tidy_res <- over_time %>%
              group_by(date, keyword) %>%          # grouping
              summarise(hits = sum(hits)) %>%      # aggregate
              spread(key = keyword , value = hits) # tidying

# by country
tidy_res_country <- over_time %>%
                      group_by(date, geo) %>%          # grouping
                      summarise(hits = sum(hits)) %>%  # aggregate
                      spread(key = geo , value = hits) # tidying
