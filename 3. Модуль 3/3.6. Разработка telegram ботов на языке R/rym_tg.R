library(telegram.bot)
library(rym)
library(stringr)
library(dplyr)
library(ggplot2)

# экземпляр бота
updater <- Updater(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# авторизация в метрике
## опции
options(rym.user   = "vipman.netpeak", 
        rym.token_path = "D:\\ym_auth_data")

## авторизация
rym_auth()

# функции
# запуск клавиатуры
start <- function(bot, update) {

  # запрвшиваем список аккаунтов
  counters <- rym_get_counters() %>%
              mutate(name = if_else(name == '', '-noname counter-', name))
  
  # создаём клавиатуру
  keys <-
    lapply(1:nrow(counters), 
           function(x) {
             list(
               InlineKeyboardButton(
                      text = substr(counters$name[x], 1, 64),
                      callback_data = counters$id[x]))}
           )
  
  # создаём InLine клавиатуру
  IKM <- InlineKeyboardMarkup(
    inline_keyboard = keys
  )
  
  # Отправляем клавиатуру в чат
  bot$sendMessage(update$message$chat_id, 
                  text = "Выбирите счётчик", 
                  reply_markup = IKM)
  
}




# метод для обработки нажатия кнопки
answer_cb <- function(bot, update) {
  
  # полученные данные с кнопки
  cb_data <- update$callback_query$data
  
  # сообщаем боту, что запрос с кнопки принят
  bot$answerCallbackQuery(callback_query_id = update$callback_query$id, 
                          text = "Подождите!") 
  
  # запрашиваем статистику
  ym_stat <- rym_get_data(counters = cb_data, 
                          dimensions = 'ym:s:date', 
                          lang = 'en')
  

  # проверяем есть ли данные
  if ( is.null(ym_stat) ) {
    
    bot$sendMessage(update$from_chat_id(),
                    text = str_glue("В счётчике {cb_data} нет данных!"),
                    parse_mode = "HTML")
    
  } else {
    
    # общие показатели
    sessions <- sum(ym_stat$Sessions)
    views    <- sum(ym_stat$Pageviews)
    users    <- sum(ym_stat$Users)
    
    # формируем сообщение
    msg <- str_glue("*Сводные данные*:\n", 
                    "_Визиты_: {sessions}\n",
                    "_Просмотры_: {views}\n",
                    "_Посетители_: {users}\n")
    
    # отправляем сообщение
    bot$sendMessage(update$from_chat_id(),
                    text = msg,
                    parse_mode = "Markdown")
    
    # строим график
    ym_stat %>%
      mutate(date = as.Date(`Date of visit`)) %>%
      ggplot( aes(x = date, y = Sessions) ) +
      geom_line( color = 'darkgreen' ) +
      geom_point( color = 'darkgreen' ) +
      ggtitle( str_glue("Данные охвата, аккаунт {cb_data}")  )
    # сохраняем график  
    ggsave('ym_plot.png')
    
    # отправляем график
    bot$send_photo(update$from_chat_id(),
                   'ym_plot.png')
    
  }
  
}

# создаём обработчики
h_start         <- CommandHandler('start', start)
h_query_handler <- CallbackQueryHandler(answer_cb)

# добавляем обработчики в диспетчер
updater <- updater + h_start + h_query_handler

# запускаем бота
updater$start_polling()

