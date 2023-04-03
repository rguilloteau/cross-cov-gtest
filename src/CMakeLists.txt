add_library(greatestof3 greatestof3.cpp)

set_target_properties(greatestof3 PROPERTIES PUBLIC_HEADER "greatestof3.h")
install(TARGETS greatestof3)
