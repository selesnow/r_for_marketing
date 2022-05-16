# Подключение пакета
library(telegram.bot)
library(rfacebookstat)
library(dplyr)
library(stringr)
library(ggplot2)

# экземпляр бота
updater <- Updater(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# авторизация в facebook
options(rfacebookstat.username = "selesnow", 
        rfacebookstat.token_path = "d:\\facebook_auth_data")

fbAuth()

# команды бота
## запрос списка аккаунтов
start <-  function(bot, update) {
  
  # запрвшиваем список аккаунтов
  fb_accounts <- fbGetAdAccounts() %>%
                 sample_n(40)
  
  # приводим id аккаунтов в текст
  acc_ids <- paste0(fb_accounts$account_id, collapse = "\n")
  
  # отправляем сообщение
  bot$sendMessage(update$message$chat_id,
                  text = acc_ids,
                  parse_mode = "HTML")
  
}

## запрос статистики
stat <-  function(bot, update, args) {
  
  # параметры
  account_id <- args[1]
  date_start <- args[2]
  date_stop  <- args[3]
  
  # запрашиваем статистику
  fb_stat <- fbGetMarketingStat(account_id,
                                date_start = date_start,
                                date_stop = date_stop)
  
  # проверяем есть ли данные
  if ( nrow(fb_stat) == 0 ) {
    
    bot$sendMessage(update$message$chat_id,
                    text = str_glue("В аккаунте {account_id} нет данных за период {date_start} {date_stop}!"),
                    parse_mode = "HTML")
    
  } else {
    
    # общие показатели
    impressions <- sum(as.integer(fb_stat$impressions))
    reach       <- sum(as.integer(fb_stat$reach))
    clicks      <- sum(as.integer(fb_stat$clicks))
    spend       <- sum(as.numeric(fb_stat$spend))
    
    # формируем сообщение
    msg <- str_glue("*Сводные данные ({date_start} - {date_stop})*:\n", 
                    "_Показы_: {impressions}\n",
                    "_Охват_: {reach}\n",
                    "_Кликки_: {clicks}\n",
                    "_Расход_: {spend}\n",)
    
    # отправляем сообщение
    bot$sendMessage(update$message$chat_id,
                    text = msg,
                    parse_mode = "Markdown")
    
    # строим график
    fb_stat %>%
      mutate(date = as.Date(date_start),
             reach = as.integer(reach)) %>%
      ggplot( aes(x = reach, y = date) ) +
        geom_line( color = 'darkgreen' ) +
        geom_point( color = 'darkgreen' ) +
        ggtitle( str_glue("Данные охвата, аккаунт {account_id}"), subtitle = str_glue("{date_start} - {date_stop}")  )
    # сохраняем график  
    ggsave('fb_plot.png')
    
    # отправляем график
    bot$send_photo(update$message$chat_id,
                   'fb_plot.png')
    
  }
  
}

# фильтр
MessageFilters$start_fun <- 
  BaseFilter( 
    function(message) {
  
      message$text == 'аккаунты'
  
} )

# создаём обработчики
start_h <- CommandHandler('get_accounts', start)
stat_h  <- CommandHandler('stat', stat, pass_args = TRUE)
start_m <- MessageHandler(start, filters = MessageFilters$start_fun)

# добавляем обработчики в диспетчер
updater <- updater + 
              start_h +
              stat_h +
              start_m

# запускаем бота
updater$start_polling()