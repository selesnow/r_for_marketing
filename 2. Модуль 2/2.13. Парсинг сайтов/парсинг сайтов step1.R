# web scrapping 1
devtools::install_github("hadley/rvest")
library(rvest)
# Переходим в рабочую директорию
setwd("C:/r_for_marketing_course/Материалы курса/Модуль 2/Урок 10")

#############################
# Загрузка HTML страницы ####
#############################
simpl_html <- read_html("test_html_page.html")
# HTML структура
html_structure(simpl_html)

######################################
# Поиск элементов HTML траницы #######
# XPath локаторы и  CSS селекторы ####
######################################
# Поиск элемента по ID
date_node_css_id    <- html_nodes(x = simpl_html, css = "#update_date") 
date_node_x_path_id <- html_nodes(simpl_html, xpath = '//*[@id="update_date"]/i')

# Поиск элемента по классу
searh_class <- html_nodes(simpl_html, css = ".simple_text")

# Поиск по наличию атрибута
attr_presence <- html_nodes(simpl_html, css = "[title]")

# Поиск по значению атрибута
attr_value  <- html_nodes(simpl_html, css = "[title='test_tab']")

# Поиск по тегу
tags        <- html_nodes(simpl_html, css = "table")

# Вложенные селекторы
many_selectors <- html_nodes(simpl_html, css = "div p a")

#################################################
# Извлечение значний из полученных элементов ####
#################################################
# извлечение текста
txt_date      <- html_text(date_node_css_id)
# извлечение атрибутов
txt_attr      <- html_attrs(searh_class)
# извлечение значения конкретного атрибута
txt_attr_val  <- html_attr(searh_class[[2]], name = "id")
links_url     <- html_nodes(simpl_html, css = "a") %>% html_attr(name = "href")
links_text    <- html_nodes(simpl_html, css = "a") %>% html_text()
# названия тегов
tag_names_txt <- html_name(searh_class)
# парсинг таблиц
my_table      <- html_nodes(simpl_html, css = "table") %>% html_table(header = TRUE)
my_tab <- my_table[[1]]

