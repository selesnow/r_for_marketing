install.packages("httr")
library(httr)

# �������� GET �������
get_answer <- GET(url = "http://httpbin.org/ip")
# ��������� ������
headers(get_answer)
# ������� ������� ������
status_code(get_answer)
# ������� ������
my_ip <- content(x = get_answer, as = "parsed", type = "application/json")
# Values
#text/html
#text/xml
#text/csv
#text/tab-separated-values
#application/json
#application/x-www-form-urlencoded
#image/jpeg
#image/png

# �������� ������� � ����������� � �����������
get_answer <- GET("http://httpbin.org/get",
                  query = list(param1 = "val1",
                               param2 = "value2",
                               date_from = "2018-08-10"))

my_params <- content(x = get_answer, as = "parsed", type = "application/json")$args

# �������� ������� � �����������
get_answer <- GET("http://httpbin.org/get",
                  config = add_headers(param3 = "my_header_param",
                                       Authorization = "56536251hshndsh7q687y8"))

my_headers <- content(x = get_answer, as = "parsed", type = "application/json")$headers

# ������� POST �������
r <- POST(url = "http://httpbin.org/post", 
          body = list(a = 1, b = 2, c = 3))

# Request parts
url <- "http://httpbin.org/post"
body <- list(a = 1, b = 2, c = 3)

# Form encoded
r <- POST(url, body = body, encode = "form")
# Multipart encoded
r <- POST(url, body = body, encode = "multipart")
# JSON encoded
r <- POST(url, body = body, encode = "json")

# Send files
POST(url, body = upload_file("mypath.txt"))
POST(url, body = list(x = upload_file("mypath.txt")))
