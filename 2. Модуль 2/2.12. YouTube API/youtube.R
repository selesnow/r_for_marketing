# install
devtools::install_github("MarkEdmondson1234/youtubeAnalyticsR")

# lib
library(youtubeAnalyticsR)
library(googleAuthR)

# options
options(googleAuthR.client_id       = "")
options(googleAuthR.client_secret   = "")
options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/yt-analytics.readonly")

# directory
setwd("C:/r_for_marketing_course/Материалы курса/Модуль 2/Урок 10 - Youtube")

# auth
yt_auth()

# statistics
# channel statistics
chennel_stat <- yt_analytics(id = "UCyHC6R3mCCP8bhD9tPbjnzQ", 
                             start.date = "2019-03-01", 
                             end.date = "2019-03-10", 
                             type = "channel",
                             metrics = c("views","comments","likes","dislikes","redViews"), 
                             dimensions = c("day"))

# videostat
video_stat <- yt_analytics(id         = "UCyHC6R3mCCP8bhD9tPbjnzQ", 
                           start.date = "2019-01-01", 
                           end.date   = Sys.Date(), 
                           type       = "channel",
                           metrics    = c("views"), 
                           dimensions = c("day,video"),
                           filters    = "video==ESl3NR01IXI")

# ###############################
# tuber
# ###############################
install.packages("tuber")
library(tuber)

# auth
yt_oauth("321452169616-a3fqd8nevmjo6nn1cas9pm44aljvb3qn.apps.googleusercontent.com",
         "VnxnUa2pff5Zr6HQZ_BOqja2")


# load objects
list_my_channels       <- list_my_channel()
my_channel             <- get_channel_stats("UCyHC6R3mCCP8bhD9tPbjnzQ")   
my_videos              <- list_channel_videos(channel_id = "UCyHC6R3mCCP8bhD9tPbjnzQ")
video_current_stat     <- get_stats(video_id = "ESl3NR01IXI")
video_details          <- get_video_details(video_id = "ESl3NR01IXI")
all_video_current_stat <- get_all_channel_video_stats(channel_id = "UCyHC6R3mCCP8bhD9tPbjnzQ")

searching              <- yt_search(term = "R Language")

# статистика по всем видео по датам
daily_video_stat <- data.frame()

# цикл
for ( id in my_videos$contentDetails.videoId ) {
  # get current video stat
  temp_video_stat <- try(yt_analytics(id         = "UCyHC6R3mCCP8bhD9tPbjnzQ", 
                                      start.date       = "2019-01-01", 
                                      end.date         = Sys.Date(), 
                                      type       = "channel",
                                      metrics    = c("views","comments","likes","dislikes","redViews"), 
                                      dimensions = c("day,video"),
                                      filters    = paste0("video==", id)))
  
  if ( class(temp_video_stat) == "try-error" ) {
    next
  } else {
    daily_video_stat <- rbind(daily_video_stat, temp_video_stat)
  }
}

# альтернатива
daily_video_stat_2 <- sapply(my_videos$contentDetails.videoId,
                             function(x) {
                               yt_analytics(id         = "UCyHC6R3mCCP8bhD9tPbjnzQ", 
                                            start.date = "2019-01-01", 
                                            end.date   = Sys.Date(), 
                                            type       = "channel",
                                            metrics    = c("views","comments","likes","dislikes","redViews"), 
                                            dimensions = c("day,video"),
                                            filters    = paste0("video==", x)) 
                               }
                             )

# преобразуем результат в таблицу
daily_video_stat_2 <- dplyr::bind_rows(daily_video_stat_2)

# сравниваем результат полученный двумя способами
all.equal(daily_video_stat,
          daily_video_stat_2)
