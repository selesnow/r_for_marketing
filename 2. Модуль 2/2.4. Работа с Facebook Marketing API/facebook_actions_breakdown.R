# запрос данных
library(rfacebookstat)
# установка опций
options(rfacebookstat.accounts_id  = "act_000000000",
        rfacebookstat.api_version  = "v4.0",
        rfacebookstat.access_token = "EAACg7dbgLXMBAOyRube7lWcfeZALDxK5Fl3vnRs3veDyhZB8ZC22NZBCLRw...")

# реакций на ваши объ€влени€
fb_reaction <- fbGetMarketingStat(level = "ad",
                                  fields = "ad_id,clicks,actions",
                                  action_breakdowns  = "action_reaction",
                                  date_start = Sys.Date() - 20,
                                  date_stop = Sys.Date() - 1,
                                  interval = "day")

# ”стройство, на котором произошло отслеживаемое событие конверсии
fb_action_device <- fbGetMarketingStat(level = "ad",
                                       fields = "ad_id,actions",
                                       action_breakdowns  = "action_device",
                                       date_start = Sys.Date() - 20,
                                       date_stop = Sys.Date() - 1,
                                       interval = "day")

# “ип действий, выполненных в отношении вашей рекламы
fb_action_type <- fbGetMarketingStat(level = "ad",
                                    fields = "ad_id,
                                              clicks,
                                              actions",
                                    action_breakdowns  = "action_type",
                                    date_start = Sys.Date() - 20,
                                    date_stop = Sys.Date() - 1,
                                    interval = "day")

#  уда переход€т люди, нажав вашу рекламу
fb_action_destination <- fbGetMarketingStat(level = "ad",
                                            fields = "ad_id,actions",
                                            action_breakdowns  = "action_destination",
                                            date_start = Sys.Date() - 20,
                                            date_stop = Sys.Date() - 1,
                                            interval = "day")

# ¬иньетка
vignette("rfacebookstat-get-statistics", package = "rfacebookstat")
