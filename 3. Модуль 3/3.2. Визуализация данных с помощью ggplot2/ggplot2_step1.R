# install
install.packages("ggplot2")

# attach
library(ggplot2)
library(RGA)
library(dplyr)

# load data from Google Analytics
ga_data <- RGA::get_ga(profileId     = "ga:170507937",
                       start.date    = "14daysAgo",
                       end.date      = "yesterday",
                       metrics       = "ga:users,ga:sessions,ga:bounces",
                       dimensions    = "ga:date,ga:source,ga:medium",
                       samplingLevel = "HIGHER_PRECISION",
                       token         = readRDS("D:\\Google Диск\\R Для маркетинга\\Материалы курса\\Модуль 2\\Урок 7\\.r.for.marketing@gmail.com-token.rds")[[1]])
str(ga_data)
# first plot
# prepare data
# sessions by date
ga_data %>%
  group_by(date) %>%
  summarise(sessions = sum(sessions)) %>%
  qplot(data = .,
        x    = date,
        y    = sessions,
        geom = c("line", "point"),
        main = "Sessions by date")

# with group
ga_data %>%
  group_by(date, medium) %>%
  summarise(sessions = sum(sessions)) %>%
  qplot(data  = .,
        x     = date,
        y     = sessions,
        group = medium,
        geom  = c("line", "point"),
        main  = "Sessions by date and medium",
        color = medium)

# with facets
ga_data %>%
  group_by(date, medium) %>%
  summarise(sessions    = sum(sessions),
            bounce_rate = sum(bounces) / sessions) %>%
  qplot(data   = .,
        x      = date,
        y      = sessions,
        group  = medium,
        geom   = c("line", "point"),
        main   = "Sessions by date and medium",
        color = bounce_rate,
        facets = medium ~ .)

# daily sessions from different medium
ga_data %>%
  qplot(data = .,
        x    = medium,
        y    = sessions,
        geom = c("boxplot"),
        fill = medium,
        main = "Daily sessions by medium")

# bounce rate by medium
ga_data %>%
  group_by(medium) %>%
  summarise(bounce_rate = sum(bounces) / sum(sessions)) %>%
  qplot(data = .,
        x    = medium,
        y    = bounce_rate,
        geom = "col",
        fill = bounce_rate,
        main = "Bounce rate by medium")

# users by date and medium
ga_data %>%
  group_by(date, medium) %>%
  summarise(users = sum(users)) %>%
  qplot(data  = .,
        x     = date,
        y     = users,
        group = date,
        geom  = "col",
        fill  = medium,
        main = "Users by date and medium")
