# Работа со строками в R
text <- c("Склеить", "несколько", "строк", "в", "одну")

# посчитать количество символов в строке
nchar(text)

# Конкатенация строки
paste0(text, collapse = "-")
paste("Склеить", "несколько", "строк", "в", "одну")
paste("Склеить", "несколько", "строк", "в", "одну", collapse = "-")
paste(text, c("раз", "два", "три"), collapse = "-", sep = "+")

# получить подстроку
substr(text, start =  3, stop = 5)

# ращбить строку по разедителю
my_string <- "Первая часть, вторая часть, третья часть"
strsplit(my_string, ", ")

# преобразование регистра
tolower(my_string)
toupper(my_string)
casefold(my_string, upper = TRUE)
casefold(my_string, upper = FALSE)

# удаление лишних пробелов в начале и конце строки
text_with_spaces <- " добавим   несколько     лишних      пробелов     "
trimws(text_with_spaces, which = "both")

# работа с регулярными выражениями
grepl(x = text_with_spaces, pattern = "^ ", ignore.case = T)           # проверить соответвует ли срока регулярному выражению
gsub(pattern = "^ | {2, }| $", replacement = "", x = text_with_spaces) # замена части строки по регулярному выражению
# получить подстроку соответвующую регулярному выражению
m <- regexpr("(.*о.*)", text)
regmatches(x = text,m =  m)

# работа с кодировками
my_text <- "мой текст"
Encoding(my_text)
to_utf8 <- iconv(my_text, to = "UTF-8")
Encoding(to_utf8)
to_1251 <- iconv(to_1251, from = "UTF-8", to = "1251")
Encoding(to_1251)

# пакет stringr
install.packages("stringr")
library(stringr)

# преобразование строки
str_c(text, c("раз", "два", "три"), collapse = "-", sep = "+") # конкатенация строк
str_replace_all(string = "УбИрём одно слово", pattern =  "УбИрём", replacement = "Уберём") # замена части строки
str_to_lower("Перевод В Нижний Регистр") # перевод в нижний регистр
str_to_upper("перевод в верхний регистр") # перевод в верхний регистр
str_to_title("заглавная первая буква") # перевод в регистр заголовков
str_remove_all("Уберём все пробелы", " ") # удаление символов из строки
str_squish("  Уберём    лишние  пробелы   ") # Удаление лишних пробелов
str_split("Разобъём - строку - по - разделителю", " - ") # разбивка строки по разделителю
str_pad("дополняем строку",side = "both", width = 50, pad = "$") # дополнение строки опредённым символов до нужного размера

# извлечение части строки
str_extract(pattern = "(.*о.*)", string = text) # извлечение части строки по паттерну
str_sub("Часть строки", start = 3, end = 7) # извлечние части строки по номеру символа
word("Извлекаем слова по их номерам из предложения", 4, end = 7) # извлечение слова из предложения
word("Извлекаем_слова_по_их_номерам_из_предложения", 4, end = 7, "_") # извлечение слова из предложения разделённого _

# подсчёт символов
str_length("Какая то большая строка") # посчитать количество символов
str_count(string = "посчитаем сколько раз встречается буква о", pattern = "о") # считает количество входежний символа в строку

# проверка строки
str_detect(string = " пробел", pattern = "^ ") # проверяет соответсвие строки регулярному выражению



# подстановка значений в сроку из переменны
name <- c("Alexey", "Sergey")
surname <- c("Seleznev", "Petrov")
age <- c(34, 38)
city <- c("Odessa", "Moscow")

str_glue("Hi, my name is {name} {surname}. I am {age} years old and i live in {city}.")
str_interp("Average age by ${paste(name, collapse = ' and ')} is a ${mean(age)}")

