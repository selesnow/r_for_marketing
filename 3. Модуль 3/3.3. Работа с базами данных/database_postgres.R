# Work with databases
install.packages("RPostgreSQL")
library(RPostgreSQL)
library(rfacebookstat)

# connect
con <- dbConnect(drv = PostgreSQL(),
                 user = "course",
                 password = "u12pl907s+",
                 host     = "localhost",
                 port     = "5432",
                 dbname   = "cours_db_pg")

# check connection
dbGetInfo(con)

# load data
# fb load
load("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 4\\fb_token.RData")

my_fb_stats <- fbGetMarketingStat(accounts_id = "act_262115113",
                                  level = "ad",
                                  fields = "campaign_name,ad_id,impressions,clicks",
                                  breakdowns = "impression_device",
                                  date_start = Sys.Date() - 20,
                                  date_stop = Sys.Date() - 1,
                                  interval = "day",
                                  access_token = fb_token)
# send to mysql
dbWriteTable(conn        = con,
             value       = my_fb_stats,
             name        = "fb_data",
             append      = TRUE,
             overwrite   = FALSE,
             row.names   = FALSE,
             field.types = c(campaign_name     = "character(300)",
                             ad_id             = "bigint",
                             impressions       = "integer",
                             clicks            = "integer",
                             date_start        = "date",
                             date_stop         = "date",
                             impression_device = "character(100)"))
str(my_fb_stats)
# load data from mysql
pgsql_table <- dbReadTable(conn = con, name = "fb_data")

# load by sql query
query_pgsql <- dbGetQuery(conn = con,
                          statement = "SELECT impression_device, SUM(clicks) as clicks
                                       FROM fb_data
                                       GROUP BY impression_device")

# fields of table
dbListFields(conn = con, "fb_data")

# search table
dbListTables(con)
dbExistsTable(conn = con, "fb_data")

# drop table
dbRemoveTable(conn = con, "fb_data")

# check
dbListTables(con)

# disconnect
dbDisconnect(con)
