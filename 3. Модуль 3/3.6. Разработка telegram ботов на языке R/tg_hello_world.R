#install.packages('telegram.bot')
library(telegram.bot)

# �������������� ����
bot <- Bot(token = "1241461879:AAEJ_MAxTX7TnPHcmtCL-hRIUYDE-4onYVA")

# �������� ����������
updates <- bot$getUpdates()

# �������� id ����
chat_id <- updates[[1]]$from_chat_id()


# ���������� ���������
bot$sendMessage(chat_id,
                text = "������, *������ �����* _������_",
                parse_mode = "Markdown"
)
