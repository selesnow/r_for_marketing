#install.packages('telegram.bot')
library(telegram.bot)

# инициализируем бота
bot <- Bot(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# получаем обновлени€
updates <- bot$getUpdates()

# получаем id чата
chat_id <- updates[[1]]$from_chat_id()


# ќтправл€ем сообщение
bot$sendMessage(chat_id,
                text = "ѕривет, *жирный текст* _курсив_",
                parse_mode = "Markdown"
)
