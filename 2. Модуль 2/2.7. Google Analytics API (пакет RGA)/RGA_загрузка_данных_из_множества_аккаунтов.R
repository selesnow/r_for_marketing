library(RGA)
library(dplyr)

setwd("C:\\r_for_marketing_course\\Материалы курса\\Модуль 2\\Урок 7")

# авторизация
selenow         <- authorize(username = "selesnow")
r.for.marketing <- authorize(username = "r.for.marketing")

# список учётных данных
my_credentila <- list(selenow = selenow,
                      r.for.marketing = r.for.marketing)

# результирующие данные
out_data      <- list()

for (g_account in names(my_credentila)) {

  profiles_ids <- RGA::list_profiles(token = my_credentila[[g_account]])

  for (view_id in profiles_ids$id) {

    temp_data <- get_ga(profileId     = paste0("ga:", view_id),
                        start.date    = "14daysAgo",
                        end.date      = "yesterday",
                        metrics       = "ga:users,ga:sessions,ga:bounces",
                        dimensions    = "ga:date,ga:source,ga:medium",
                        samplingLevel = "HIGHER_PRECISION",
                        token = my_credentila[[g_account]])

        if ( is.null(temp_data) ) {
          next
        } else {
          # считаем к-во объектов в списке
          i <- length(out_data) + 1
          out_data[[i]] <- mutate(temp_data,
                                  account = g_account,
                                  view_id = view_id)
          rm("temp_data")
        }
  }
}

# обхединяем в таблицу
result <- bind_rows(out_data)
