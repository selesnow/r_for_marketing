install.packages("rmytarget") # устанавливаем 
library(rmytarget)            # подключаем

# переходим в рабочую лиректорию
setwd("C:\\r_for_marketing_course\\ћодуль 2\\”рок 6")

# авторизаци€ под клиентским аккаунтом
myTarAuth(login = "seleznev", token_path = "tokens")

# загрузка списка рекламных кампаний и объ€влений
campaing <- myTarGetCampaignList(login = "seleznev", token_path = "tokens")
ads      <- myTarGetAdList(login = "seleznev", token_path = "tokens")

# загрузка статистики по рекламным кампанийм
camp_data    <- myTarGetStats(date_from   = Sys.Date() - 30,
                              date_to     = Sys.Date(),
                              object_type = "campaigns",
                              object_id   = campaing$id[2:8],
                              stat_type   = "day",
                              login       = "seleznev", 
                              token_path  = "tokens")

# загрузка списка метрик вход€щих в группы "base", "tps", "viral" по объ€влени€м
custom_data <- myTarGetStats(date_from   = Sys.Date() - 70,
                             date_to     = Sys.Date() - 50,
                             object_type = "banners",
                             metrics     = c("base", "tps", "viral"),
                             stat_type   = "day",
                             login       = "seleznev", 
                             token_path  = "tokens")

# загрузка всех возможных метрик с группировкой по рекламным кампани€м
all_data <- myTarGetStats(date_from   = Sys.Date() - 7,
                          date_to     = Sys.Date(),
                          object_type = "campaigns",
                          metrics     = "all",
                          login       = "seleznev", 
                          token_path  = "tokens")


# работа с агентским аккаунтом
myTarAuth(login = "agency", token_path = "tokens")

# загрузка списка клиентов
clients <- myTarGetClientList(login = "agency",
                              token_path = "tokens")

# загрузка статистики с группировкой по клиентам агентского аккаунта
client_stat <-  myTarGetStats(date_from   = Sys.Date() - 7,
                              date_to     = Sys.Date(),
                              object_id   = clients$id,
                              object_type = "users",
                              metrics     = "all",
                              login       = "agency",
                              token_path = "tokens")
