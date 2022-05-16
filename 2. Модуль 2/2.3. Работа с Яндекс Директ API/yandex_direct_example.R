# Работа с API Яндекс Директ
devtools::install_github("selesnow/ryandexdirect")

# Установка на Linux и Mac
#devtools::install_github("selesnow/ryandexdirect", subdir = "utf8")

library(ryandexdirect)
setwd("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 3")

# Запрос объектов рекламного аккаунта
# Список рекламных кампаний
my_camp   <- yadirGetCampaignList(Logins    = "netpeak.vyacheslav",
                                  TokenPath = "direct_tokens")
# Список групп объявлений
my_group  <- yadirGetAdGroups(Login     = "netpeak.vyacheslav",
                              TokenPath = "direct_tokens")

# Список ключевых слов
my_keyw   <- yadirGetKeyWords(Login     = "netpeak.vyacheslav",
                              States    = "ON",
                              TokenPath = "direct_tokens")

# Список быстрых ссылок
my_links  <- yadirGetSiteLinks(Login     = "netpeak.vyacheslav",
                               TokenPath = "direct_tokens")

# Загрузка данных по общему счёту, ключая остаток
balance       <- yadirGetBalance(Login     = "netpeak.vyacheslav",
                                 TokenPath = "direct_tokens")

# Загрузка справочной информации
# Доступные справочники Currencies, MetroStations, GeoRegions, TimeZones, Constants, AdCategories, OperationSystemVersions, ProductivityAssertions, SupplySidePlatforms, Interests

geo      <- yadirGetDictionary(DictionaryName = "GeoRegions",
                               Login          = "netpeak.vyacheslav",
                               TokenPath      = "direct_tokens")

cur      <- yadirGetDictionary(DictionaryName = "Currencies",
                               Login          = "netpeak.vyacheslav",
                               TokenPath      = "direct_tokens")

adcategories <- yadirGetDictionary(DictionaryName = "AdCategories",
                                   Login          = "netpeak.vyacheslav",
                                   TokenPath      = "direct_tokens")

constant     <- yadirGetDictionary(DictionaryName = "Constants",
                                   Login          = "netpeak.vyacheslav",
                                   TokenPath      = "direct_tokens")

# Запуск и остановка показов
# получаем список активных РК
active_campaign_before <- my_camp$Id[my_camp$State == "ON"]
# остановка рекламных кампаний
yadirStopCampaigns(Ids = c(30361157, 30361191),
                   Login          = "netpeak.vyacheslav",
                   TokenPath      = "direct_tokens")

# получаем список активных РК
my_camp_new <- yadirGetCampaignList(Logins    = "netpeak.vyacheslav",
                                  TokenPath = "direct_tokens")

active_campaign_after_stoped <- my_camp_new$Id[my_camp_new$State == "ON"]

# запускаем РК
yadirStartCampaigns(Ids = c(30361157, 30361191),
                    Login          = "netpeak.vyacheslav",
                    TokenPath      = "direct_tokens")
# получаем список активных РК
my_camp_new2 <- yadirGetCampaignList(Logins    = "netpeak.vyacheslav",
                                     TokenPath = "direct_tokens")

active_campaign_after_start <- my_camp_new$Id[my_camp_new2$State == "ON"]

# сверяем со списком который был до остановки
all.equal(active_campaign_before, active_campaign_after_start)


# Загрузка статистики
# Работа с обычным рекламным аккаунтом
# Статистика по рекламным кампаниям за пользовательский период с применением фильтра
my_camp_stat <- yadirGetReport(ReportType    = "CAMPAIGN_PERFORMANCE_REPORT",
                               DateRangeType = "CUSTOM_DATE",
                               DateFrom      = "2018-07-01",
                               DateTo        = "2018-07-31",
                               FieldNames    = c("Date", "CampaignId", "Clicks"),
                               FilterList    = c("Clicks GREATER_THAN 1","Impressions LESS_THAN 1000"),
                               IncludeVAT    = "YES",
                               IncludeDiscount = "NO",
                               Login         = "netpeak.vyacheslav",
                               TokenPath     = "direct_tokens")

# Статистика за прошлую рабочую неделю
my_daily_stat <- yadirGetReport(ReportType      = "CUSTOM_REPORT",
                                DateRangeType   = "LAST_BUSINESS_WEEK",
                                FieldNames      = c("Date", "Clicks", "Impressions"),
                                Login           = "netpeak.vyacheslav",
                                IncludeVAT      = "YES",
                                IncludeDiscount = "NO",
                                TokenPath       = "direct_tokens")

# Работа с агентским рекламным аккаунтом
# загрузка списка клиентов
my_client <- yadirGetClientList(AgencyAccount = "netpeak.kz",
                                TokenPath     = "direct_tokens")

# Загрузка данных о стране клиента, валюте аккаунта, оценка показателя качества аккаунтаа
my_cl_param <- yadirGetClientParam(AgencyAccount = "netpeak.kz",
                                   TokenPath     = "direct_tokens")

# загрузка статистики по клиентам
my_client_stat <- yadirGetReport(ReportType      = "CUSTOM_REPORT",
                                 DateRangeType   = "LAST_BUSINESS_WEEK",
                                 FieldNames      = c("Clicks", "Impressions"),
                                 AgencyAccount   = "netpeak.kz",
                                 Login           = my_client$Login[5:11],
                                 IncludeVAT      = "YES",
                                 IncludeDiscount = "NO",
                                 TokenPath       = "direct_tokens")

