library(ryandexdirect)

# ������ �������� ����
kw   <- yadirGetKeyWords(Login     = "irina.netpeak",
                         TokenPath = "C:/my_develop_workshop/auth")

# ################################# #
# ���������� �������� �������� ���� #
# ################################# #

# �������� ������
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
# ���������� ������
bids$KeywordId[1]
bids$SearchBid[1]
# ������������ ������ 40
yadirSetKeyWordsBids(bids$KeywordId[1:2],
                     SearchBid = 40,
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")
# ��������� ��� ������ �����������
yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1:2],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# �������������� ���������� ��������
ser_bids[ ser_bids$KeywordId   == bids$KeywordId[1] &
          ser_bids$AuctionTrafficVolume == 90, ]

# ���������
yadirSetAutoKeyWordsBids(KeywordIds = bids$KeywordId[1], 
                         TargetTrafficVolume = 90,
                         Login      = "irina.netpeak",
                         TokenPath  = "C:/my_develop_workshop/auth")

# ��������� ������
yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# � ���������
yadirSetAutoKeyWordsBids(KeywordIds = bids$KeywordId[1], 
                         TargetTrafficVolume   = 90,
                         SearchIncreasePercent = 20,
                         Login      = "irina.netpeak",
                         TokenPath  = "C:/my_develop_workshop/auth")

# ��������� ������
yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# � ��������� � ��������� � ������������
yadirSetAutoKeyWordsBids(KeywordIds = bids$KeywordId[1], 
                         TargetTrafficVolume   = 90, # % ����������� �������
                         SearchIncreasePercent = 80,  # % ��������
                         SearchBidCeiling      = 34,  # ���� ������
                         Login      = "irina.netpeak",
                         TokenPath  = "C:/my_develop_workshop/auth")

yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# ���������� ������
yadirSetKeyWordsBids(KeywordIds = bids$KeywordId[2],
                     SearchBid  = bids$SearchBid[2],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# ��������
yadirGetKeyWordsBids(KeywordIds = bids$KeywordId[1:2],
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# ������
yadirSetKeyWordsBids(bids$KeywordId[1],
                     NetworkBid = 0.5,
                     Login      = "irina.netpeak",
                     TokenPath  = "C:/my_develop_workshop/auth")

# �������� 
vignette("yandex-direct-keyword-bids", package = "ryandexdirect")
