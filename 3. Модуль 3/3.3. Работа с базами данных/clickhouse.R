devtools::install_github("hannesmuehleisen/clickhouse-r")

library(clickhouse)
library(DBI)
library(rmytarget)

# �����������
ch_con <- dbConnect(drv = clickhouse(), 
                    user = "default", 
                    host = "5.9.232.45", 
                    password = "47ZfgYoElDAdV0HePjr6N1OI2zBmFo", 
                    port = "8123")

########################
# �������� ������ �� MyTarget
########################

# �������� ������ ��������
clients <- myTarGetClientList(login = "agency_n",
                              token_path = "C:\\r_for_marketing_course\\������ 2\\���� 6\\tokens")

# �������� ���������� � ������������ �� �������� ���������� ��������
client_stat <-  myTarGetStats(date_from   = Sys.Date() - 7,
                              date_to     = Sys.Date(),
                              object_id   = clients$id,
                              object_type = "users",
                              metrics     = "all",
                              login       = "agency_n",
                              token_path = "C:\\r_for_marketing_course\\������ 2\\���� 6\\tokens")

########################
# ������ � ClickHuse
########################

# ������ �������
dbWriteTable(conn  = ch_con,
             name  = "client_stat",
             value = client_stat, 
             append = TRUE)

# ������ ������
dbListTables(ch_con)

# ������ ������
ch_data_1 <- dbReadTable(conn = ch_con,
                         name = "client_stat")
# �������� ��������� �������
ch_query_data <- dbGetQuery(ch_con,
                            "SELECT * FROM client_stat WHERE shows > 0")

# ������� �������
dbRemoveTable(ch_con, "client_stat")

# ������ ������
dbListTables(ch_con)

dbDisconnect(ch_con)
