repo_inserts_deletes <-
  function(repos_dir_path = "/mnt/volume_nyc1_01/cloned_repos/julia/",
           test_limit = 0) {
    library("gitsum")
    library("tidyverse")
    library("forcats")
    
    repos <- list.dirs(repos_dir_path, recursive = FALSE)
    
    
    if (test_limit != 0)
      repos <- repos[1:test_limit]
    repos_cnt <- length(repos)
    
    print(paste("repos found:", repos_cnt))
    
    i <- 1
    out.matrix <- matrix(NA, nrow = length(repos), ncol = 4)
    colnames(out.matrix) <- c("repo", "commit", "insertion", "deletion")
    
    for (repo in repos) {
      print(paste("processing repo", basename(repo), i, "of", repos_cnt))
      result <- tryCatch({
        out.matrix[i, 1] <- basename(repo)
        init_gitsum(repo, over_write = TRUE)
        log <- parse_log_detailed(repo)
        out.matrix[i, 2] <- nrow(log)
        out.matrix[i, 3] <- sum(log$total_insertions)
        out.matrix[i, 4] <- sum(log$total_deletions)
        
      }, warning = function(war) {
        print(paste("MY_WARNING:  ", war))
        return(NA)
        
      }, error = function(err) {
        print(paste("ERROR:  ", err))
        #o <- out.matrix[i, 1] <- paste(basename(repo), "ERROR")
        return(NA)
        
      }, finally = {
        
      })
      
      i <- i + 1
    }
    out.matrix
  }
