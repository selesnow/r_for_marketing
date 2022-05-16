# запрос данных
library(rfacebookstat)
# установка опций
options(rfacebookstat.accounts_id  = "act_262115113",
        rfacebookstat.access_token = "EAACg7dbgLXMBAOyRube7lWcfeZALDxK5Fl3vnRs3veDyhZB8ZC22NZBCLRwxOkG0dgZCiz5pxeBV52jVgZB933P9wC84ovBMb0YOghItkfTsucQgNA4qBigADG4ZA42Ky5TJ7n3FA9NH4zt8bc3yuU8NciXDTTmS38ZD")

my_fb_stats <- fbGetMarketingStat(level = "ad",
                                  fields = "account_name,campaign_name,ad_id,impressions,clicks",
                                  breakdowns = "impression_device",
                                  date_start = Sys.Date() - 20,
                                  date_stop = Sys.Date() - 1,
                                  interval = "day")

# установка пакетов
# devtools::install_github("bescoto/RMSSQL")

# подключаем пакет
library(RMSSQL)
library(DBI)

ms_con <- dbConnect(MSSQLServer(), 
                    host     = 'localhost', 
                    user     = 'rteacher', 
                    password = 'r_teach@15', 
                    dbname   = "r_course")

# write data
dbWriteTable(ms_con,
             "fb_data",
             my_fb_stats)

# load data from mysql
mysql_table <- dbReadTable(conn = ms_con, name = "fb_data")

# load by sql query
query_table <- dbGetQuery(conn = ms_con,
                          statement = "SELECT impression_device, SUM(CAST(clicks AS INT)) as clicks
                                       FROM fb_data
                                       GROUP BY impression_device")

# search table
dbListTables(ms_con)
dbExistsTable(conn = ms_con, "fb_data")

# drop table
dbRemoveTable(conn = ms_con, "fb_data")

# check
dbListTables(ms_con)

# disconnet
dbDisconnect(ms_con)
