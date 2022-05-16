library(httr)
library(purrr)
# отправка запроса к API
r <- GET("http://resources.finance.ua/ua/public/currency-cash.json")
# парсинг результата ответа в JSON формате
a <- content(r, "parsed", "application/json")

# перевод объекта класса list в таблицу
# создаём результирующий list
data <- list() 
# дата за которые мы запросили курс
cur_date <- a$date
# построчно собираем данные в новый list однородной структуры
for ( i in  a$organizations ) {
  
  data <- append(data,
                 list(
                   list(cur_date      = cur_date,
                        organizations = i$title,
                        phone         = i$phone,
                        address       = i$address,
                        usd_ask       = ifelse( is.null(i$currencies$USD$ask), NA, i$currencies$USD$ask),
                        usd_bid       = ifelse( is.null(i$currencies$USD$bid), NA, i$currencies$USD$bid),
                        eur_ask       = ifelse( is.null(i$currencies$EUR$ask), NA, i$currencies$EUR$ask),
                        eur_bid       = ifelse( is.null(i$currencies$EUR$bid), NA, i$currencies$EUR$bid),
                        rub_ask       = ifelse( is.null(i$currencies$RUB$ask), NA, i$currencies$RUB$ask),
                        rub_bid       = ifelse( is.null(i$currencies$RUB$bid), NA, i$currencies$RUB$bid))))
  
}
# переводим list в формат таблицы
currency <- dplyr::bind_rows(data)

