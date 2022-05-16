# Work with databases
install.packages("bigrquery")
library(bigrquery)
library(dplyr)
library(rfacebookstat)

# go to wd
setwd("C:\\r_for_marketing_course\\Материалы курса\\Модуль 3\\Урок 3")

# fb load
load("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 4\\fb_token.RData")

my_fb_stats <- fbGetMarketingStat(accounts_id = "act_262115113",
                                  level = "ad",
                                  fields = "campaign_name,ad_id,impressions,clicks",
                                  breakdowns = "impression_device",
                                  date_start = Sys.Date() - 20,
                                  date_stop = Sys.Date() - 11,
                                  interval = "day",
                                  access_token = fb_token)

# Low-level API
# write data
bq_table(project = "rcourse-215606",
         dataset = "course_ds",
         table   = "bq_fb") %>%
  bq_table_upload(x = .,
                  values = my_fb_stats,
                  create_disposition = "CREATE_IF_NEEDED",
                  write_disposition = "WRITE_APPEND")

# load table
bq_table <- bq_table(project = "rcourse-215606",
                     dataset =  "course_ds",
                     table = "bq_fb") %>%
              bq_table_download()

# load by sql
sql_text <- "SELECT impression_device, SUM(clicks) as clicks
             FROM course_ds.bq_fb
             GROUP BY impression_device"

# project
bq_query_p <- bq_project_query(x              = "rcourse-215606",
                               query          = sql_text,
                               use_legacy_sql = TRUE) %>%
              bq_table_download()

# dataset
sql_text <- "SELECT impression_device, SUM(clicks) as clicks
             FROM bq_fb
             GROUP BY impression_device"

bq_query_ds <- bq_dataset(project = "rcourse-215606",dataset =  "course_ds") %>%
                bq_dataset_query(query = sql_text) %>%
                bq_table_download()

# exist table
bq_table(project = "rcourse-215606",dataset =  "course_ds", table = "bq_fb") %>%
  bq_table_exists()

# fields
bq_table(project = "rcourse-215606",dataset =  "course_ds", table = "bq_fb") %>%
  bq_table_fields()

# remove table
bq_table(project = "rcourse-215606",dataset =  "course_ds", table = "bq_fb") %>%
  bq_table_delete()

bq_table(project = "rcourse-215606",dataset =  "course_ds", table = "bq_fb") %>%
  bq_table_exists()

# DBI
con <- dbConnect(drv     = bigquery(),
                 project = "rcourse-215606",
                 dataset = "course_ds")

# write
dbWriteTable(conn  = con,
             name  = "bq_fb",
             value = my_fb_stats,
             append    = TRUE,
             overwrite = FALSE,
             row.names = FALSE)

# read
bq_table_2 <- dbReadTable(con, "bq_fb")

# read sql
bq_sql     <- DBI::dbGetQuery(conn = con,
                              statement = "SELECT impression_device, SUM(clicks) as clicks
                              FROM bq_fb
                              GROUP BY impression_device")

# fields of table
dbListFields(conn = con, "bq_fb")

# search table
dbListTables(con)
dbExistsTable(conn = con, "bq_fb")

# drop table
dbRemoveTable(conn = con, "bq_fb")

# check
dbListTables(con)

# disconnect
dbDisconnect(con)
