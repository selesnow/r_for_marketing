install.packages("taskscheduleR")
library("taskscheduleR")

script_path <- "C:\\r_for_marketing_course\\Материалы курса\\Модуль 3\\Урок 5\\my_script.R"

# create task
taskscheduler_create(taskname = "google_ads_daily",
                     rscript = "C:\\r_for_marketing_course\\Материалы курса\\Модуль 3\\Урок 5\\my_script.R",
                     schedule = "DAILY",
                     starttime = "09:30",
                     startdate = format(Sys.Date(), "%d.%m.%Y"))

# get task list
task <- taskscheduler_ls(fileEncoding = "CP866")

# start task
taskcheduler_runnow(taskname = 'google_ads_daily')

# delete task
taskscheduler_delete(taskname = "google_ads_daily")

