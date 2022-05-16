install.packages('timeperiodsR')
library(timeperiodsR)

# last month
pm <- previous_month()
m_start <- pm$start
m_end   <- pm$end

# previous week
pw <- previous_week()
w_start <- pw$start
w_end   <- pw$end

# last days
ld15 <- last_n_days(n = 15)
ld_start <- ld15$start
ld_end   <- ld15$end

ld15$sequence
ld15$length

# this month
tm <- this_month()
tm$length

# filters
lw6 <- last_n_weeks(n = 6)

lw6 %left_in%   tm
lw6 %left_out%  tm
lw6 %right_in%  tm
lw6 %right_out% tm