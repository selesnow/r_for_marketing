# Vkontakte
devtools::install_github('selesnow/getProxy')
devtools::install_github('selesnow/rvkstat')
library(getProxy)
library(rvkstat)

# обход блокировки
getProxy(port = "3128",
         country = "RU",
         supportsHttps = TRUE,
         action = "start")

vk_auth <- vkAuth(app_id = 6656352, app_secret = "wSGrZuNEs1D4RbffGKDY")

# работа с рекламнымы аккаунтами
# получить справочник тематик рекламных объявлений
category <- vkGetAdCategories(access_token = vk_auth$access_token, api_version = "5.73")

# получить список рекламных аккаунтов
vk_acc <- vkGetAdAccounts(access_token = vk_auth$access_token)
# получить список клиентов из агентского аккаунта
vk_client <- vkGetAdClients(account_id = 1900000891,
                            access_token = vk_auth$access_token,
                            api_version = "5.73")
# получить список рекламных кампаний
vk_camp   <- vkGetAdCampaigns(account_id = 1900000891,
                              client_id = 1602773233,
                              access_token = vk_auth$access_token)
# получить список объявлений
vk_ads    <- vkGetAds(account_id = 1900000891,
                      client_id = 1602773233,
                      access_token = vk_auth$access_token)

# внешний вид объявлений
vk_ad_layout <- vkGetAdsLayout(account_id = 1900000891,
                               client_id = 1602773233,
                               access_token = vk_auth$access_token)

# Статистика рекламного кабинета
camp_stat <- vkGetAdStatistics(account_id = 1900000891,
                               ids        = vk_camp$id,
                               ids_type   = "campaign",
                               period     = "day",
                               date_from  = "2018-08-01",
                               date_to    = "2018-08-08",
                               access_token = vk_auth$access_token)

# Статистика по клиентам агентского аккаунта
client_stat <- vkGetAdStatistics(account_id   = 1900000891,
                                 ids          = vk_client$id,
                                 ids_type     = "client",
                                 period       = "month",
                                 date_from    = "2018-01-01",
                                 date_to      = "2018-08-08",
                                 access_token = vk_auth$access_token,
                                 api_version  = "5.73")

# Отключаемся от прокси
getProxy(action = "stop")
