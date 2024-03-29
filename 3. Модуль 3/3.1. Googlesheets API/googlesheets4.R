# install
devtools::install_github("tidyverse/googlesheets4")

# lib
library(googlesheets4)

# �������� API
browseURL("https://console.developers.google.com/apis/library/sheets.googleapis.com?project=rcourse-215606&pli=1&authuser=3")

# ��� gargle ��������� ������� ������ �� ���������
# C:\Users\username\.R\gargle\gargle-oauth
# ����������� ����� ��� ����������
sheets_auth_configure(path = "C:/Users/Alsey/course_r_test.json")

# ���� ������� id � ������ ����������
# httr::oauth_app(appname = "client_for_tube", 
#                 key    = "927608779235-kilok85drtmq1jmnse08kvo3nnqdtfgf.apps.googleusercontent.com", 
#                 secret = "v2ksyQTtrPgW07xd-r6aWB_W")

sheets_auth(email = "r.for.marketing@gmail.com")
sheets_auth(email = "alsey.netpeak@gmail.com")

# �������� ������
# start data loading
library(googleAnalyticsR)
my_core_data_7d <- google_analytics(viewId     = "170507937",
                                    date_range = c("7daysAgo", "yesterday"),
                                    metrics    = c("ga:users", "ga:sessions", "ga:bounces"),
                                    dimensions = c("ga:date", "ga:source", "ga:medium"), 
                                    order      = order_type("ga:date", "DESCENDING"))
                            
my_core_data_14d <- google_analytics(viewId     = "170507937",
                                     date_range = c("14daysAgo", "8daysAgo"),
                                     metrics    = c("ga:users", "ga:sessions", "ga:bounces"),
                                     dimensions = c("ga:date", "ga:source", "ga:medium"), 
                                     order      = order_type("ga:date", "DESCENDING"))
# ������ ����
ss <- sheets_create("course_demo_ga", 
                    sheets = list(last7days = my_core_data_7d, 
                                  last14days = my_core_data_14d))
# ������� ��������� Google Dox
sheets_browse(ss)

# ������� ����� ����
sheets_sheet_add(ss, 
                 sheet = "last7_2days", 
                 .after = "last7days")

# ������ ������ �� ����� ����
sheets_write(data = my_core_data_7d,
             ss = ss, 
             sheet = "last7_2days_new")

# �������� ���������
sheets_append(data  = my_core_data_7d,
              ss    = ss, 
              sheet = "last7_2days_new")

# �������� ������ ������ google �������
sheets_sheet_names(ss)

# ������ ���� ���� ������
my_ss_list <- sheets_find()

# ������ ����� �� ���� ������
ss <- as_sheets_id("13R-zzn-2UH2yY6zrYocn4fA9mgmbCJiKxDUfJbbmlSo")

data <- sheets_read(ss, 
                    sheet = "last14days")

# ����� ���������
data2 <- as_sheets_id("13R-zzn-2UH2yY6zrYocn4fA9mgmbCJiKxDUfJbbmlSo") %>%
         sheets_read("last14days")

