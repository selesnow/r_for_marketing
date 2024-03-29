library(telegram.bot)
library(rym)
library(stringr)
library(dplyr)
library(ggplot2)

# ��������� ����
updater <- Updater(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# ����������� � �������
## �����
options(rym.user   = "vipman.netpeak", 
        rym.token_path = "D:\\ym_auth_data")

## �����������
rym_auth()

# �������
# ������ ����������
start <- function(bot, update) {

  # ����������� ������ ���������
  counters <- rym_get_counters() %>%
              mutate(name = if_else(name == '', '-noname counter-', name))
  
  # ������ ����������
  keys <-
    lapply(1:nrow(counters), 
           function(x) {
             list(
               InlineKeyboardButton(
                      text = substr(counters$name[x], 1, 64),
                      callback_data = counters$id[x]))}
           )
  
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
  cb_data <- update$callback_query$data
  
  # �������� ����, ��� ������ � ������ ������
  bot$answerCallbackQuery(callback_query_id = update$callback_query$id, 
                          text = "���������!") 
  
  # ����������� ����������
  ym_stat <- rym_get_data(counters = cb_data, 
                          dimensions = 'ym:s:date', 
                          lang = 'en')
  

  # ��������� ���� �� ������
  if ( is.null(ym_stat) ) {
    
    bot$sendMessage(update$from_chat_id(),
                    text = str_glue("� �������� {cb_data} ��� ������!"),
                    parse_mode = "HTML")
    
  } else {
    
    # ����� ����������
    sessions <- sum(ym_stat$Sessions)
    views    <- sum(ym_stat$Pageviews)
    users    <- sum(ym_stat$Users)
    
    # ��������� ���������
    msg <- str_glue("*������� ������*:\n", 
                    "_������_: {sessions}\n",
                    "_���������_: {views}\n",
                    "_����������_: {users}\n")
    
    # ���������� ���������
    bot$sendMessage(update$from_chat_id(),
                    text = msg,
                    parse_mode = "Markdown")
    
    # ������ ������
    ym_stat %>%
      mutate(date = as.Date(`Date of visit`)) %>%
      ggplot( aes(x = date, y = Sessions) ) +
      geom_line( color = 'darkgreen' ) +
      geom_point( color = 'darkgreen' ) +
      ggtitle( str_glue("������ ������, ������� {cb_data}")  )
    # ��������� ������  
    ggsave('ym_plot.png')
    
    # ���������� ������
    bot$send_photo(update$from_chat_id(),
                   'ym_plot.png')
    
  }
  
}

# ������ �����������
h_start         <- CommandHandler('start', start)
h_query_handler <- CallbackQueryHandler(answer_cb)

# ��������� ����������� � ���������
updater <- updater + h_start + h_query_handler

# ��������� ����
updater$start_polling()

