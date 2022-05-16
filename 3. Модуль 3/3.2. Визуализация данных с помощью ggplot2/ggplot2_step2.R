## ggplot step_2
library(ggplot2)
library(rym)
library(dplyr)

# work direcoryt
setwd("C:/r_for_marketing_course/Материалы курса/Модуль 3/Урок 2")

# loading data
ym_data <- rym_get_logs(counter   = "10595804",
                        date.from = "2018-08-25",
                        date.to   = "2018-09-01",
                        fields    = "ym:s:date,
                                     ym:s:pageViews,
                                     ym:s:visitDuration,
                                     ym:s:regionCity,
                                     ym:s:lastTrafficSource,
                                     ym:s:deviceCategory",
                        source    = "visits",
                        login      = "vipman.netpeak",
                        token.path = "C:/r_for_marketing_course/Материалы курса/Модуль 2/Урок 8/metrica_token")

# vizualize
# step_1 - basic
ggplot(data = ym_data, aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
  geom_boxplot()

# step_2 - remove outliers
# zoom
ggplot(data = ym_data, aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(0, 20))
# remove
ggplot(data = ym_data, aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
  geom_boxplot(fill = "blue") +
  ylim(0, 20)

# step_3 - color
group_by(ym_data, ym.s.lastTrafficSource) %>%
  mutate(m_pageviews = median(ym.s.pageViews)) %>%
  ggplot(data = ., aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
    geom_boxplot(aes(fill = m_pageviews)) +
    coord_cartesian(ylim = c(0, 20)) +
    scale_fill_gradient(low = "red", high = "green")

# step_4 - reorder
ym_data$ym.s.lastTrafficSource <- with(ym_data, reorder(ym.s.lastTrafficSource, ym.s.pageViews, function(x) -median(x)))

group_by(ym_data, ym.s.lastTrafficSource) %>%
  mutate(m_pageviews = median(ym.s.pageViews)) %>%
  ggplot(data = ., aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
  geom_boxplot(aes(fill = m_pageviews)) +
  coord_cartesian(ylim = c(0, 20)) +
  scale_fill_gradient(low = "red", high = "green")

# step_5 - facet
ym_data$device <- vapply(ym_data$ym.s.deviceCategory,
                         FUN = function(x) switch(x,
                                                  "1" = "десктоп",
                                                  "2" = "мобильные телефоны",
                                                  "3" = "планшеты",
                                                  "4" = "TV"),
                         FUN.VALUE = "character")

group_by(ym_data, ym.s.lastTrafficSource, device) %>%
  mutate(m_pageviews = median(ym.s.pageViews)) %>%
  ggplot(data = ., aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
  geom_boxplot(aes(fill = m_pageviews)) +
  coord_cartesian(ylim = c(0, 20)) +
  scale_fill_gradient(low = "red", high = "green") +
  facet_grid(device ~ .)

# step_6 - themes
group_by(ym_data, ym.s.lastTrafficSource, device) %>%
  mutate(m_pageviews = median(ym.s.pageViews)) %>%
  ggplot(data = ., aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
  geom_boxplot(aes(fill = m_pageviews)) +
  coord_cartesian(ylim = c(0, 20)) +
  scale_fill_gradient(low = "red", high = "green") +
  facet_grid(device ~ .) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12))

group_by(ym_data, ym.s.lastTrafficSource, device) %>%
  mutate(m_pageviews = median(ym.s.pageViews)) %>%
  ggplot(data = ., aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
  geom_boxplot(aes(fill = m_pageviews)) +
  coord_cartesian(ylim = c(0, 20)) +
  scale_fill_gradient(low = "red", high = "green") +
  facet_grid(device ~ .) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12)) +
  theme_classic()

group_by(ym_data, ym.s.lastTrafficSource, device) %>%
  mutate(m_pageviews = median(ym.s.pageViews)) %>%
  ggplot(data = ., aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
  geom_boxplot(aes(fill = m_pageviews)) +
  coord_cartesian(ylim = c(0, 20)) +
  scale_fill_gradient(low = "red", high = "green") +
  facet_grid(device ~ .) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12)) +
  theme_dark()

# save to image
my_gg_plot <- group_by(ym_data, ym.s.lastTrafficSource, device) %>%
                mutate(m_pageviews = median(ym.s.pageViews)) %>%
                ggplot(data = ., aes(x = ym.s.lastTrafficSource, y = ym.s.pageViews)) +
                geom_boxplot(aes(fill = m_pageviews)) +
                coord_cartesian(ylim = c(0, 20)) +
                scale_fill_gradient(low = "red", high = "green") +
                facet_grid(device ~ .) +
                theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12)) +
                theme_dark()

ggsave(filename = "pict.png", device = "png", plot = my_gg_plot)

# more layers
group_by(ym_data, ym.s.date) %>%
  summarise(page_pr_sessions = sum(ym.s.pageViews) / n()) %>%
  ggplot(data = ., aes(x = ym.s.date, y = page_pr_sessions, group = 1)) +
  geom_line(color = "blue") +
  geom_point(color = "red", size = 3) +
  geom_smooth()
