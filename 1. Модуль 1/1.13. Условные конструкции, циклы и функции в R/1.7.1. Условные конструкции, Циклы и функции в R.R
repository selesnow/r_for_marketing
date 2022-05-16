# Условные конструкции и операты
vec_1 <- runif(n = 30, min = 5, max = 50)

# векторизированный оператор ifelse
ifelse(vec_1 > 25, "Больше 25", "Меньша 25")

x <- 10

# условная конструкция if
if (x < 25) {
  print("x меньше 25")
} else if (x <= 40) {
  print("x больше 25 но меньше 40")
} else {
  print("x больше 40")
}

employ_name <- "Alexey"

# переключатель, аналог case
switch (employ_name,
         Alexey  = 3,
         Sergey  = 1.5,
         Denis   = 2,
         Nikolay = 4,
         0)

# Циклы в R
# Цикл for
employ_name <- c("Alexey", "Sergey", "Nikolay")

for (name in employ_name) {
  print(paste("Hello", name))
}

for (i in 1:length(employ_name)) {
  print(paste("Hello", employ_name[i]))
}

# загрузка данных из множества файлов одинаковой структуры
setwd( "C:/r_for_marketing_course/Материалы курса/Модуль 1/Урок 9") # переходим в рабочую директорию

library(dplyr)  # подключаем пакет dplyr
files <- dir()  # получаем список файлов из рабочей директории
load_files <- files[ grepl("^data_from", files) ] # оставляем список файлов который начинается на load_data

load_data <- list() # создаём объек класса list в который будет загружать файлы

for (f in load_files) {
  load_data <- c(load_data,
                 # по очереди загружаем каждый файл и присоединяем к объекту load_data
                 list(read.table(f, sep = ";", header = T)))
}

data <- bind_rows(load_data) # преобразуем загруженные файлы в data.frame


# Цикл whie
x <- 0

while ( x < 7 ) {
  print(paste("x равен", x))
  x <- x + 1
}

input <- ""
while (input != "stop") {
  input <- readline("Введите текст: ")
  print(paste0("Ваш текст: ", input))
}

input <- ""
n <- 0

while (input != "stop") {
  input <- readline("Введите текст: ")
  print(paste0("Ваш текст: ", input))
  n <- n + 1
    if (n > 3) {
      print("Вы вводили текст более трёх раз, цикл окончен")
      break
    }
}

# Функции
# простая функция
my_fun_sum <- function(x, y, z) {
  result <- (x + y) * z
  return(result)
}

my_fun_sum(10, 15, 2)

# функция с переключателем
agr <- function (x, type) {
        switch(type,
               mean      = mean(x),
               median    = median(x),
               sum       = sum(x),
               quantiles = quantile(x, probs = c(0.25, 0.5, 0.75)))
}

agr(c(5, 17, 32, 15), type = "mean")
agr(c(5, 17, 32, 15), type = "quantiles")


# функция для загрузки файлов
file_loader <- function(prefix, ...) {
    # получаем список файлов из рабочей директории
    files <- dir()

    # оставляем список файлов который начинается на load_data
    load_files <- files[ grepl(prefix, files) ]

    # создаём объек класса list в который будет загружать файлы
    load_data <- list()

    # циклом обрабатываем каждый файл
    for (f in load_files) {
      load_data <- c(load_data,
                     # по очереди загружаем каждый файл и присоединяем к объекту load_data
                     list(read.table(f, ...)))
    }

    data <- bind_rows(load_data) # преобразуем загруженные файлы в data.frame

    # возвращаем полученный результат
    return(data)
}


my_files <- file_loader(prefix = "^data_from",
                        sep = ";",
                        header = TRUE)
