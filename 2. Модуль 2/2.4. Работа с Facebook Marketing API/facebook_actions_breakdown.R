# çàïðîñ äàííûõ
library(rfacebookstat)
# óñòàíîâêà îïöèé
options(rfacebookstat.accounts_id  = "act_000000000",
        rfacebookstat.api_version  = "v4.0",
        rfacebookstat.access_token = "ваш токенkjdgdhbfidybdg...")

# ðåàêöèé íà âàøè îáúÿâëåíèÿ
fb_reaction <- fbGetMarketingStat(level = "ad",
                                  fields = "ad_id,clicks,actions",
                                  action_breakdowns  = "action_reaction",
                                  date_start = Sys.Date() - 20,
                                  date_stop = Sys.Date() - 1,
                                  interval = "day")

# Óñòðîéñòâî, íà êîòîðîì ïðîèçîøëî îòñëåæèâàåìîå ñîáûòèå êîíâåðñèè
fb_action_device <- fbGetMarketingStat(level = "ad",
                                       fields = "ad_id,actions",
                                       action_breakdowns  = "action_device",
                                       date_start = Sys.Date() - 20,
                                       date_stop = Sys.Date() - 1,
                                       interval = "day")

# Òèï äåéñòâèé, âûïîëíåííûõ â îòíîøåíèè âàøåé ðåêëàìû
fb_action_type <- fbGetMarketingStat(level = "ad",
                                    fields = "ad_id,
                                              clicks,
                                              actions",
                                    action_breakdowns  = "action_type",
                                    date_start = Sys.Date() - 20,
                                    date_stop = Sys.Date() - 1,
                                    interval = "day")

# Êóäà ïåðåõîäÿò ëþäè, íàæàâ âàøó ðåêëàìó
fb_action_destination <- fbGetMarketingStat(level = "ad",
                                            fields = "ad_id,actions",
                                            action_breakdowns  = "action_destination",
                                            date_start = Sys.Date() - 20,
                                            date_stop = Sys.Date() - 1,
                                            interval = "day")

# Âèíüåòêà
vignette("rfacebookstat-get-statistics", package = "rfacebookstat")
