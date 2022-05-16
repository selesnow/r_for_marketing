
#install.packages("taskscheduleR")
.libPaths()
library(RAdwords, lib.loc = "D://r_library")
library(mailR, lib.loc = "D://r_library")
library(RSQLite, lib.loc = "D://r_library")
library(ggplot2, lib.loc = "D://r_library")
library(rjson, lib.loc = "D://r_library")
library(labeling, lib.loc = "D://r_library")
library(dplyr)
library(stringr)
library(htmlTable, lib.loc = "D://r_library")

# wd
setwd("C:\\r_for_marketing_course\\Материалы курса\\Модуль 3\\Урок 5")

# load email password
load('C:/r_for_marketing_course/Материалы курса/Модуль 3/Урок 4/MAIL_CRED.RData')

# DB connect
con <- dbConnect(drv = SQLite(),
                 "adwords_db.db")

# log
dbWriteTable(con,
             name  = "log",
             value = data.frame(time = as.character(Sys.time()),
                                message = "start"),
             append = TRUE,
             overwrite = FALSE,
             row.names = FALSE)

###############
# Load data from Google Ads ====
###############
load("C:/r_for_marketing_course/Материалы курса/Модуль 2/Урок 2/.google.auth.RData")

body <- statement(select = c('Date',
                             'Impressions',
                             'Clicks',
                             'Cost',
                             'Ctr',
                             'AveragePosition'),
                  report = "ACCOUNT_PERFORMANCE_REPORT",
                  start  = Sys.Date() - 1,
                  end    = Sys.Date() - 1)

adwordsData <- getData(clientCustomerId = "957-328-7481",
                       google_auth      = google_auth,
                       statement        = body)

# log
dbWriteTable(con,
             name  = "log",
             value = data.frame(time = as.character(Sys.time()),
                                message = "load data from google ads"),
             append = TRUE,
             overwrite = FALSE,
             row.names = FALSE)


###############
# Send data to DB ====
###############
mutate(adwordsData,
       Day = as.character(Day)) %>%
dbWriteTable(con,
             name  = "adwords",
             value = .,
             append = TRUE,
             overwrite = FALSE,
             row.names = FALSE)

# log
dbWriteTable(con,
             name  = "log",
             value = data.frame(time = as.character(Sys.time()),
                                message = "send data to db"),
             append = TRUE,
             overwrite = FALSE,
             row.names = FALSE)

###############
# Load data to DB ====
###############
data <- dbGetQuery(con,
                   str_interp('SELECT *
                               FROM adwords
                               WHERE
                               Day between "${Sys.Date() - 8}" and "${Sys.Date() - 1}"'))

# log
dbWriteTable(con,
             name  = "log",
             value = data.frame(time = as.character(Sys.time()),
                                message = "load data from data base"),
             append = TRUE,
             overwrite = FALSE,
             row.names = FALSE)

###############
# visualyze ====
###############
plot <- ggplot(data, aes(x = as.Date(Day), y  = Position, group = 1)) +
        geom_line(aes(col = Position)) +
        geom_point(aes(col = Position)) +
        scale_y_continuous(trans = "reciprocal",
                           breaks = seq(from = max(data$Position),
                                        to = min(data$Position),
                                        length.out = 6))

ggsave(filename = "plot.png", plot = plot, device = "png")

# log
dbWriteTable(con,
             name  = "log",
             value = data.frame(time = as.character(Sys.time()),
                                message = "save plot"),
             append = TRUE,
             overwrite = FALSE,
             row.names = FALSE)

# create letter
# send letter
html_table <- htmlTable(data,
                        col.rgroup = c("lightyellow", "navajowhite"),
                        css.cell = "font-family: Verdana; font-size: 10px",
                        rnames = FALSE)
msg <- str_interp('<body>
                   <h2>Дайджест Google Ads за период ${Sys.Date() - 8} - ${Sys.Date() - 1}</h2>
                  <p>Данные полученные из аккаунта Google Ads.</p>
                  <br>
                  <h3>Таблица</h3>
                  ${html_table}
                  <br>
                  <h3>Динамика изменения средней позиции</h3>
                  <img src="plot.png" width="500"></center>
                  <br>
                  <p>Дайджест сформирован: ${Sys.Date()}</p>
                  </body>')

send.mail(from     = "R Course <r.for.marketing.test@gmail.com>",
          to       = "r.for.marketing@gmail.com",
          subject  = "Дайджест Google Ads",
          body     = msg,
          encoding = "utf-8",
          inline   = TRUE,
          html     = TRUE,
          smtp     = list(host.name = "smtp.gmail.com",
                          port      = 465,
                          user.name = "r.for.marketing.test@gmail.com",
                          passwd    = cred$p,
                          ssl       = TRUE),
          authenticate = TRUE,
          send         = TRUE)

# log
dbWriteTable(con,
             name  = "log",
             value = data.frame(time = as.character(Sys.time()),
                                message = "done"),
             append = TRUE,
             overwrite = FALSE,
             row.names = FALSE)

dbDisconnect(con)
