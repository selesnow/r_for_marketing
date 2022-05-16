# Work with databases
install.packages("RMariaDB")
library(RMariaDB)
library(rfacebookstat)

# connect
con <- dbConnect(drv = MariaDB(),
                 user = "course",
                 password = "u12pl907s+",
                 host     = "localhost",
                 port     = "3306",
                 dbname   = "course_bd")

# fb load
load("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 4\\fb_token.RData")

my_fb_stats <- fbGetMarketingStat(accounts_id = "act_262115113",
                                  level = "ad",
                                  fields = "account_name,campaign_name,ad_id,impressions,clicks",
                                  breakdowns = "impression_device",
                                  date_start = Sys.Date() - 20,
                                  date_stop = Sys.Date() - 11,
                                  interval = "day",
                                  access_token = fb_token)


# send to mysql
dbWriteTable(conn      = con,
             value     = my_fb_stats,
             name      = "fb_data",
             append    = TRUE,
             overwrite = FALSE,
             row.names = FALSE)

# load data from mysql
mysql_table <- dbReadTable(conn = con, name = "fb_data")

# load by sql query
query_table <- dbGetQuery(conn = con,
                          statement = "SELECT impression_device, SUM(clicks) as clicks
                                       FROM fb_data
                                       GROUP BY impression_device")

query_table_2 <- dbSendQuery(conn = con,
                             statement = "SELECT impression_device, SUM(clicks) as clicks
                             FROM fb_data
                             GROUP BY impression_device")

class(query_table_2)
dbGetInfo(query_table_2) # query info
query_table_2_data <- dbFetch(res = query_table_2, n = -1) # get data
dbGetInfo(query_table_2) # query info
dbClearResult(query_table_2)  # cleare
dbGetInfo(query_table_2) # query info

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

