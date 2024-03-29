library(rym)
library(RAdwords)
library(dplyr)

# options
options(rym.user = 'selesnow',
        rym.token_path =  'C:/packlab/rym')

# rym auth
rym_auth()
ga_auth <- doAuth()

# ������ ������ �� Facebook
stat <- statement(select = c("Date",
                             "Id",
                             "AccountCurrencyCode",
                             "CampaignName",
                             "Clicks",
                             "Cost"),
                  report = "AD_PERFORMANCE_REPORT",
                  start = Sys.Date() - 11,
                  end = Sys.Date() - 1)

data <- getData(clientCustomerId = "923-811-6656", 
                google_auth = ga_auth, 
                statement = stat)
str(data)
# ����������� ������
data <- data %>%
  rename(Date = Day,
         UTMCampaign = Campaign,
         UTMContent = AdID,
         Expenses = Cost) %>%
  mutate(UTMSource = 'google',
         UTMMedium = 'cpc')

# �������� ������ � ������ �������
rym_upload_expense(
  22584910, 
  data
)

# ������� �������
rym_delete_uploaded_expense(
  22584910, 
  data
)