
test_error_list <- list(5, 12, 8, "u", 3, 7, 9)

for ( i in 1:length(test_error_list)) {
  print(paste0("i is ", test_error_list[[i]]))
  print(test_error_list[[i]] * 12)
}

# обработка ошибок
for ( i in 1:length(test_error_list)) {

  print(paste0("i is ", test_error_list[[i]]))
  check_result <- try (test_error_list[[i]] * 12, silent = TRUE)

  if (class(check_result) == "try-error") {
    print(paste("error: ", as.character(attr(check_result, "condition"))))
    next
  } else {
    print(check_result)
  }
}


