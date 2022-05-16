# отчёт по конверсиям с моделью аттрибуции за статичный период
attribution_report <- yadirGetReport(DateFrom          = "2018-11-15",
                                     DateTo            = "2018-11-20",
                                     FieldNames        = c("Date", 
                                                           "Conversions"),
                                     Goals             = c(27475434, 38234732),
                                     AttributionModels = c("LC", "LSC", "FC"),
                                     Login             = "irina.netpeak",
                                     TokenPath         = "C:\\r_for_marketing_course\\tokens")


