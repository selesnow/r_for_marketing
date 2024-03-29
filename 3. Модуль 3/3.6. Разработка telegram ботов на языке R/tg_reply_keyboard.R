library(telegram.bot)
library(stringr)

# ��������� ����
updater <- Updater(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# �������
# ������ ����������
start <- function(bot, update) {
  
  # ������ ����������
  text <- "�������� �������"
  
  RKM <- ReplyKeyboardMarkup(
    keyboard = list(
      list(KeyboardButton("�������� id ����"),
           KeyboardButton("������� �����"),
           KeyboardButton("�������������"))
    ),
    resize_keyboard = TRUE,
    one_time_keyboard = FALSE
  )
  
  # ���������� ����������
  bot$sendMessage(update$message$chat_id, 
                  text,
                  reply_markup = RKM)
  
}

# id ����
chat_id <- function(bot, update) {

  
  # ���������� id ����
  # ���������� ����������
  bot$sendMessage(update$message$chat_id, 
                  text = str_glue('Id �������� ����: {update$message$chat_id}'))
  
}

# �����
get_time <- function(bot, update) {
  
  # �����
  cur_datetime <- format(Sys.time(), "%d.%m.%Y / %A / %R %Z / %V ������ ���� / %j ���� ����")
  
  # ���������� ���������
  bot$sendMessage(update$message$chat_id, 
                  text = cur_datetime)
  
}

# ���������
hi <- function(bot, update) {
  
  # �����
  name <- update$message$from$first_name
  
  # ���������� ���������
  bot$sendMessage(update$message$chat_id, 
                  text = str_glue("���������, {name}!"))
  
}

# ������� ���������
MessageFilters$chat_id <- 
  BaseFilter( 
    function(message) {
      
      message$text == "�������� id ����"
      
    }
      )


MessageFilters$time <- 
  BaseFilter( 
    function(message) {
      
      message$text == "������� �����"
      
    }
  )



MessageFilters$hi <- 
  BaseFilter( 
    function(message) {
      
      message$text == "�������������"
      
    }
  )


# �����������
h_start   <- CommandHandler('start', start)
h_chat_id <- MessageHandler( chat_id, MessageFilters$chat_id )
h_time    <- MessageHandler( get_time, MessageFilters$time)
h_hi      <- MessageHandler( hi, MessageFilters$hi)


# ��������� ����������� � ���������
updater <- updater +
            h_start +
            h_chat_id +
            h_time +
            h_hi

# ��������� ����
updater$start_polling()
