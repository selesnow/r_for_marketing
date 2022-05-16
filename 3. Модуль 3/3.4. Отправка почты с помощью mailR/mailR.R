# send email
install.packages("mailR")
install.packages("htmlTable")

library(mailR)
library(htmlTable)
library(RAdwords)
library(dplyr)
library(ggplot2)
library(stringr)

# wd
setwd("C:/r_for_marketing_course/Материалы курса/Модуль 3/Урок 4/")

# load credention
load('MAIL_CRED.RData')

# load data from Google AdWords
load("C:/r_for_marketing_course/Материалы курса/Модуль 2/Урок 2/.google.auth.RData")

body <- statement(select = c('AdGroupName',
                             'Id',
                             'Impressions',
                             'Clicks',
                             'Cost',
                             'Ctr',
                             'AveragePosition',
                             'CreativeQualityScore',
                             'PostClickQualityScore',
                             'SearchPredictedCtr',
                             'QualityScore'),
                  report = "KEYWORDS_PERFORMANCE_REPORT",
                  start  = Sys.Date() - 8,
                  end    = Sys.Date() - 1)

adwordsData <- getData(clientCustomerId = "957-328-7481",
                       google_auth      = google_auth,
                       statement        = body)

# cleare data
adwordsData <- filter(adwordsData, Qualityscore != " --") %>%
                  mutate(Qualityscore = as.integer(Qualityscore))

# detect QS group
## create fun
qs_group_detect <- function (x) {
  if (x <= 4) {
    return("low")
  } else if ( between(x, left = 5, right = 6 ) ) {
    return("middle")
  } else {
    return("high")
  }
}

## detect group
for (i in 1:nrow(adwordsData)) {
  adwordsData$QSGroup[i] <- qs_group_detect(adwordsData$Qualityscore[i])
}

# create dashboard
## create table
html_table <- select(adwordsData, Adgroup, Impressions, Clicks, Qualityscore) %>%
              group_by(Adgroup) %>%
              summarise(Impressions  = sum(Impressions),
                        Clicks       = sum(Clicks),
                        Qualityscore = median(Qualityscore)) %>%
              htmlTable(col.rgroup = c("lightyellow", "navajowhite"),
                        css.cell = "font-family: Verdana; font-size: 10px",
                        rnames = FALSE)

## create plots
### reorder afactor
adwordsData$QSGroup <- factor(adwordsData$QSGroup, levels = c("high", "middle", "low"))
### vizualisation
qsgroup_plot <- adwordsData %>%
                  ggplot(aes(x = Adgroup)) +
                  geom_bar(aes(fill = QSGroup), position = "fill") +
                  scale_fill_manual(breaks = c("high", "middle", "low"),
                                    values = c(high = "forestgreen", middle = "tan1" , low = "firebrick1")) +
                  scale_y_continuous(labels = scales::percent) +
                  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 8)) +
                  ggtitle("Distribution keywords by quality score group")

### save plot to png
ggsave(filename = "keyword_group.png", device = "png", plot = qsgroup_plot)

## create letter
msg <- str_interp('<body>
                   <h2>Тестовый дайджест отправленный из R</h2>
                   <p>Этот дайджест сформирован на основе данных полученных из Google Ads.</p>
                   <br>
                   <h3>Таблица созданная с помощью пакета htmlTable</h3>
                   ${html_table}
                   <br>
                   <h3>График созданный с помощью пакета ggplot2</h3>
                   <img src="keyword_group.png" width="500"></center>
                   <br>
                   <p>Дата формирования дайджеста: ${Sys.Date()}</p>
                  </body>')

# send letter
# before send
browseURL("https://myaccount.google.com/lesssecureapps")

send.mail(from     = "R Course <r.for.marketing.test@gmail.com>",
          to       = "r.for.marketing@gmail.com",
          subject  = "Тестовое письмо отправленное из R",
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
