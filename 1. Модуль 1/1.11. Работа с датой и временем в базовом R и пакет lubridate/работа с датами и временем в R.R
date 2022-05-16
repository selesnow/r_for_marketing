# Работа с датами в R

Sys.Date()     # текущая дата
Sys.Date() - 7 # дата которая была 7 дней назад
Sys.time()     # текущая дата и время
Sys.timezone() # часовой пояс

first_day_in_2018 <- as.Date("2018-01-01")
class(first_day_in_2018)
# последовательность дат
date_vector <- seq.Date(from = first_day_in_2018, to = as.Date("2018-06-01"), by = "month")
seq.Date(from = first_day_in_2018, to = as.Date("2018-06-01"), by = "week")
seq.Date(from = first_day_in_2018, to = as.Date("2018-06-01"), length.out = 10)

# пакет lubridate
install.packages("lubridate")
library(lubridate)

today() # текущая дата
date()  # текущая да
now()   # текущая дата и время
start_time <- now()

# преобразовать строку в дату
ymd("20180715")
ymd("2018-07-15")
mdy("07152018")
dmy("15.07.2018")
ymd_hms("2018-07-15 12:30:00 Europe/Helsinki")

# часовые пояса
my_time <- now()
OlsonNames(tzdir = NULL) # список всех часовых поясов
with_tz(my_time, tzone = "UTC")
with_tz(my_time, "America/Chicago")

# получить день, месяц и год из даты
today_date <- today()
day(today_date)     # получить день из даты
month(today_date)   # получить месяц из даты
year(today_date)    # получить месяц из даты
quarter(today_date) # получить номер квартала из даты
qday(today_date)    # получить номер дня в квартале
yday(today_date)    # получить номер дня в году

# получить днь недели
wday(today_date,
     label = TRUE,
     abbr = TRUE,
     week_start = 1)

# округление дат
round_date(today_date, unit = "month")   # округлить до ближайшего месяца
round_date(today_date, unit = "quarter") # округлить до ближайшего квартала
floor_date(today_date, unit = "month")   # округлить вниз до ближайшего месяца
ceiling_date(today_date, unit = "month") # округлить вверх до ближайшего месяца
ceiling_date(today_date, unit = "quarter")

# арифметичские операции с датами
today() - months(6) # 6 месяцев назад от текущей даты

# получить первый и последний прошлого квартала
today() - qday(today()) # получаем конец прошлого квартала
floor_date(today() - qday(today()), unit = "quarter")  # получаем начало прошлого квартала

# получить первый и последний прошлого месяца
floor_date(today() - day(today()), unit = "month")
today() - day(today())

# вычисление длительности
end_time <- now()
difftime(end_time, start_time, units = "secs") # в секундах
difftime(end_time, start_time, units = "mins") # в минутах

# Работа со временем в R
end_time + hours(30)    # прибавить 3 часа
end_time + minutes(15) # прибавить 15 минут
hour(end_time)         # получить часы из времени
minute(end_time)       # получить минуты из времени
second(end_time)       # получить секунды из времени
