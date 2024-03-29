############################
# HTML session #############
############################
library(rvest)

# ������ ������
session <- html_session("http://rutracker.org/forum/index.php")
# �������� ����� ��� �������������� ������������
all_form <- html_form(session)
login_form <- html_nodes(session, css = "#login-form-quick") %>% html_form() %>% .[[1]]

# ��������� �����
filled_form <- set_values(login_form,
                          "login_username" = "r.course",
                          "login_password" = "1ep09k")
# ���������� �
submit_form(session, filled_form)
# ��������� �� ������� �������� �����
main      <- jump_to(session, "http://rutracker.org/forum/index.php")
username  <- html_nodes(main, ".logged-in-as-uname") %>% html_text()
prof_link <- html_nodes(main, ".logged-in-as-uname") %>% html_attr("href")
prof      <- jump_to(session, prof_link)

my_stag_hours <- html_nodes(prof,'table[class="user_details borderless w100"] b') %>% .[3] %>% html_text()

df <- data.frame(username = username,
                 stag = my_stag_hours)

tabl <- html_nodes(prof,'table[class="user_details borderless w100"]') %>% html_table()
tabl <- data.frame(tabl)

# ������ ������
html_nodes(prof, "a") %>% html_text()

rules <- follow_link(session, "�������")

html_nodes(rules, ".post_body") %>% html_text()

session_history(session)
