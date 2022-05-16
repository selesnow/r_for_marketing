library(httr)
library(xml2)
library(stringr)
library(dplyr)
library(tidyr)

# отправляем запрос
r <- GET("http://resources.finance.ua/ru/public/currency-cash.xml")
a <- content(r, "parsed", "text/xml")

# смотрим структуру полученного xml
xml_structure(a)

# создаём результирующий data.frame
res <- data.frame()

# вытаскиваем дату
с_date <- xml_find_all(a, xpath = "@date") %>% xml_text()
# вытаскиваем id всех организаций
organizations_id <- xml_find_all(a, "//organization/@id") %>% xml_text()
# по очереди циклом достаём данные по каждой органиации
# создаём прогрессбар
pb_step <- 1
pb <- utils::txtProgressBar(pb_step, length(organizations_id), style = 3)
for ( org_id in organizations_id ) {
  
  res <- bind_rows(res,
                   data.frame(
                     date = с_date,
                     organization_name = xml_find_all(a, str_interp("//organization[@id='${org_id}']//title/@value")) %>% xml_text(),
                     cur_name          = xml_find_all(a, str_interp("//organization[@id='${org_id}']//currencies//@id")) %>% xml_text(),
                     cur_br            = xml_find_all(a, str_interp("//organization[@id='${org_id}']//currencies//@br")) %>% xml_text(),
                     cur_ar            = xml_find_all(a, str_interp("//organization[@id='${org_id}']//currencies//@ar")) %>% xml_text()
                   )
  )
  
  # передвигаем прогрессбар
  pb_step <- pb_step + 1
  utils::setTxtProgressBar(pb, pb_step)
}
# закрываем прогрессбар
close(pb)
