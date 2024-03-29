# web scrapping 1
devtools::install_github("hadley/rvest")
library(rvest)
# ��������� � ������� ����������
setwd("C:/r_for_marketing_course/��������� �����/������ 2/���� 10")

#############################
# �������� HTML �������� ####
#############################
simpl_html <- read_html("test_html_page.html")
# HTML ���������
html_structure(simpl_html)

######################################
# ����� ��������� HTML ������� #######
# XPath �������� �  CSS ��������� ####
######################################
# ����� �������� �� ID
date_node_css_id    <- html_nodes(x = simpl_html, css = "#update_date") 
date_node_x_path_id <- html_nodes(simpl_html, xpath = '//*[@id="update_date"]/i')

# ����� �������� �� ������
searh_class <- html_nodes(simpl_html, css = ".simple_text")

# ����� �� ������� ��������
attr_presence <- html_nodes(simpl_html, css = "[title]")

# ����� �� �������� ��������
attr_value  <- html_nodes(simpl_html, css = "[title='test_tab']")

# ����� �� ����
tags        <- html_nodes(simpl_html, css = "table")

# ��������� ���������
many_selectors <- html_nodes(simpl_html, css = "div p a")

#################################################
# ���������� ������� �� ���������� ��������� ####
#################################################
# ���������� ������
txt_date      <- html_text(date_node_css_id)
# ���������� ���������
txt_attr      <- html_attrs(searh_class)
# ���������� �������� ����������� ��������
txt_attr_val  <- html_attr(searh_class[[2]], name = "id")
links_url     <- html_nodes(simpl_html, css = "a") %>% html_attr(name = "href")
links_text    <- html_nodes(simpl_html, css = "a") %>% html_text()
# �������� �����
tag_names_txt <- html_name(searh_class)
# ������� ������
my_table      <- html_nodes(simpl_html, css = "table") %>% html_table(header = TRUE)
my_tab <- my_table[[1]]

