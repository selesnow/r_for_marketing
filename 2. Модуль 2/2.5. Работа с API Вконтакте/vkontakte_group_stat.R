library(rvkstat, lib.loc = "D:/r_library")

# статистика сообщества
# получить список всех групп пользователя
my_groups <- vkGetUserGroups(access_token = vk_auth$access_token)

# общаяя статистика по сообществу
gr_stat <- vkGetGroupStat(date_from = "2018-08-01",
                          date_to = "2018-08-08",
                          group_id = 119709976,
                          access_token = vk_auth$access_token)

# статистика по посетителям сообщества в разбивке по возрасту
gr_stat_age <- vkGetGroupStatAge(date_from = "2018-08-01",
                                 date_to = "2018-08-08",
                                 group_id = 119709976,
                                 access_token = vk_auth$access_token)

# статистика по посетителям сообщества в разбивке по полу
gr_stat_gender <- vkGetGroupStatGender(date_from = "2018-08-01",
                                       date_to = "2018-08-08",
                                       group_id = 119709976,
                                       access_token = vk_auth$access_token)

# статистика по посетителям сообщества в разбивке по полу и возрасту
gr_stat_gen_age <- vkGetGroupStatGenderAge(date_from = "2018-08-01",
                                           date_to = "2018-08-08",
                                           group_id = 119709976,
                                           access_token = vk_auth$access_token)

# статистика по посетителям сообщества в разбивке по городам
gr_stat_city <- vkGetGroupStatCity(date_from = "2018-08-01",
                                   date_to = "2018-08-08",
                                   group_id = 119709976,
                                   access_token = vk_auth$access_token)

# статистика по посетителям сообщества в разбивке по странам
gr_stat_country <- vkGetGroupStatCountries(date_from = "2018-08-01",
                                           date_to = "2018-08-08",
                                           group_id = 119709976,
                                           access_token = vk_auth$access_token)

