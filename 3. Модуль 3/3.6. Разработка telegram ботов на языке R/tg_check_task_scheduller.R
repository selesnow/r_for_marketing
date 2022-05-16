# Подключение пакета
library(telegram.bot)
library(taskscheduleR)
library(dplyr)

# инициализируем бота
bot <- Bot(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# идентификатор чата
chat_id <- 194336771

# запрашиваем список задач
task <- taskscheduler_ls() %>%
  filter(! `Last Result`  %in% c("0", "267011")  &
           `Scheduled Task State` == "Enabled" & 
            Status != "Running" &
            Author == "ALSEY\\Alsey") %>%
  select(TaskName) %>%
  unique() %>%
  unlist() %>%
  paste0(., collapse = "\n")

# если есть проблемные задачи отправляем сообщение
if ( task != "" ) {
  
  tg_message <- paste0("<b>Список задач:</b>\n", task)
  
  bot$sendMessage(chat_id,
                  text = tg_message,
                  parse_mode = "HTML"
  )
  
}
