# install odbc
install.packages("odbc")

# attach
library(odbc)

# simple conect
con_odbc <- dbConnect(drv = odbc(),
                      Driver   = "SQL Server",
                      Server   = "localhost",
                      Database = "r_course",
                      UID      = "rteacher",
                      PWD      = "r_teach@15",
                      Port     = 1433)

# write data
dbWriteTable(con_odbc,
             "fb_data",
             my_fb_stats)

# load data from mysql
mysql_table <- dbReadTable(conn = con_odbc, name = "fb_data")

# load by sql query
query_table <- dbGetQuery(conn = con_odbc,
                          statement = "SELECT impression_device, SUM(CAST(clicks AS INT)) as clicks
                                       FROM fb_data
                                       GROUP BY impression_device")

# search table
dbListTables(con_odbc)
dbExistsTable(conn = con_odbc, "fb_data")

# drop table
dbRemoveTable(conn = con_odbc, "fb_data")

# check
dbListTables(con_odbc)

# disconnet
dbDisconnect(con_odbc)

# ############################

# DSN connect
# simple conect
con_odbc_dsn <- dbConnect(drv = odbc(),
                          DSN  = "forCourse",
                          UID  = "rteacher",
                          PWD  = "r_teach@15",
                          Port = 1433)

# write data
dbWriteTable(con_odbc_dsn,
             "fb_data",
             my_fb_stats)

# load data from mysql
mysql_table <- dbReadTable(conn = con_odbc_dsn, name = "fb_data")

# load by sql query
query_table <- dbGetQuery(conn = con_odbc_dsn,
                          statement = "SELECT impression_device, SUM(CAST(clicks AS INT)) as clicks
                                       FROM fb_data
                                       GROUP BY impression_device")

# search table
dbExistsTable(conn = con_odbc_dsn, 
              "fb_data")

# drop table
dbRemoveTable(conn = con_odbc_dsn, 
              "fb_data")

# search table
dbExistsTable(conn = con_odbc_dsn, 
              "fb_data")

# transactions
# start
dbBegin(con_odbc_dsn)

# rows num
dbReadTable(conn = con_odbc_dsn, name = "fb_data") %>% nrow()

# delite rows
dbExecute(con_odbc_dsn,
          "DELETE from fb_data
           WHERE clicks = 0 ")

# rows num
dbReadTable(conn = con_odbc_dsn, name = "fb_data") %>% nrow()

# roll back
dbRollback(con_odbc_dsn)

# rows num
dbReadTable(conn = con_odbc_dsn, name = "fb_data") %>% nrow()

# commit
dbCommit(con_odbc_dsn)

# rows num
dbReadTable(conn = con_odbc_dsn, name = "fb_data") %>% nrow()

# disconnet
dbDisconnect(con_odbc_dsn)
