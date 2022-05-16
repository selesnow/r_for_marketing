library(ryandexdirect)

# список ключевых слов
kw   <- yadirGetKeyWords(Login     = "irina.netpeak",
                         TokenPath = "C:/my_develop_workshop/auth")

# ################################# #
# Управление ставками ключевых слов #
# ################################# #

# Получить ставки
# get the bids
bids <- yadirGetKeyWordsBids(KeywordIds = kw$Id[1:10],
                             Login      = "irina.netpeak",
                             TokenPath  = "C:/my_develop_workshop/auth")

# search auction
ser_bids <- yadirGetKeyWordsBids(KeywordIds  = kw$Id[1:10],
                                 Login       = "irina.netpeak",
                                 AuctionBids = "search",
                                 TokenPath   = "C:/my_develop_workshop/auth")

# network auction
network_bids <- yadirGetKeyWordsBids(KeywordIds  = kw$Id[1:100],
                                     Login       = "irina.netpeak",
                                     AuctionBids = "network",
                                     TokenPath   = "C:/my_develop_workshop/auth")
# Установить ставки
bids$KeywordId[1]
bids$SearchBid[1]
# устанвливаем ставку 40
yadirSetKeyWordsBids(bids$KeywordId[1:2],
                     SearchBid = 40,
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")
# проверяем что ставка установлена
yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1:2],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# автоматическое управление ставками
ser_bids[ ser_bids$KeywordId   == bids$KeywordId[1] &
          ser_bids$AuctionTrafficVolume == 90, ]

# установка
yadirSetAutoKeyWordsBids(KeywordIds = bids$KeywordId[1], 
                         TargetTrafficVolume = 90,
                         Login      = "irina.netpeak",
                         TokenPath  = "C:/my_develop_workshop/auth")

# проверяем ставку
yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# с надбавкой
yadirSetAutoKeyWordsBids(KeywordIds = bids$KeywordId[1], 
                         TargetTrafficVolume   = 90,
                         SearchIncreasePercent = 20,
                         Login      = "irina.netpeak",
                         TokenPath  = "C:/my_develop_workshop/auth")

# проверяем ставку
yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# с надбавкой с надбавкой и ограничением
yadirSetAutoKeyWordsBids(KeywordIds = bids$KeywordId[1], 
                         TargetTrafficVolume   = 90, # % выкупаемого трафика
                         SearchIncreasePercent = 80,  # % надбавки
                         SearchBidCeiling      = 34,  # макс ставка
                         Login      = "irina.netpeak",
                         TokenPath  = "C:/my_develop_workshop/auth")

yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# возвращаем ставку
yadirSetKeyWordsBids(KeywordIds = bids$KeywordId[2],
                     SearchBid  = bids$SearchBid[2],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# проверка
yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1:2],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# ошибка
yadirSetKeyWordsBids(bids$KeywordId[1],
                     NetworkBid = 0.5,
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# виньетка 
vignette("yandex-direct-keyword-bids", package = "ryandexdirect")
