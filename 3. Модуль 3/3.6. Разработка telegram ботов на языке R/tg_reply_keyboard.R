library(telegram.bot)
library(stringr)

# экземпляр бота
updater <- Updater(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# функции
# запуск клавиатуры
start <- function(bot, update) {
  
  # Создаём клавиатуру
  text <- "Выберите команду"
  
  RKM <- ReplyKeyboardMarkup(
    keyboard = list(
      list(KeyboardButton("Получить id чата"),
           KeyboardButton("Текущее время"),
           KeyboardButton("Поздароваться"))
    ),
    resize_keyboard = TRUE,
    one_time_keyboard = FALSE
  )
  
  # Отправляем клавиатуру
  bot$sendMessage(update$message$chat_id, 
                  text,
                  reply_markup = RKM)
  
}

# id чата
chat_id <- function(bot, update) {

  
  # отправляем id чата
  # Отправляем клавиатуру
  bot$sendMessage(update$message$chat_id, 
                  text = str_glue('Id текущего чата: {update$message$chat_id}'))
  
}

# время
get_time <- function(bot, update) {
  
  # время
  cur_datetime <- format(Sys.time(), "%d.%m.%Y / %A / %R %Z / %V неделя года / %j день года")
  
  # отправляем сообщение
  bot$sendMessage(update$message$chat_id, 
                  text = cur_datetime)
  
}

# приветвие
hi <- function(bot, update) {
  
  # время
  name <- update$message$from$first_name
  
  # отправляем сообщение
  bot$sendMessage(update$message$chat_id, 
                  text = str_glue("Приветвую, {name}!"))
  
}

# фильтры сообщений
MessageFilters$chat_id <- 
  BaseFilter( 
    function(message) {
      
      message$text == "Получить id чата"
      
    }
      )


MessageFilters$time <- 
  BaseFilter( 
    function(message) {
      
      message$text == "Текущее время"
      
    }
  )



MessageFilters$hi <- 
  BaseFilter( 
    function(message) {
      
      message$text == "Поздароваться"
      
    }
  )


# обработчики
h_start   <- CommandHandler('start', start)
h_chat_id <- MessageHandler( chat_id, MessageFilters$chat_id )
h_time    <- MessageHandler( get_time, MessageFilters$time)
h_hi      <- MessageHandler( hi, MessageFilters$hi)


# добавляем обработчики в диспетчер
updater <- updater +
            h_start +
            h_chat_id +
            h_time +
            h_hi

# запускаем бота
updater$start_polling()
