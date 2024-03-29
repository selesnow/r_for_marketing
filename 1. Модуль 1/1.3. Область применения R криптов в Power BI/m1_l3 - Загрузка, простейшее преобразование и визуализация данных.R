# R Cource
# Module 1, Lesson 3


# �������� ������� ������
my_data <- read.table("C:/r_for_marketing_course/module_1/lesson_3/name_values.csv", sep = ";", header = T)

# ������ ������� Id �������������
user_id <- data.frame(Name = unique(my_data$Name), user_id = 1:length(unique(my_data$Name)))

# ��������� ������� ������ � �������� Id �������������
my_data <- merge(my_data, user_id, by = "Name", all.x = TRUE)

# ������� ������� � ������� 
my_data$Name <- NULL

# ��������� � id ������������ ������
my_data$user_id <- paste0("user_", my_data$user_id)

# ������� ������� id �������������
rm(user_id)

# ������ ������ �� ������ ���������� ������
boxplot(data = my_data, Value ~ user_id)