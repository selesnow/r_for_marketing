devtools::install_github("robinsones/funneljoin")

library(dplyr)
library(funneljoin)
library(rym)
library(ggplot2)

# ����������� ������ �����
goals    <- rym_get_goals("52502668", 
                          login      = "alex-s", 
                          token.path = "C:/my_develop_workshop/auth")

# ����������� ���� �� ���� ���������
logs  <- rym_get_logs(counter   = "52502668", 
                      date.from = "2019-04-01", 
                      date.to   = "2019-07-30", 
                      fields = "ym:s:visitID,
                                ym:s:clientID,
                                ym:s:date,
                                ym:s:goalsID,
                                ym:s:lastTrafficSource,
                                ym:s:isNewUser", 
                      login      = "aerosus-netpeak",
                      token.path = "C:\\my_develop_workshop\\ppc_digest\\token_metrica") %>%
  mutate(ym.s.date     = as.Date(ym.s.date),
         ym.s.clientID = as.character(ym.s.clientID))


# ��������� ������ � ������� ����
logs_goals <- logs %>%
  mutate(ym.s.goalsID = str_replace_all(ym.s.goalsID, # ������� �� ������ ��������
                                        "\\[|\\]", 
                                        "") %>% 
           str_split(",")) %>%           # ��������� ����� �� ��������         
  unnest(cols = c(ym.s.goalsID)) %>%
  mutate(ym.s.goalsID = as.integer(ym.s.goalsID)) %>% # ��������� id ���� � �������� ������
  left_join(goals,
            by = c("ym.s.goalsID" = "id")) %>%        # ��������� �������� �� ������� �����
  rename(events = name)                               # ��������������� �������� ���� � events

# �������� ������ � ������ ����������
first_visits <- logs_goals %>%
  filter(ym.s.isNewUser == 1 ) %>% # ��������� ������ ������ ������
  select(ym.s.clientID,            # �������� ���� clientID
         ym.s.date,
         ym.s.lastTrafficSource)   # �������� ���� date

# ��������� ������ ����� �� ���������
logs_goals <- logs_goals %>%
  filter(ym.s.isNewUser == 1 ) %>%
  mutate(events = "������ �����") %>%
  bind_rows(logs_goals)

# ����� �������
my_funnel <-
  logs_goals %>% 
  select(events,
         ym.s.clientID,
         ym.s.date) %>%
  funnel_start(moment_type = "������ �����", 
               moment      = "events", 
               tstamp      = "ym.s.date", 
               user        = "ym.s.clientID") %>%
  funnel_steps(moment_type = c("������� � �������",
                               "������� � ������",
                               "�������� ������� �� �����"),
               type = "first-last") %>%
  summarize_funnel()

# ###########################
# ������������ ������� ������
my_funnel %>%
  mutate(padding = (max(my_funnel$nb_step) - nb_step) / 2) %>%
  gather(key = "variable", value = "val", -moment_type) %>%
  filter(variable %in% c("nb_step", "padding")) %>%
  arrange(desc(variable)) %>%
  mutate(moment_type = factor(moment_type, 
                              levels = c("�������� ������� �� �����",
                                         "������� � ������",
                                         "������� � �������",
                                         "������ �����"))) %>%
  ggplot( aes(x = moment_type) ) +
  geom_bar(aes(y = val, fill = variable),
           stat='identity', position='stack') +
  scale_fill_manual(values = c('coral', NA) ) +
  geom_text(data = my_funnel,
            aes(y     = sum(my_funnel$nb_step) / 2, 
                label = paste(round(pct_cumulative * 100,2), '%')),
            colour='tomato4',
            fontface = "bold") +
  coord_flip() +
  theme(legend.position = 'none') +
  labs(x='moment', y='volume')

# ��������������� ������� ��������� � ������� ������� ������ 
first_visits <- rename(first_visits, 
                       firstSource = ym.s.lastTrafficSource)

# � ����� ������� ������������ ������ �� ��������� ������� ������
logs_goals <- select(first_visits,
                     ym.s.clientID,
                     firstSource) %>%
  left_join(logs_goals,
            .,
            by = "ym.s.clientID")


# ������� ������� �� �������
my_multi_funnel <- lapply(c("ad", "organic", "direct"), 
                          function(source) {
                            logs_goals %>% 
                              filter(firstSource == source) %>%
                              select(events,
                                     ym.s.clientID,
                                     ym.s.date) %>%
                              funnel_start(moment_type = "������ �����", 
                                           moment      = "events", 
                                           tstamp      = "ym.s.date", 
                                           user        = "ym.s.clientID") %>%
                              funnel_steps(moment_type = c("������� � �������",
                                                           "������� � ������",
                                                           "�������� ������� �� �����"),
                                           type = "first-last") %>%
                              summarize_funnel() %>%
                              mutate(firstSource = source)
                          }) %>%
                     bind_rows() # ���������� ���������

# #########################################
# ������������ ������� �� �������
my_multi_funnel %>%
  mutate(padding = ( 1 - pct_cumulative) / 2 ) %>%
  gather(key = "variable", value = "val", -moment_type, -firstSource) %>%
  filter(variable %in% c("pct_cumulative", "padding")) %>%
  arrange(desc(variable)) %>%
  mutate(moment_type = factor(moment_type, 
                              levels = c("�������� ������� �� �����",
                                         "������� � ������",
                                         "������� � �������",
                                         "������ �����")),
         variable    = factor(variable,
                              levels = c("pct_cumulative",
                                         "padding"))) %>%
  ggplot( aes(x = moment_type) ) +
  geom_bar(aes(y = val, fill = variable),
           stat='identity', position='stack') +
  scale_fill_manual(values = c('coral', NA) ) +
  geom_text(data = my_multi_funnel,
            aes(y     = 1 / 2, 
                label =paste(round(pct_cumulative * 100, 2), '%')),
            colour='tomato4',
            fontface = "bold") +
  coord_flip() +
  theme(legend.position = 'none') +
  labs(x='moment', y='volume') +
  facet_grid(. ~ firstSource) 
