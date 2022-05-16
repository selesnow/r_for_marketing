library(telegram.bot)
library(rfacebookstat)
library(stringr)

# экземпляр бота
updater <- Updater(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# авторизация в facebook
options(rfacebookstat.username = "selesnow", 
        rfacebookstat.token_path = "d:\\facebook_auth_data")

fbAuth()

# функции
# запуск клавиатуры
start <- function(bot, update) {
  
  # 
  
  # запрвшиваем список аккаунтов
  fb_accounts <- fbGetAdAccounts() %>%
                  sample_n(40)
  
  # создаём клавиатуру
  keys <-
    lapply(1:nrow(fb_accounts), 
           function(x) list(InlineKeyboardButton(
                               text = substr(fb_accounts$name[x], 1, 64),
                               callback_data = fb_accounts$account_id[x])))
  
  # создаём InLine клавиатуру
  IKM <- InlineKeyboardMarkup(
    inline_keyboard = keys
  )
  
  # Отправляем клавиатуру в чат
  bot$sendMessage(update$message$chat_id, 
                  text = "Выбирите аккаунт", 
                  reply_markup = IKM)
  
}




# метод для обработки нажатия кнопки
answer_cb <- function(bot, update) {
  
  # полученные данные с кнопки
  data <- update$callback_query$data
  
  # сообщаем боту, что запрос с кнопки принят
  bot$answerCallbackQuery(callback_query_id = update$callback_query$id, 
                          text = "Подождите!") 
  
  # запрашиваем статистику
  fb_stat <- fbGetMarketingStat(data)
  
  # проверяем есть ли данные
  if ( nrow(fb_stat) == 0 ) {
    
    bot$sendMessage(update$message$chat_id,
                    text = str_glue("В {data} аккаунте нет данных!"),
                    parse_mode = "HTML")
    
  } else {
    
    # общие показатели
    impressions <- sum(as.integer(fb_stat$impressions))
    reach       <- sum(as.integer(fb_stat$reach))
    clicks      <- sum(as.integer(fb_stat$clicks))
    
    # формируем сообщение
    msg <- str_glue("*Сводные данные*:\n", 
                    "_Показы_: {impressions}\n",
                    "_Охват_: {reach}\n",
                    "_Кликки_: {clicks}\n")
    
    # отправляем сообщение
    bot$sendMessage(update$from_chat_id(),
                    text = msg,
                    parse_mode = "Markdown")
    
    # строим график
    fb_stat %>%
      mutate(date = as.Date(date_start),
             reach = as.integer(reach)) %>%
      ggplot( aes(x = reach, y = date) ) +
      geom_line( color = 'darkgreen' ) +
      geom_point( color = 'darkgreen' ) +
      ggtitle( str_glue("Данные охвата, аккаунт {data}")  )
    # сохраняем график  
    ggsave('fb_plot.png')
    
    # отправляем график
    bot$send_photo(update$from_chat_id(),
                   'fb_plot.png')
    
  }

}

# создаём обработчики
h_start         <- CommandHandler('start', start)
h_query_handler <- CallbackQueryHandler(answer_cb)

# добавляем обработчики в диспетчер
updater <- updater + h_start + h_query_handler

# запускаем бота
updater$start_polling()
