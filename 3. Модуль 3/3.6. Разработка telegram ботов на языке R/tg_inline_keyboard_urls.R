library(telegram.bot)

bot <- Bot(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

chat_id <- 194336771

text <- "Свяжитесь с нами"

IKM <- InlineKeyboardMarkup(
  inline_keyboard = list(
    list(
      InlineKeyboardButton(text = 'facebook', url = 'https://www.facebook.com/selesnow'),
      InlineKeyboardButton(text = 'vk', url = 'https://vk.com/selesnow'),
      InlineKeyboardButton(text = 'github', url = 'https://github.com/selesnow/')
    ),
    list(
      InlineKeyboardButton(text = 'telegram', url = 'http://t.me/AlexeySeleznev'),
      InlineKeyboardButton(text = 'site', url = 'http://selesnow.github.io/'),
      InlineKeyboardButton(text = 'blog', url = 'https://alexeyseleznev.wordpress.com/')
    ), 
    list(
      InlineKeyboardButton(text = 'telegram channel', url = 'http://t.me/R4marketing')
    )
  )
)

# Send Inline Keyboard
bot$sendMessage(chat_id, text, reply_markup = IKM)
