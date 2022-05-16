# htmlTable package
library(htmlTable)
library(RGA)
library(scales)
library(dplyr)

# load data from Google Analytics
ga_data <- RGA::get_ga(profileId     = "ga:170507937",
                       start.date    = "14daysAgo",
                       end.date      = "yesterday",
                       metrics       = "ga:users,
                                        ga:newUsers,
                                        ga:sessions,
                                        ga:bounceRate,
                                        ga:avgSessionDuration,
                                        ga:pageviewsPerSession,
                                        ga:timeOnPage",
                       dimensions    = "ga:source,
                                        ga:medium",
                       token         = readRDS("D:\\Google Диск\\R Для маркетинга\\Материалы курса\\Модуль 2\\Урок 7\\.r.for.marketing@gmail.com-token.rds")[[1]])

# simple table
ga_data %>% 
  htmlTable()

# help
?htmlTable

# row groups
ga_data  <- arrange(ga_data, medium, desc(users))
grouping <- group_by(ga_data, medium) %>% 
             count(sort = FALSE, name = "n.group")

ga_data %>%
  select(-medium) %>%
  htmlTable(rgroup   = grouping$medium,
            n.rgroup = grouping$n.group,
            css.rgroup = rep("text-align:  center; 
                              font-weight: bold; 
                              font-size:   15px;
                              background-color: grey"))

# column groups
ga_data %>%
  select(-medium) %>%
  mutate(bounceRate          = percent(bounceRate / 100),
         avgSessionDuration  = round(avgSessionDuration ,2),
         pageviewsPerSession = round(pageviewsPerSession,2),
         timeOnPage          = format(timeOnPage, big.mark   = " ")) %>%
  htmlTable(rgroup           = grouping$medium,
            n.rgroup         = grouping$n.group,
            css.rgroup      = rep("text-align:  center; 
                                   font-weight: bold; 
                                   font-size:   15px;
                              background-color: grey"),
            header = c("Source",
                       "Users",
                       "NewUsers",
                       "Sessions",
                       "Bounce Rate",
                       "Avg Session Time",
                       "Page Per Session",
                       "Time On Page"),
            cgroup = c("", "Users", "Sessions", "Pages"),
            n.cgroup = c(1,2,3,2),
            align = "lrrrrrrr",
            caption = "Google Analytics Data by Sources",
            rnames = FALSE, 
            tfoot = paste0("Total sessions: ",sum(ga_data$sessions)))
