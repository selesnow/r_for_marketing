library(telegram.bot)
library(rfacebookstat)
library(stringr)

# ��������� ����
updater <- Updater(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# ����������� � facebook
options(rfacebookstat.username = "selesnow", 
        rfacebookstat.token_path = "d:\\facebook_auth_data")

fbAuth()

# �������
# ������ ����������
start <- function(bot, update) {
  
  # 
  
  # ����������� ������ ���������
  fb_accounts <- fbGetAdAccounts() %>%
                  sample_n(40)
  
  # ������ ����������
  keys <-
    lapply(1:nrow(fb_accounts), 
           function(x) list(InlineKeyboardButton(
                               text = substr(fb_accounts$name[x], 1, 64),
                               callback_data = fb_accounts$account_id[x])))
  
  # ������ InLine ����������
  IKM <- InlineKeyboardMarkup(
    inline_keyboard = keys
  )
  
  # ���������� ���������� � ���
  bot$sendMessage(update$message$chat_id, 
                  text = "�������� �������", 
                  reply_markup = IKM)
  
}




# ����� ��� ��������� ������� ������
answer_cb <- function(bot, update) {
  
  # ���������� ������ � ������
  data <- update$callback_query$data
  
  # �������� ����, ��� ������ � ������ ������
  bot$answerCallbackQuery(callback_query_id = update$callback_query$id, 
                          text = "���������!") 
  
  # ����������� ����������
  fb_stat <- fbGetMarketingStat(data)
  
  # ��������� ���� �� ������
  if ( nrow(fb_stat) == 0 ) {
    
    bot$sendMessage(update$message$chat_id,
                    text = str_glue("� {data} �������� ��� ������!"),
                    parse_mode = "HTML")
    
  } else {
    
    # ����� ����������
    impressions <- sum(as.integer(fb_stat$impressions))
    reach       <- sum(as.integer(fb_stat$reach))
    clicks      <- sum(as.integer(fb_stat$clicks))
    
    # ��������� ���������
    msg <- str_glue("*������� ������*:\n", 
                    "_������_: {impressions}\n",
                    "_�����_: {reach}\n",
                    "_������_: {clicks}\n")
    
    # ���������� ���������
    bot$sendMessage(update$from_chat_id(),
                    text = msg,
                    parse_mode = "Markdown")
    
    # ������ ������
    fb_stat %>%
      mutate(date = as.Date(date_start),
             reach = as.integer(reach)) %>%
      ggplot( aes(x = reach, y = date) ) +
      geom_line( color = 'darkgreen' ) +
      geom_point( color = 'darkgreen' ) +
      ggtitle( str_glue("������ ������, ������� {data}")  )
    # ��������� ������  
    ggsave('fb_plot.png')
    
    # ���������� ������
    bot$send_photo(update$from_chat_id(),
                   'fb_plot.png')
    
  }

}

# ������ �����������
h_start         <- CommandHandler('start', start)
h_query_handler <- CallbackQueryHandler(answer_cb)

# ��������� ����������� � ���������
updater <- updater + h_start + h_query_handler

# ��������� ����
updater$start_polling()
