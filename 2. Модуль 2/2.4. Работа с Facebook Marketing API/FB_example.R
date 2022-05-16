# Установка и подключение пакета rfacebookstat
devtools::install_github("selesnow/ryandexdirect")
library(rfacebookstat)

# переходим в рабочую директорию
setwd("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 4")

# авторизация в API
# краткосрочный токен
my_st_token <- fbGetToken(app_id = 1672451129546934)

# долгосрочный токен
fb_token    <- fbGetLongTimeToken(client_id = 1672451129546934,
                                  client_secret = "a6c01acdb9a4100216de5f8874adbce5",
                                  fb_exchange_token = my_st_token)

# Сохраняем токен
save(file = "fb_token.RData")

# Загрузка объектов API
# бизнес менеджеры
my_fb_bm   <- fbGetBusinessManagers(access_token = fb_token)

# проекты из бизнес менеджера
my_fb_proj <- fbGetProjects(bussiness_id = my_fb_bm$id,
                            access_token = fb_token)
# рекламные аккаунты
my_fb_acc  <- fbGetAdAccounts(source_id = my_fb_bm$id,
                              access_token = fb_token)
# страницы
my_fb_page <- fbGetPages(projects_id = my_fb_proj$id, access_token = fb_token)
# приложения
my_fb_apps <- fbGetApps(projects_id = my_fb_proj$id, access_token = fb_token)

# Объекты рекламного аккаунта
# кампании
my_fb_camp <- fbGetCampaigns(accounts_id = "act_262115113",
                             access_token = fb_token)

# группы объявлений
my_fb_adsets <- fbGetAdSets(accounts_id = "act_262115113",
                            access_token = fb_token)
# объявления
my_fb_ads    <- fbGetAds(accounts_id = my_fb_acc$id[7],
                         access_token = fb_token)

# контент объявлений
my_fb_ad_content <- fbGetAdCreative(accounts_id = "act_262115113",
                                    access_token = fb_token)

# загрузка статистики
my_fb_stats <- fbGetMarketingStat(accounts_id = "act_262115113",
                                  level = "campaign",
                                  fields = "account_name,campaign_name,impressions,clicks",
                                  breakdowns = "device_platform",
                                  date_start = "2018-08-01",
                                  date_stop = "2018-08-07",
                                  interval = "day",
                                  access_token = fb_token)


# управление пользователями
fb_acc_user <- fbGetAdAccountUsers(accounts_id  =  "act_262115113",
                                   access_token = fb_token,
                                   console_type = "message")

fbDeleteAdAccountUsers(user_ids = "823041644481205",
                       accounts_id  =  "act_262115113",
                       access_token = fb_token,
                       api_version = "v3.1")

fb_acc_user2 <- fbGetAdAccountUsers(accounts_id  =  "act_262115113",
                                    access_token = fb_token,
                                    console_type = "message")


all.equal(fb_acc_user, fb_acc_user2)
