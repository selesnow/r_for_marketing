# ######################################################
# Загрузка данных в R ####
# ######################################################
# Загрузка данных из файлов
## загрузка из csv файлов
setwd("C:/r_for_marketing_course/Материалы курса/Модуль 1/Урок 7/")
sales   <- read.table("sales.csv", sep = ";", header = T)
country <- read.table("country.csv", sep = ";", header = T)
clients <- read.table("clients.csv", sep = ";", header = T)
product <- read.table("product.csv", sep = ";", header = T)

## загрузка данных из Excel файлов
install.packages("readxl")
library(readxl)
bad_format_data <- read_excel( "tidyr_example.xlsx" , sheet = "tidyr_example", col_names = T)

## загрузка данных из JSON файлов
install.packages("jsonlite")
library(jsonlite)
data_from_json <- read_json("dictionary.json")

# ######################################################
# манипуляция с данными с помощью пакеа dplyr ####
# ######################################################
# Пакет dplyr
#install.packages("dplyr")
install.packages("tidyverse")
library(tidyverse)

# выбор нескольких полей
select(sales, quantity, transaction_id)
select(sales,  contains(match = "a"))
select(sales,  ends_with("id"))

# фильтрация данных
filter(sales, client_id == 10) # все продажи по клиенту с id 10
filter(sales, manager == "Sergey" & quantity >= 6)

# сортировка данных
arrange(sales, -quantity)

# группировка и агрегация данных
group_by(sales, manager)
summarise( group_by(sales, manager),
                count            = n(),
                total_quantity   = sum(quantity),
                average_quantity = mean(quantity),
                products         = length(unique(product_id)))

# конверный стиль записи
sales %>%
  group_by(manager) %>% # группируем таблицу по полю manager
  summarise(count            = n(),                            # считаем количество строк по каждому менеджеру
            total_quantity   = sum(quantity),                  # считаем количество проданных едениц товара
            average_quantity = mean(quantity),                 # считаем среднее количество едениц товара в транзации
            products         = length(unique(product_id))) %>% # считаем какое к-во наименований товара продал менеджер
  arrange(-total_quantity) %>% # сортирум таблицу по полю total_quantity по убыванию
  head(3) # оставляем 3 верхние строки


# соединение таблиц
# соединение таблиц по ключу
sales %>%
  left_join(product, by = c("product_id" = "id")) %>%
  right_join(clients, ., by = c("id" = "client_id")) %>%
  left_join(country, by = c("country_id" = "id"))
# фильтрующие соединения
anti_join(product, sales, by = c("id" = "product_id")) # товары по которым не было транзакций
semi_join(product, sales, by = c("id" = "product_id")) # товары по которым были транзакции
# Какие товары из справочника product не покупал клиент с id 12
sales %>%
  filter(client_id == 12) %>%
  anti_join(product, ., by = c("id" = "product_id"))

# Агрегирующие функции
sum(sales$quantity)                    # суммирование
mean(sales$quantity)                   # среднее арифметическое
median(sales$quantity)                 # медиана
quantile(sales$quantity, probs = 0.25) # квантиль
length(sales$quantity)                 # количество
length(unique(sales$manager))          # количество уникальных

# Арифметические операции
5 + 2   # сложение
5 - 2   # вычитание
5 * 2   # умножение
5 / 2   # деление
5 ** 2  # степень
5 %/% 2 # целочисленное деление
5 %% 2  # остаток от целочисленного деления

# ######################################################
# манипуляция с данными с помощью пакеа data.table ####
# ######################################################
# Пакет data.table
install.packages("data.table")
library("data.table")

# загрузка данных
sales_dt <- fread("sales.csv")
class(sales_dt)
class(sales)
class(clients)
clients_dt <- as.data.table(clients)
country_dt <- as.data.table(country)
product_dt <- as.data.table(product)
class(clients_dt)
# фильтр, группировка и агрегация
sales_dt[product_id == 5,
         .(count = .N,
           total_quantity = sum(quantity)),
         by = manager]

sales_dt[product_id == 5,
         .(count = .N,
           total_quantity = sum(quantity)),
         keyby = manager]

# соединение
merge(sales_dt, product_dt,
      by.x = "product_id",
      by.y = "id",
      all.x = TRUE)

# цепочки
sales_dt[,
         .(count            = .N,                             # считаем количество строк по каждому менеджеру
           total_quantity   = sum(quantity),                  # считаем количество проданных едениц товара
           average_quantity = mean(quantity),                 # считаем среднее количество едениц товара в транзации
           products         = length(unique(product_id))),    # считаем какое к-во наименований товара продал менеджер
         by = manager][order(total_quantity, decreasing = TRUE)][1:3,]

# Ключи в data.table
setkey(sales_dt, manager)    # установка ключа по названию поля без кавычек
setkeyv(sales_dt, "manager") # установка ключа по названию поля с кавычами
sales_dt["Sergey"]           # фильтрация по ключу
sales_dt[c("Sergey", "Alexey")]
key(sales_dt)                # просмотр ключа таблицы

setkey(sales_dt, manager, product_id)
key(sales_dt)
sales_dt["Sergey"]
sales_dt[.("Sergey", 6)]     # выборка по двум ключам
sales_dt(list("Sergey", 6))
sales_dt[.(c("Sergey", "Alexey"), c(6, 8))]

# ######################################################
# манипуляция с данными с помощью пакеа tidyr ####
# ######################################################
# пакет tidyr
install.packages("tidyr")
library(tidyr)

# шаг 1, заполняем пропущенные значения
bad_data_step1 <- fill(bad_format_data, country)
# шаг 2, разделяем код клиента по составляющим
bad_data_step2 <- separate(data = bad_data_step1,
                           col  = client_code,
                           into = c("client_segment", "client_id", "client_class"),
                           sep  = "_")

# шаг 3, добавляем столбец месяц
bad_data_step3 <- gather(data = bad_data_step2,
                         key = "month",
                         value = "sales_count",
                         June, July, Aug, Sept)

bad_data_step3 %>%
  group_by(client_class) %>%
  summarise(total_sale = sum(sales_count))

# конвеерный стиль
good_data <- bad_format_data %>%
                  fill(country) %>%
                  separate(col  = client_code,
                           into = c("client_segment", "client_id", "client_class"),
                           sep  = "_") %>%
                  gather(key = "month",
                         value = "sales_count",
                         June:Sept)

# объеденение нескольких полей в одно
unite(data = good_data, col = "code", sep = "-", country, client_segment, remove = FALSE)


# ######################################################
# манипуляция с данными с помощью пакеа sqldf ####
# ######################################################
install.packages("sqldf")
library(sqldf)

options(sqldf.driver = "SQLite") # выбор драйвера, работает с SQLite, H2, PostgreSQL, MySQL

sqldf("SELECT * from clients") # простой запрос
sqldf("SELECT * from sales left join product on sales.product_id = product.id") # соединение


# повторяем агрегацию применяемую в примере с dplyr и data.table
sqldf_exampl <- sqldf("SELECT
                         manager,
                         COUNT(*) as count,
                         SUM(quantity) as total_quantity,
                         AVG(quantity) as average_quantity,
                         COUNT(DISTINCT product_id) as products
                       FROM sales
                       GROUP by manager
                       ORDER BY total_quantity DESC
                       LIMIT 3")
