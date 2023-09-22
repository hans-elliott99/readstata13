require(devtools) 
devtools::load_all()

# Change `#define USESTRLFIX 0` to `#define USESTRLFIX 1` in src/read_dta.cpp
#  to switch between old behavior and proposed new behavior

# Create df with long string column
# Long strings - strL - are those with > 2045 chars
# (https://www.stata.com/features/overview/long-strings/)
N = 1e5
big_strl <- data.frame(
    x = 1:N,
    y = sample(LETTERS, N, replace = TRUE),
    z = c(paste(rep("a", 3000), collapse=""), sample(LETTERS, N-1, replace=TRUE))
)
# save.dta13 will save 'z' as type strL since it has a string w over 2045 chars
# (as would stata)
if (!file.exists("big_strl.dta"))
    readstata13::save.dta13(big_strl, "big_strl.dta")

# Read data
# Even if we select 1 row, we still have to read all of the long strings
# (time printed is time elapsed every 10,000 iterations)
x <- readstata13::read.dta13("big_strl.dta", select.rows = 1, select.cols = "x")


# note haven completely struggles w strLs
# haven::read_dta("big_strl.dta")
#> Error: Failed to parse big_strl.dta: Invalid file, or file has unsupported features.