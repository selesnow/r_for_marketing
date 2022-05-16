# Управление пользователями
library(rfacebookstat)
account_users <- fbGetAdAccountUsersPermissions(accounts_id = "act_262115113",
                                                access_token = fb_token)

fbDeleteAdAccountUsers(user_ids = 2567905003282309,
                       accounts_id = "act_262115113",
                       access_token = fb_token)

fbUpdateAdAccountUsers(user_ids = 2567905003282309,
                       role = "advertiser",
                       accounts_id = "act_262115113",
                       access_token = fb_token)

# FB2PBI

library(rfacebookstat)
setwd("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 4")
load(file = "fb_token.RData")

CampStat <-     fbGetMarketingStat(accounts_id  = "act_262115113",
                                   level        = "campaign",
                                   fields       = "campaign_name,impressions,clicks",
                                   breakdowns   = "age",
                                   sorting      = "unique_impressions_descending",
                                   filtering    = "[{'field':'age','operator':'IN','value':['18-24','25-34']}]",
                                   date_start   = "2018-08-01",
                                   date_stop    = "2018-08-06",
                                   access_token = fb_token)


