# Яндекс Метрика
devtools::install_github('selesnow/rym')
library(rym)
library(getProxy)

# Переходим в рабочую директорию
setwd("C:/r_for_marketing_course/Материалы курса/Модуль 2/Урок 8")

# ободим блокировку API
getProxy(port = "3128",
         country = "RU",
         supportsHttps = TRUE,
         action = "start")

# Авторизация
rym_auth(login = "vipman.netpeak", token.path = "metrica_token")
rym_auth(login = "selesnow", token.path = "metrica_token")

# API Управления
# получить список счётчиков
selesnow.counters <- rym_get_counters(login      = "selesnow",
                                      token.path = "metrica_token")

vipman.counters   <- rym_get_counters(login      = "vipman.netpeak",
                                      token.path = "metrica_token")

# получить список целей
my_goals <- rym_get_goals(counter = 10595804,
                          login      = "vipman.netpeak",
                          token.path = "metrica_token")

# получить список фильров
my_filter <- rym_get_filters(counter = 10595804,
                             login      = "vipman.netpeak",
                             token.path = "metrica_token")

# получить список сегментов
my_segments <- rym_get_segments(counter = 10595804,
                                login      = "vipman.netpeak",
                                token.path = "metrica_token")

# получить список пользователей счётчика
users <- rym_users_grants(counter = 10595804,
                          login      = "vipman.netpeak",
                          token.path = "metrica_token")

# API отчётов
reporting.api.stat <- rym_get_data(counters   = "23660530,10595804",
                                   date.from  = "2018-08-01",
                                   date.to    = "yesterday",
                                   dimensions = "ym:s:date,ym:s:lastTrafficSource",
                                   metrics    = "ym:s:visits,ym:s:pageviews,ym:s:users",
                                   sort       = "-ym:s:date",
                                   login      = "vipman.netpeak",
                                   token.path = "metrica_token",
                                   lang = "en")

# Logs API
logs.api.stat      <- rym_get_logs(counter    = 23660530,
                                   date.from  = "2018-08-01",
                                   date.to    = "2018-08-05",
                                   fields     = "ym:s:date,
                                                 ym:s:lastTrafficSource,
                                                 ym:s:referer",
                                   source     = "visits",
                                   login      = "vipman.netpeak",
                                   token.path = "metrica_token")

# API Совместимый с Core API Google Analytics v3
ga.api.stat        <- rym_get_ga(counter    = "ga:22584910",
                                 dimensions = "ga:date,ga:source",
                                 metrics    = "ga:sessions,ga:users",
                                 start.date = "2018-08-01",
                                 end.date   = "2018-08-05",
                                 sort       = "-ga:date",
                                 login      = "selesnow",
                                 token.path = "metrica_token")

getProxy(action = "stop")
