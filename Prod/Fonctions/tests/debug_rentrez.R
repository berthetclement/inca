entrez_post <- function (db, id = NULL, web_history = NULL, config = NULL, 
          ...) 
{
  browser()
  args <- list("epost", db = db, config = config, id = id, 
               web_history = web_history, ...)
  if (!is.null(web_history)) {
    args <- c(args, WebEnv = web_history$WebEnv, query_key = web_history$QueryKey)
    args$web_history <- NULL
  }
  response <- do.call(make_entrez_query, args)
  record <- xmlTreeParse(response, useInternalNodes = TRUE)
  result <- xpathApply(record, "/ePostResult/*", XML::xmlValue)
  names(result) <- c("QueryKey", "WebEnv")
  class(result) <- c("web_history", "list")
  return(result)
}


make_entrez_query <- function (util, config, interface = ".fcgi?", by_id = FALSE, 
          debug_mode = FALSE, ...) 
{
  browser()
  uri <- paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/", 
                util, interface)
  args <- list(..., email = rentrez:::entrez_email(), tool = rentrez:::entrez_tool())
  if (!("api_key" %in% names(args))) {
    if (rentrez:::is_entrez_key_set()) {
      args$api_key <- Sys.getenv("ENTREZ_KEY")
    }
  }
  if ("id" %in% names(args)) {
    if (by_id) {
      ids_string <- paste0("id=", args$id, collapse = "&")
      args$id <- NULL
      uri <- paste0(uri, ids_string)
    }
    else {
      len_arg_id <- length(args$id)
      args$id <- paste(args$id, collapse = ",")
      }
  }
  if (debug_mode) {
    return(list(uri = uri, args = args))
  }
  if (is.null(config)) {
    config = httr::config(http_version = 2)
  }
  else {
    if ("http_version" %in% names(config$options)) {
      warning("Over-writing httr config options for 'http_version', as NCBI servers require v1.1")
    }
    config$options$http_version <- 2
  }
  if (len_arg_id > 200) {
    response <- httr::POST(uri, body = args, config = config)
  }
  else {
    response <- httr::GET(uri, query = args, config = config)
  }
  rentrez:::entrez_check(response)
  Sys.sleep(rentrez:::sleep_time(args))
  httr::content(response, as = "text", encoding = "UTF-8")
}
