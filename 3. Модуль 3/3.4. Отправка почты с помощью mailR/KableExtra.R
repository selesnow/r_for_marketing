install.packages("kableExtra")
library(kableExtra)
library(dplyr)

# simple
ga_data %>%
  kable() %>%  
  kable_styling()

# эффект зебры, и подсвечивание при наведении
kable(ga_data) %>%
  kable_styling(bootstrap_options = c("striped", "hover"))

# подсветка строк с показателем отказов выше 70%
r_indexes <- which(ga_data$bounceRate > 70) # получаем индексы строк

kable(ga_data) %>%
  kable_styling(bootstrap_options = c("striped", "hover")) %>%
  row_spec(r_indexes, 
           bold = T, 
           color = "white", 
           background = "red")


# оформление столбца
ga_data %>%
  mutate( users = cell_spec(users, 
                            format = "html", 
                            bold = T,
                            color = "white", 
                            align = "center", 
                            background = "#666666")) %>%
  kable(format = "html", 
        escape = F) %>%
  kable_styling(bootstrap_options = c("striped", "hover")) 

# пакет formattable
install.packages("formattable")
library(formattable)

# группировка столбцов и продвинутое форматирование столбцов
ga_data %>%
  arrange(desc(users)) %>%
  mutate( users      = color_bar("lightgreen")(users),
          bounceRate = color_tile("lightgreen", "orange")(bounceRate),
          newUsers   = ifelse(newUsers >= 10,
                              cell_spec(newUsers, color = "green", bold = T),
                              cell_spec(newUsers, color = "red", italic = T))) %>%
  kable(format = "html", 
        escape = F) %>%
  kable_styling(bootstrap_options = c("striped", "hover"))  %>%
  add_header_above(c(" "       = 2, 
                     "Users"   = 2, 
                     "Session" = 3, 
                     "Pages"   = 2))

# группировка строк
ga_data  <- arrange(ga_data, medium, desc(users))
grouping <- group_by(ga_data, medium) %>% 
              count(sort = FALSE, name = "n.group")

grouping <- grouping$n.group %>%
             setNames(grouping$medium)

ga_data %>%
  select(-medium) %>%
  kable() %>%
  kable_styling(bootstrap_options = c("striped", "hover")) %>%
  add_header_above(c(" " = 1, "Users" = 2, "Session" = 3, "Pages" = 2)) %>%
  kableExtra::group_rows(index = grouping, hline_before = T) 
  #kableExtra::group_rows(group_label = "Direct traffic",start_row = 1, end_row = 1) %>%
  #kableExtra::group_rows(group_label = "Organic traffic",start_row = 2, end_row = 5)
