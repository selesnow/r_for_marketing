# R Cource
# Module 1, Lesson 3


# Загрузка таблицы данных
my_data <- read.table("C:/r_for_marketing_course/module_1/lesson_3/name_values.csv", sep = ";", header = T)

# Создаём таблицу Id пользователей
user_id <- data.frame(Name = unique(my_data$Name), user_id = 1:length(unique(my_data$Name)))

# Соединяем таблицу данных с таблицей Id пользователей
my_data <- merge(my_data, user_id, by = "Name", all.x = TRUE)

# Удаляем столбец с именами 
my_data$Name <- NULL

# Добавляем к id пользователя суфикс
my_data$user_id <- paste0("user_", my_data$user_id)

# Удаляем таблицу id пользователей
rm(user_id)

# Строим график на основе полученных данных
boxplot(data = my_data, Value ~ user_id)