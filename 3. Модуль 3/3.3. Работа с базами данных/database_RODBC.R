install.packages("RODBC")
library(RODBC)

# string connect
con_string <- odbcDriverConnect(connection = "Driver=SQL Server;
                                              Server=localhost;
                                              Database=r_course;
                                              UID=rteacher;
                                              PWD=r_teach@15; 
                                              Port=1433")
# DSN connect
con_dsn    <- odbcConnect(dsn = "forCourse",
                          uid = "rteacher",
                          pwd = "r_teach@15")

# write table
sqlSave(con_string,
        dat       = my_fb_stats,
        tablename = "fb_data")

# read table
sqltable <- sqlFetch(con_string, "fb_data", 
                     rownames = FALSE)

nrow(sqltable)

# append rows
sqlSave(con_string,
        dat       = my_fb_stats,
        tablename = "fb_data",
        append    = TRUE)

# read table
sqltable <- sqlFetch(con_string, "fb_data", 
                     rownames = FALSE)

nrow(sqltable)


# update date
unique(my_fb_stats$account_name)        # see values
my_fb_stats$account_name <- "MyAccount" # new values
unique(my_fb_stats$account_name)        # see values

sqlUpdate(con_string,
          dat       = my_fb_stats,
          tablename = "fb_data")

# read table
sqltable <- sqlFetch(con_string, "fb_data", 
                     rownames = FALSE)

unique(sqltable$account_name) 


sqlQuery(con_string, query = "SELECT count(*) FROM fb_data")

# drop table
sqlDrop(con_string, sqtable = "fb_data")

# transactions
# on transaction mode
odbcSetAutoCommit(con_string, autoCommit = FALSE)

# change data
my_fb_stats$account_name <- "Netpeak"
# change in db
sqlUpdate(con_string,
          dat       = my_fb_stats,
          tablename = "fb_data")
# check
sqlQuery(con_string, 
         query = "select distinct account_name from fb_data")
# rollback
odbcEndTran(con_string, commit = FALSE)
# check
sqlQuery(con_string, 
         query = "select distinct account_name from fb_data")

# ----- new transactions
sqlUpdate(con_string,
          dat       = my_fb_stats,
          tablename = "fb_data")
# commit
odbcEndTran(con_string, commit = TRUE)
# check
sqlQuery(con_string, 
         query = "select distinct account_name from fb_data")

# disconnect
odbcCloseAll()
odbcClose(con_dsn)
