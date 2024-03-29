# googleAnalyticsR
devtools::install_github('MarkEdmondson1234/googleAnalyticsR')
library(googleAnalyticsR)
library(googleAuthR)

# авторизация
## создаём учётные данные в google cloud
## включаем Google Analytics API
googleAuthR::gar_set_client(json = "C:/ga_auth/app.json")

## создаём сервисный аккаунт
## авторизуемся через сервисный аккаунт
ga_auth(json_file = "C:/ga_auth/service.json")

# ###################################
# запрашиваем список представлений
accounts <- ga_account_list()

# выбираем представление 
acc_id <- 44472206
wp_id  <- 'UA-44472206-1'
ga_id  <- 77219967

# запрашиваем список пользователей из аккаунта, ресурса или представления
users <- ga_users_list(accountId     = acc_id,
                       webPropertyId = wp_id,
                       viewId        = ga_id)

# расшарить доступ
ga_users_add(email = 'alsey.netpeak@gmail.com',
             permissions = 'READ_AND_ANALYZE',
             accountId   = acc_id,
             webPropertyId = wp_id,
             viewId        = ga_id)

# отменить доступ
ga_users_delete(email = 'alsey.netpeak@gmail.com',
                accountId = acc_id)

# запрашиваем список объектов 
filters  <- ga_filter_list(accountId = acc_id)   # фильтры
segments <- ga_segment_list()                    # сегменты
goals    <- ga_goal_list(accountId = acc_id,     # цели
                         webPropertyId = wp_id,
                         profileId = ga_id)     

# ###################################
# статистика 
browseURL('https://ga-dev-tools.appspot.com/dimensions-metrics-explorer/')
meta <- ga_meta()

report_1 <- google_analytics(ga_id, 
                             date_range = c("2020-01-01", "2020-01-10"), 
                             metrics    = c("sessions" , "bounces"), 
                             dimensions = c("date", "source"))

# сравнение данных за период
report_2 <- google_analytics(ga_id, 
                 date_range = c("16daysAgo", "9daysAgo", "8daysAgo", "yesterday"), 
                 dimensions = "source",
                 metrics    = "sessions")

# фильтрация данных
mf  <- met_filter("bounces", "GREATER_THAN", 0)
mf2 <- met_filter("sessions", "GREATER", 2)

df  <- dim_filter("source","BEGINS_WITH","1",not = TRUE)
df2 <- dim_filter("source","BEGINS_WITH","a",not = TRUE)

fc2 <- filter_clause_ga4(list(df, df2), operator = "AND")
fc  <- filter_clause_ga4(list(mf, mf2), operator = "AND")

report_3 <- google_analytics(
  ga_id, 
  date_range  = c("2020-04-30","2020-05-10"),
  dimensions  = c('source','medium'), 
  metrics     = c('sessions','bounces'), 
  met_filters = fc, 
  dim_filters = fc2)

# вычисляемые показатели
my_custom_metric <- c(visitPerVisitor = "ga:visits/ga:visitors")

report_4 <- google_analytics(ga_id,
                             date_range = c("2019-07-30",
                                            "2019-10-01"),
                             dimensions=c('medium'), 
                             metrics = c(my_custom_metric,
                                         'bounces'), 
                             metricFormat = c("FLOAT","INTEGER"))

# сегменты
segment_def_for_call <- "sessions::condition::ga:medium=~^(cpc|ppc|cpa|cpm|cpv|cpp)$"

seg_obj <- segment_ga4("PaidTraffic", segment_id = segment_def_for_call)

segmented_ga1 <- google_analytics(ga_id, 
                                  c("2019-07-30","2019-10-01"), 
                                  dimensions=c('source','medium','segment'), 
                                  segments = seg_obj, 
                                  metrics = c('sessions','bounces')
)

# Когортный анализ
cohort4 <- make_cohort_group(list("Oct2019" = c("2019-10-01", "2019-10-31"), 
                                  "Now2019" = c("2019-11-01", "2019-11-30"),
                                  "Dec2019" = c("2019-12-01", "2019-12-31")))

google_analytics(ga_id, 
                 dimensions=c('cohort','ga:cohortNthMonth'), 
                 metrics = c('cohortTotalUsers','ga:cohortActiveUsers'),
                 cohort = cohort4
)

# User Activity API, сырые данные 
cids <- google_analytics(ga_id, 
                         date_range = c("16DaysAgo","yesterday"), 
                         metrics = "sessions", dimensions = "clientId")

users <- ga_clientid_activity(cids$clientId,
                              ga_id, 
                              date_range = c("16DaysAgo","yesterday"))


sessions <- users$sessions # сеансы
hits     <- users$hits     # хиты

# Загрузка данных о расходах в Google Analytics
library(rfacebookstat)

# options
options(rfacebookstat.username = 'testuser',
        rfacebookstat.accounts_id = "496441634619287")

# load cost data
cost_data <- fbGetCostData(date_start   = "2020-05-10", 
                           date_stop    = "2020-05-14",
                           accounts_id  = "496441634619287")

# upload into GA source
ga_custom_upload_file(accountId          = 44472206, 
                      webPropertyId      = "UA-44472206-1", 
                      customDataSourceId = 'WE22d5OuQDKitzexwWL_kA', 
                      cost_data)
