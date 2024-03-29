# ����������� ������
library(telegram.bot)
library(rfacebookstat)
library(dplyr)
library(stringr)
library(ggplot2)

# ��������� ����
updater <- Updater(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# ����������� � facebook
options(rfacebookstat.username = "selesnow", 
        rfacebookstat.token_path = "d:\\facebook_auth_data")

fbAuth()

# ������� ����
## ������ ������ ���������
start <-  function(bot, update) {
  
  # ����������� ������ ���������
  fb_accounts <- fbGetAdAccounts() %>%
                 sample_n(40)
  
  # �������� id ��������� � �����
  acc_ids <- paste0(fb_accounts$account_id, collapse = "\n")
  
  # ���������� ���������
  bot$sendMessage(update$message$chat_id,
                  text = acc_ids,
                  parse_mode = "HTML")
  
}

## ������ ����������
stat <-  function(bot, update, args) {
  
  # ���������
  account_id <- args[1]
  date_start <- args[2]
  date_stop  <- args[3]
  
  # ����������� ����������
  fb_stat <- fbGetMarketingStat(account_id,
                                date_start = date_start,
                                date_stop = date_stop)
  
  # ��������� ���� �� ������
  if ( nrow(fb_stat) == 0 ) {
    
    bot$sendMessage(update$message$chat_id,
                    text = str_glue("� �������� {account_id} ��� ������ �� ������ {date_start} {date_stop}!"),
                    parse_mode = "HTML")
    
  } else {
    
    # ����� ����������
    impressions <- sum(as.integer(fb_stat$impressions))
    reach       <- sum(as.integer(fb_stat$reach))
    clicks      <- sum(as.integer(fb_stat$clicks))
    spend       <- sum(as.numeric(fb_stat$spend))
    
    # ��������� ���������
    msg <- str_glue("*������� ������ ({date_start} - {date_stop})*:\n", 
                    "_������_: {impressions}\n",
                    "_�����_: {reach}\n",
                    "_������_: {clicks}\n",
                    "_������_: {spend}\n",)
    
    # ���������� ���������
    bot$sendMessage(update$message$chat_id,
                    text = msg,
                    parse_mode = "Markdown")
    
    # ������ ������
    fb_stat %>%
      mutate(date = as.Date(date_start),
             reach = as.integer(reach)) %>%
      ggplot( aes(x = reach, y = date) ) +
        geom_line( color = 'darkgreen' ) +
        geom_point( color = 'darkgreen' ) +
        ggtitle( str_glue("������ ������, ������� {account_id}"), subtitle = str_glue("{date_start} - {date_stop}")  )
    # ��������� ������  
    ggsave('fb_plot.png')
    
    # ���������� ������
    bot$send_photo(update$message$chat_id,
                   'fb_plot.png')
    
  }
  
}

# ������
MessageFilters$start_fun <- 
  BaseFilter( 
    function(message) {
  
      message$text == '��������'
  
} )

# ������ �����������
start_h <- CommandHandler('get_accounts', start)
stat_h  <- CommandHandler('stat', stat, pass_args = TRUE)
start_m <- MessageHandler(start, filters = MessageFilters$start_fun)

# ��������� ����������� � ���������
updater <- updater + 
              start_h +
              stat_h +
              start_m

# ��������� ����
updater$start_polling()