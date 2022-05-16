install.packages("devtools")
devtools::install_github("jburkhardt/RAdwords")
library(RAdwords, lib.loc = "D:/r_library")

# переходим в рабочую директорию
setwd("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 2")

# Список отчётов
reports(apiVersion = "201806")

# Список полей
metrics(report = "CAMPAIGN_PERFORMANCE_REPORT", apiVersion = "201806")

# Авторизация
ads_auth <- doAuth()

# Составляем запрос
body <- statement(select = c("Date",
                             "CampaignName",
                             "Device",
                             "Clicks",
                             "Impressions",
                             "Cost"),
                  report = "CAMPAIGN_PERFORMANCE_REPORT",
                  where  = "Impressions > 50",
                  start  = "2018-07-01",
                  end    = "2018-07-31")

# Запрашиваем данные
data <- getData(clientCustomerId       = "957-328-7481",
                google_auth            = ads_auth,
                statement              = body,
                includeZeroImpressions = TRUE)
