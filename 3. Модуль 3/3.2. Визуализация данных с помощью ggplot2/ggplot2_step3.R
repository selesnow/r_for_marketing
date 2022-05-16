library(ggplot2)
library(dplyr)
library(hms)
library(rym)

# load data
ym_data <- rym_get_logs(counter   = "10595804",
                        date.from = "2018-08-25",
                        date.to   = "2018-09-01",
                        fields    = "ym:s:dateTime,
                                     ym:s:pageViews,
                                     ym:s:visitDuration,
                                     ym:s:regionCity,
                                     ym:s:lastTrafficSource,
                                     ym:s:deviceCategory",
                        source    = "visits",
                        login      = "vipman.netpeak",
                        token.path = "C:/r_for_marketing_course/Материалы курса/Модуль 2/Урок 8/metrica_token")

# remove outliers by pageViews
ym_data <- filter(ym_data, ym.s.pageViews < 35)

# get visit time
ym_data$time <- gsub(pattern = "(\\d{4}-\\d{2}-\\d{2}) (\\d{2}:\\d{2}:\\d{2})",
                     replacement = "\\2",
                     x = as.character(ym_data$ym.s.dateTime)) %>%
                as.hms()

# remove outliers
ym_data$duration <- hms(sec = ym_data$ym.s.visitDuration)

# break names
x_brk <- seq(0, 24, by = 2) %>%
          paste0(., ":00:00") %>%
          as.hms()

y_brk <- seq(from = min(ym_data$duration),
             to   = max(ym_data$duration),
             length.out = 15) %>%
         as.hms(.) %>%
         round_hms(secs = 5)

# plot
ggplot(ym_data, aes(x = time, y = duration, na.rm = T)) +
  geom_point(aes(color = ym.s.pageViews), alpha = 0.25) +
  scale_x_time(breaks = x_brk) +
  scale_y_time(breaks = y_brk) +
  scale_color_gradient(low = "indianred1", high = "mediumseagreen") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  labs(x = "Times of Day", y = "Visit Duration") +
  ggtitle("Visit Duration by Times of Day")

