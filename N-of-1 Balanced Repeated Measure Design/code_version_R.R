library(dict)
library(glue)
library(ggplot2)


# Function to generate william's latin square
will_latin <- function(num) {
  
    # Parameters:
    # ----------------
    
    # num: numbers of treatments

  first_arr <- dict()
  second_arr <- dict()
  # Select the names(numbers) that need to be used by the given number
  letter_to_use <- c()
  for (i in 1 : num) {
    letter_to_use[[i]] = i
  }
  letter_to_use <- sample(letter_to_use) # shuffle the list
  
  for (i in 1 : num) {
    # Construct the right order sequence
    right_order <- c(letter_to_use[c(i:num)], letter_to_use[c(1:i-1)])
    first_arr[[i]] <- right_order
    # The reverse order sequence
    second_arr[[i]] <- sample(right_order)
  }
  
  # After construct the two sequence, now we start to build the william's Latin square
  final_arr <- dict()
  for (i in 1 : num) {
    final_arr[[i]] <- vector()
    for (j in 1 : (2 * num)) {
      if (j %% 2 == 1) {
        final_arr[[i]][[j]] <- first_arr[[i]][[(j + 1) %/% 2]]
      } else {
        final_arr[[i]][[j]] <- second_arr[[i]][[(j + 1) %/% 2]]
      }
    }
  }
  
  # Now we need to consider the given number is even or odd and return the result
  if (num %% 2 == 0) {
    arr_1 <- dict()
    arr_2 <- dict()
    for (key in final_arr$keys()) {
      arr_1[[key]] <- final_arr[[key]][c(1:num)]
      arr_2[[key]] <- tail(final_arr[[key]], num)
    }
    list_to_return <- list(arr_1, arr_2, final_arr)
    return(list_to_return)
  } else { # num is odd
    return(final_arr)
  }

}


# Function that generates relationship between numbers and treatments
initiation <- function(num_of_treatments, order_to_consider) {
  
    # Parameters:
    # ----------------
    
    # num_of_treatments: numbers of single treatments (eg: [AB] is 2 and [ABC] is 3)
    # order_to_consider: consider second order or only first order
    
    # Return:
    # ----------------
    # var_dict: a dict indicating relationship between number and the sequenct it represent
    # array_dicts: the sequence constructed by william's latin square
  
  
  # Create a dictionary for storing variable name in latin square and the correspongding combination
  var_dict <- dict()
  
  total_comb <- num_of_treatments ^ 2 # if only consider first order
  first_order_prod <- c(outer(LETTERS[1:num_of_treatments], LETTERS[1:num_of_treatments], FUN = paste0))
  
  if (grepl("second", order_to_consider, fixed = TRUE)) { # if consider second order
    total_comb <- total_comb * num_of_treatments
  }
  second_order_prod <- c(outer(first_order_prod, LETTERS[1:num_of_treatments], FUN = paste0))
  
  if (grepl("first", order_to_consider, fixed = TRUE)) { # put elements in the dict for first order
    index <- 1
    for (item in first_order_prod) {
      var_dict[[index]] <- item
      index <- index + 1
    }
  } else if (grepl("second", order_to_consider, fixed = TRUE)) { # if consider second order
    index <- 1
    for (item in second_order_prod) {
      var_dict[[index]] <- item
      index <- index + 1
    }
  }
  
  # Construct william's latin square with the number calculated above and return the result
  # Also return the dict of the relationship between names and combinations
  return(list(var_dict, will_latin(total_comb)))
}


# Function for check if a sequence is lawful
total_check <- function(seq_dict, var_dict, order, to_shuffle = FALSE, until = 0, user_sequence = "", to_print = TRUE) {

    # Parameters:
    # ----------------
    # seq_dict: the sequence dictionary to check
    # var_dict: a dict indicating relationship between number and the sequenct it represent
    # order: check first order or second order
    # to_shuffle: whether to shuffle the dict or not, default is false
    # until: check sequence until a given index, default is 0, meaning check all the sequence
    # user_sequence: sometimes user want to manually add sequence, use this, default is "" meaning
    #                use the seq_dict to construct sequence(to_shuffle must be false if use user sequence)
    # to_print: whether to print details result, default is true
    
    # Return:
    # ----------------
    # True if criterions met, False otherwise
  
  # First construct sequence using seq_dict if no sequence given by user
  full_sequence <- user_sequence
  if (full_sequence == "") {
    key_list <- seq_dict$keys()
    
    print(1) # Delete
  
    if (to_shuffle == TRUE) { # If to_shuffle is true, shuffle the keys so the rows of the latin square is random
      key_list <- sample(key_list)
    }
    for (key in key_list) {
      seq <- seq_dict[[key]]
      for (item in seq) {
        full_sequence <- paste(full_sequence, var_dict[[item]], sep = "")
      }
    }
  }
  
  # Now start to check sequence
  # First see if until is set, if yes, we take a subsequence of the original sequence
  if (until != 0) {
    full_sequence <- substr(full_sequence, 1, until)
  }
  # Start to check
  if (grepl("second", order, fixed = TRUE)) { # Check second order
    criterion_count <- numeric(length = length(var_dict$values())) 
    criterions <- var_dict$values()
    for (i in 1:nchar(full_sequence)) {
      if (i > 2) {
        for (j in 1:length(criterions)) {
          if (substr(full_sequence, i-2, i) == criterions[j]) {
            criterion_count[[j]] = criterion_count[[j]] + 1
          }
        }
      }
    }

    
    # If the difference between counts are trivial, consider true
    score_list <- sort(criterion_count)
    
    # Construct a new var_dict for checking first order conditions
    new_var_dict <- dict()
    letters_used_set <- unique(unlist(strsplit(full_sequence, "")))
    # Get first order vars
    first_order_prod <- c(outer(letters_used_set, letters_used_set, FUN = paste0))
    index = 1
    for (comb in first_order_prod) {
      new_var_dict[[index]] <- comb
      index <- index + 1
    }
    
    # Get and return result
    if (score_list[[1]] == score_list[[length(score_list)]]) {
      # Still need to check first order condition
      return(total_check(dict(), new_var_dict, "first", FALSE, until, full_sequence, to_print = FALSE))
    } else if ((score_list[[length(score_list)]] - score_list[[1]]) / score_list[[length(score_list)]] <= 0.33) {
      if (to_print) {
        for (i in 1:length(criterions)) {
          strss <- "{criterions[[i]]}\'s count is {criterion_count[[i]]}"
          print(glue(strss))
        }
      }
      return(total_check(dict(), new_var_dict, "first", FALSE, until, full_sequence, to_print = FALSE))
    } else if (score_list[[length(score_list)]] <= 10 & score_list[[1]] != 0 & score_list[[length(score_list)]] - score_list[[1]] <= 3) {
      if (to_print) {
        for (i in 1:length(criterions)) {
          strss <- "{criterions[[i]]}\'s count is {criterion_count[[i]]}"
          print(glue(strss))
        }
      }
      return(total_check(dict(), new_var_dict, "first", FALSE, until, full_sequence, to_print = FALSE))
    } else {
      if (to_print) {
        print(score_list[[length(score_list)]], score_list[1])
        strs <- "sequence is {full_sequence}"
        print(glue(strs))
        print(" ")
        for (i in 1:length(criterions)) {
          strss <- "{criterions[[i]]}\'s count is {criterion_count[[i]]}"
          print(glue(strss))
        }
      }
      return(FALSE)
    }
  # Now check first order conditions
  } else {
    criterion_count <- numeric(length = length(var_dict$values())) 
    criterions <- var_dict$values()
    for (i in 1:nchar(full_sequence)) {
      if (i > 1) {
        for (j in 1:length(criterions)) {
          if (substr(full_sequence, i-1, i) == criterions[[j]]) {
            criterion_count[[j]] = criterion_count[[j]] + 1
          }
        }
      }
    }
    
    # If the difference between counts are similar, consider true
    score_list <- sort(criterion_count)
    
    # Get and return result
    if (score_list[[1]] == score_list[[length(score_list)]]) {
      if (to_print) {
        for (i in 1:length(criterions)) {
          strss <- "{criterions[[i]]}\'s count is {criterion_count[[i]]}"
          print(glue(strss))
        }
      }
      return(TRUE)
    } else if ((score_list[[length(score_list)]] - score_list[[1]]) / score_list[[length(score_list)]] <= 0.33) {
      if (to_print) {
        for (i in 1:length(criterions)) {
          strss <- "{criterions[[i]]}\'s count is {criterion_count[[i]]}"
          print(glue(strss))
        }
      }
      return(TRUE)
    } else if (score_list[[length(score_list)]] <= 10 & score_list[[1]] != 0 & score_list[[length(score_list)]] - score_list[[1]] <= 2) {
      if (to_print) {
        for (i in 1:length(criterions)) {
          strss <- "{criterions[[i]]}\'s count is {criterion_count[[i]]}"
          print(glue(strss))
        }
      }
      return(TRUE)
    } else {
      if (to_print) {
        print(score_list[[length(score_list)]], score_list[1])
        strs <- "sequence is {full_sequence}"
        print(glue(strs))
        print(" ")
        for (i in 1:length(criterions)) {
          strss <- "{criterions[[i]]}\'s count is {criterion_count[[i]]}"
          print(glue(strss))
        }
      }
      return(FALSE)
    }
  }
}


# Get a sequence from William's latin square and also know the quality of the sequence
get_sequence <- function(seq_dict,var_dict,len = 0) {
  
    # Return a required length sequence to operate, also return if the sequence is good or not
    # by using the function total_check
    
    # Parameters:
    # ----------------
    # seq_dict: the sequence dictionary to check
    # var_dict: a dict indicating relationship between number and the sequenct it represent
    # len: provide a required length to consider, default is 0 which means whatever the length in seq_dict
  
  # First construct sequence using seq_dict
  # if the sequence length is longer than the required length, cut it to the point, if not, reshuffle the
  # rows of latin square and add to the sequence
  full_sequence <- ""
  key_list <- sample(seq_dict$keys())
  
  for (key in key_list) {
    seq <- seq_dict[[key]]
    for (item in seq) {
      full_sequence <- paste(full_sequence, var_dict[[item]], sep = "")
    }
  }
  
  if (len != 0) {
    while (nchar(full_sequence) < len) {
      key_list <- sample(key_list)
      for (key in key_list) {
        seq <- seq_dict[[key]]
        for (item in seq) {
          full_sequence <- paste(full_sequence, var_dict[[item]], sep = "")
        }
      }
    }
    full_sequence <- substr(full_sequence, 1, len)
  }
  
  # Check the quality of this constructed sequence
  quality <- total_check(seq_dict, var_dict, "second", user_sequence = full_sequence, to_print = FALSE)
  
  return(list(full_sequence, quality))
}

# Function for get a random sequence
random_sequence <- function(num, len) {
    
    # Parameter:
    # ------------------------------
    
    # num: same meaning as will_latin's num, e.g., if want AB, input 2, want ABC, input 3
    # len: sequence length, meaning how long a sequence we want to build

  full_sequence <- ""
  letters_needed <- LETTERS[1:num]
  for (i in 1:len) {
      full_sequence <- paste(full_sequence, sample(letters_needed, 1, replace = TRUE), seq = "")
  }
  return(full_sequence)
}


# Get the design matrix for a sequence
# For the most basic case, i.e., no beta3 and no column for x * (x-1)
# And delete the first row since no x-1 element is defined when it comes first row
basic_design_matrix <- function(full_sequence) {
  
    # Return a matrix containing treatment like:
    # t   trt   Y_t   trt-1   z_t   z_t-1   z_tz_t-1
    # 1   A     ...   ---     0     ---     -------
    # 2   B     ...   A       1     0       0
    # 3   B     ...   B       1     1       1
    # .....
    # .....
    
    # Here we only consider two treatment types (A and B) and hence we define A as 0 and B as 1
    
    # So first column represents actual sequence, second column represents the item privous to each item,
    # third column represents the product of the first two columns (no third column here).
    
    # Parameter:
    # ------------------
    # full_seuqnce: the sequence to consider
    
  seq_len <- nchar(full_sequence)
  full_sequence_list <- unlist(strsplit(full_sequence, ""))
  dm <- matrix(nrow = seq_len - 1, ncol = 2)
  for (i in 1:seq_len) {
    if (i == 1) { # The first element in the sequence
      if (full_sequence_list[[i]] == "A") {
        dm[i, 2] = 0.5
      } else {
        dm[i, 2] = -0.5
      }
    } else if (i == seq_len) { # The last element in the sequence
      if (full_sequence_list[[i]] == "A") {
        dm[i - 1, 1] = 0.5
      } else {
        dm[i - 1, 1] = -0.5
      }
    } else { # All the middle elements
      if (full_sequence_list[[i]] == "A") {
        dm[i - 1, 1] = 0.5
        dm[i, 2] = 0.5
      } else {
        dm[i - 1, 1] = -0.5
        dm[i, 2] = -0.5
      }
    }
  }
  
  return(dm)
}


# Calculate y value when given betas and the design matrix
basic_get_y <- function(beta1, beta2, design_matrix, err_std = 1) {
  
    # Take given parameter values and calculate y (response)
    # y_t = beta1 * z_t + beta2 * z_t-1 + beta3 * (z_tz_t-1) + err
    
    # Parameters:
    # -------------------
    # beta1: parameter corresponding with current item
    # beta2: parameter corresponding with immediately previous item
    # design_matrix: the matrix calculated by the design matrix function
    # err_std: error term's standard deviation, default is 1. (error term is draw from a normal distribution
             # with mean 0 and std the given value or 1 by default)

  m <- dim(design_matrix)[[1]] # row length
  n <- dim(design_matrix)[[2]] # column length
  y <- vector(mode = "double", length = m)
  for (i in 1:m) {
    err <- rnorm(1, 0, err_std)
    y[i] <- beta1 * design_matrix[i, 1] + beta2 * design_matrix[i, 2] + err
  }
  
  return(y)
}


# Return predicted beta values in a dictionary (keys are different sequence lengths)
basic_experiment <- function(beta1, beta2, quality, err_std = 1, exp_size = 1000) {
  
    # Run an experiment and return dictionary containing beta values
    
    # Parameters:
    # -------------------
    # quality: state what quality do you want for the experiment, "perfect" means all sample latin square need to
    #          pass the test, "alright" means the latin square samples that don't pass the test, "whatever" means
    #          random sequence, "ABAB" means a sequence containing ABABAB...
    # exp_size: how many samples to draw, default is 1000
    # other parameters similar as in other functions
  
  seq_size_list <- c(24)
  for (i in 1:14) {
    seq_size_list <- append(seq_size_list, 24 + 12 * i)
  }
  
  beta1_dict <- dict()
  beta2_dict <- dict()
  
  # Draw sample and calculate standard error of beta
  for (seq_size in seq_size_list) {
    count = 0
    beta1_dict[[seq_size]] <- vector()
    beta2_dict[[seq_size]] <- vector()
    
    while (count < exp_size) {
      result_list <- initiation(2, "second")
      var_dict <- result_list[[1]]
      seq_dict_list <- result_list[[2]]
      seq_dict <- seq_dict_list[[sample(c(1,2,3), 1)]]
      if (!grepl("whatever", quality, fixed = TRUE)) { # if not random case 
        # Use the get_sequence function to get the sequence generated by William's Latin square
        # and also the quality of it
        l1 <- get_sequence(seq_dict, var_dict, seq_size)
        full_seq <- l1[[1]]
        qua <- l1[[2]]
        if (qua == TRUE & grepl("perfect", quality, fixed = TRUE)) {
          dm <- basic_design_matrix(full_seq) # design matrix
          y <- basic_get_y(beta1, beta2, dm, err_std = err_std)
          # Solve the linear equation and store the beta values
          fit <- lm(y ~ dm[,1] + dm[,2] + 0)
          beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
          beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
          count <- count + 1
        } else if (qua == FALSE & grepl("alright", quality, fixed = TRUE)) {
          dm <- basic_design_matrix(full_seq) # design matrix
          y <- basic_get_y(beta1, beta2, dm, err_std = err_std)
          # Solve the linear equation and store the beta values
          fit <- lm(y ~ dm[,1] + dm[,2] + 0)
        #  beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
        #  beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
            beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], diag(vcov(fit))[1]^0.5)
            beta2_dict[[seq_size]] <- append(beta1_dict[[seq_size]], diag(vcov(fit))[2]^0.5)
          
              count <- count + 1
        }
      } else { # All random case
        sequence <- random_sequence(2, seq_size)
        dm <- basic_design_matrix(sequence) # design matrix
        y <- basic_get_y(beta1, beta2, dm, err_std = err_std)
        # Solve the linear equation and store the beta values
        fit <- lm(y ~ dm[,1] + dm[,2] + 0)
        beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
        beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
        count <- count + 1
      }
    }
  }
  return(list(beta1_dict, beta2_dict))
}

# Calculate MSE
MSE <- function(estimate_array, true_value) {
  
    # Calculate mean standard error
    
    # Parameters:
    # -------------------
    # estimate_array: a vector containing all estimated values of the true value
    # true_value: the value to estimate

  return(mean((estimate_array - true_value) ^ 2))
}


# Draw plot
basic_draw_plot <- function(beta1,beta2, draw, err_std = 1,exp_size = 1000) {
  
    # Draw 3 plots:
    # 1. for standard error of betas
    # 2. mean value of beta hat and std
    # 3. MSE of beta hat
    
    # Parameters:
    # -------------------
    # draw: which beta to draw, give 1 or 2 or 3
    # parameters similar as the above function
    
  name_dict <- dict(init_keys = c(1,2), init_values = list(beta1, beta2))
  quality_list <- c("perfect", "alright", "whatever")
  
  mean_dict <- dict()
  
  se_dict <- dict()
  
  mse_dict <- dict()
  
  mean_std_dict <- dict()
  
  for (qu in quality_list) {
    mean_dict[[qu]] <- vector()
    se_dict[[qu]] <- vector()
    mse_dict[[qu]] <- vector()
    
    beta_dict_list <- basic_experiment(beta1, beta2, qu, err_std = err_std, exp_size = exp_size)
    if (draw == 1) { # plot beta1
      beta_to_draw <- beta_dict_list[[1]]
    } else if (draw == 2) { # plot beta2
      beta_to_draw <- beta_dict_list[[2]]
    }
    
    for (key in beta_to_draw$keys()) {
      mean_dict[[qu]] <- append(mean_dict[[qu]], mean(beta_to_draw[[key]]))
      se_dict[[qu]] <- append(se_dict[[qu]], sd(beta_to_draw[[key]]))
      mse_dict[[qu]] <- append(mse_dict[[qu]], MSE(beta_to_draw[[key]], name_dict[[draw]]))
    }
      
    mean_std_dict[[qu]] <- se_dict[[qu]] / sqrt(exp_size)
  }
  
  # If want to manually add plot, uncomment below
  return(list(mean_dict, se_dict, mse_dict, mean_std_dict))
}
      
  # Actual plotting
  # First plot (this plot is for standard error)
  key_list <- beta_to_draw$keys()
  data_se <- structure(list(seq_length = key_list, perfect = se_dict[["perfect"]], alright = se_dict[["alright"]],
                          whatever = se_dict[["whatever"]]), 
                     .Names = c("seq_length", "perfect","alright","whatever"), class = "data.frame", row.names =  c(NA, -15L))
  p1 <- ggplot(data = data_se, aes(x=seq_length)) + geom_line(aes(y = perfect, colour = "perfect")) + 
    geom_line(aes(y = alright, colour = "alright")) + geom_line(aes(y = whatever, colour = "whatever")) +
    labs(title = glue("Standard error Comparasion for beta{draw} with beta values {beta1}, {beta2}")) + ylab("Value")
      
  # Second plot
  # This plot is for the mean value
  data_mean <- structure(list(seq_length = key_list, perfect = mean_dict[["perfect"]], alright = mean_dict[["alright"]],
                          whatever = mean_dict[["whatever"]], perfect_std = mean_std_dict[["perfect"]],
                          alright_std = mean_std_dict[["alright"]], whatever_std = mean_std_dict[["whatever"]]), 
                     .Names = c("seq_length","perfect","alright","whatever", "perfect_std", "alright_std", "whatever_std"), 
                     class = "data.frame", row.names =  c(NA, -15L))
  p2 <- ggplot(data_mean, aes(x=seq_length)) + geom_line(aes(y = perfect, colour = "perfect")) + 
    geom_ribbon(aes(ymin = perfect - perfect_std, ymax = perfect + perfect_std, colour = "perfect"), alpha = 0.3) + 
    geom_line(aes(y = alright, colour = "alright")) +
    geom_ribbon(aes(ymin = alright - alright_std, ymax = alright + alright_std, colour = "alright"), alpha = 0.3) +
    geom_line(aes(y = whatever, colour = "whatever")) + 
    geom_ribbon(aes(ymin = whatever - whatever_std, ymax = whatever + whatever_std, colour = "whatever"), alpha = 0.3) +
    geom_hline(yintercept=name_dict[[draw]]) + 
    labs(title = glue("Mean value Comparasion for beta{draw} with beta values {beta1}, {beta2}"), ylab = "Value") + 
    ylab("Value")
      
  # Third plot
  # This plot is for MSE
  data_mse <- structure(list(seq_length = key_list, perfect = mse_dict[["perfect"]], alright = mse_dict[["alright"]],
                            whatever = mse_dict[["whatever"]]), 
                       .Names = c("seq_length","perfect","alright","whatever"), class = "data.frame", row.names =  c(NA, -15L))
  p3 <- ggplot(data_mse, aes(x=seq_length)) + geom_line(aes(y = perfect, colour = "perfect")) + 
    geom_line(aes(y = alright, colour = "alright")) + geom_line(aes(y = whatever, colour = "whatever")) +
    labs(title = glue("MSE Comparasion for beta{draw} with beta values {beta1}, {beta2}")) + ylab("Value")
  
  return(list(p1,p2,p3))
}

beta1_list <- c(0.3,0.5,0.8,1,2)
beta2_list <- beta1_list / 2
for (i in 1:length(beta1_list)) {
  for (j in 1:2) {
    l1 <- basic_draw_plot(beta1_list[i],beta2_list[i], j)
    l1[[1]]
    l1[[2]]
    l1[[3]]
  }
}

# For the second order case, i.e., consider column x-2 and possibly other column
# And for the first two elements of the sequence, treat with caution 
design_matrix_2 <- function(full_sequence, product = FALSE) {
  
  # Return a matrix containing treatment like:
  # t   trt   Y_t   trt-1   z_t   z_t-1   z_tz_t-1
  # 1   A     ...   ---     0     ---     -------
  # 2   B     ...   A       1     0       0
  # 3   B     ...   B       1     1       1
  # .....
  # .....
  
  # Here we only consider two treatment types (A and B) and hence we define A as -0.5 and B as 0.5
  
  # So first column represents actual sequence, second column represents the item privous to each item,
  # thid column represents the previous before previous item
  
  # Parameter:
  # ------------------
  # full_seuqnce: the sequence to consider
  # product: whether to consider product of columns or not, default is false
  
  seq_len <- nchar(full_sequence)
  full_sequence_list <- unlist(strsplit(full_sequence, ""))
  dm <- matrix(nrow = seq_len - 2, ncol = 3)
  if (product == TRUE) {
    dm <- matrix(nrow = seq_len - 1, ncol = 4)
  }
  for (i in 1:seq_len) {
    if (i == 1) { # The first element in the sequence
      if (full_sequence_list[[i]] == "A") {
        dm[i, 3] = 0.5
      } else {
        dm[i, 3] = -0.5
      }
    } else if (i == 2) { # The second element in the sequence(no first column)
      if (full_sequence_list[[i]] == "A") {
        dm[i - 1, 2] = 0.5
        dm[i, 3] = 0.5
      } else{
        dm[i - 1, 2] = 0.5
        dm[i, 3] = -0.5
      }
    } else if (i == seq_len - 1) { # The second last element in the sequence (not show in third column)
      if (full_sequence_list[[i]] == "A") {
        dm[i - 2, 1] = 0.5
        dm[i - 1, 2] = 0.5
      } else {
        dm[i - 2, 1] = -0.5
        dm[i - 1, 2] = -0.5 
      }
    } else if (i == seq_len) { # The last element in the sequence
      if (full_sequence_list[[i]] == "A") {
        dm[i - 2, 1] = 0.5
      } else {
        dm[i - 2, 1] = -0.5
      }
    } else { # All the middle elements
      if (full_sequence_list[[i]] == "A") {
        dm[i - 2, 1] = 0.5
        dm[i - 1, 2] = 0.5
        dm[i, 3] = 0.5
      } else {
        dm[i - 2, 1] = -0.5
        dm[i - 1, 2] = -0.5
        dm[i, 3] = -0.5
      }
    }
  }
  
  if (product == TRUE) { # if requires product, create a fourth column by multiplying the first two column
    dm[, 4] = dm[, 1] * dm[, 2]
  }
  
  return(dm)
}


# Calculate y value when given betas and the design matrix
get_y_2 <- function(beta1, beta2, beta3, design_matrix, err_std = 1, beta4 = 0) {
  
  # This function calculates y for second order, beta1, beta2, beta3 should all be given, if product is
  # considered, beta4 should also be given, otherwise, it will be set default as 0
  
  # y_t = beta1 * z_t + beta2 * z_t-1 + beta3 * z_t - 2 + err + (optional)beta4 * (z_tz_t-1)
  
  # Parameters:
  # -------------------
  # beta1: parameter corresponding with current item
  # beta2: parameter corresponding with immediately previous item
  # beta3: parameter corresponding with the second previous item
  # beta4: parameter corresponding with the product of current item and previous item, optinal parameter,
  # default is 0
  # design_matrix: the matrix calculated by the design matrix function
  # err_std: error term's standard deviation, default is 1. (error term is draw from a normal distribution
  #          with mean 0 and std the given value or 1 by default)
  
  m <- dim(design_matrix)[[1]] # row length
  n <- dim(design_matrix)[[2]] # column length
  y <- vector(mode = "double", length = m)
  for (i in 1:m) {
    err <- rnorm(1, 0, err_std)
    if (n == 3) {
      y[i] <- beta1 * design_matrix[i, 1] + beta2 * design_matrix[i, 2] + beta3 * design_matrix[i, 3] + err
    } else {
      y[i] = beta1 * design_matrix[i, 1] + beta2 * design_matrix[i, 2] + beta3 * design_matrix[i, 3] + err + 
        beta4 * design_matrix[i, 4]
    }
  }
  
  return(y)
}


# Return predicted beta values in a dictionary (keys are different sequence lengths)
experiment_2 <- function(beta1, beta2, beta3, quality, product = FALSE, err_std = 1, beta4 = 0, exp_size = 1000) {
  
  # Run an experiment and return dictionary containing beta values
  
  # Parameters:
  # -------------------
  # quality: state what quality do you want for the experiment, "perfect" means all sample latin square need to
  #          pass the test, "alright" means the latin square samples that don't pass the test, "whatever" means
  #          random sequence, "ABAB" means a sequence containing ABABAB...
  # exp_size: how many samples to draw, default is 1000
  # other parameters similar as in other functions
  
  seq_size_list <- c(24)
  for (i in 1:14) {
    seq_size_list <- append(seq_size_list, 24 + 12 * i)
  }
  
  beta1_dict <- dict()
  beta2_dict <- dict()
  beta3_dict <- dict()
  beta4_dict <- dict()
  
  # Draw sample and calculate standard error of beta
  for (seq_size in seq_size_list) {
    count = 0
    beta1_dict[[seq_size]] <- vector()
    beta2_dict[[seq_size]] <- vector()
    beta3_dict[[seq_size]] <- vector()
    beta4_dict[[seq_size]] <- vector()
    
    while (count < exp_size) {
      result_list <- initiation(2, "second")
      var_dict <- result_list[[1]]
      seq_dict_list <- result_list[[2]]
      seq_dict <- seq_dict_list[[sample(c(1,2,3), 1)]]
      if (!grepl("whatever", quality, fixed = TRUE)) { # if not random case 
        # Use the get_sequence function to get the sequence generated by William's Latin square
        # and also the quality of it
        l1 <- get_sequence(seq_dict, var_dict, seq_size)
        full_seq <- l1[[1]]
        qua <- l1[[2]]
        if (qua == TRUE & grepl("perfect", quality, fixed = TRUE)) {
          dm <- design_matrix_2(full_seq, product = product) # design matrix
          y <- get_y_2(beta1, beta2, beta3, dm, err_std = err_std, beta4 = beta4)
          # Solve the linear equation and store the beta values
          if (product == FALSE) {
            fit <- lm(y ~ dm[,1] + dm[,2] + dm[,3] + 0)
            beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
            beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
            beta3_dict[[seq_size]] <- append(beta3_dict[[seq_size]], fit$coefficients[[3]])
          } else {
            fit <- lm(y ~ dm[,1] + dm[,2] + dm[,3] + dm[,4] + 0)
            beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
            beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
            beta3_dict[[seq_size]] <- append(beta3_dict[[seq_size]], fit$coefficients[[3]])
            beta4_dict[[seq_size]] <- append(beta4_dict[[seq_size]], fit$coefficients[[4]])
          }
          count <- count + 1
        } else if (qua == FALSE & grepl("alright", quality, fixed = TRUE)) {
          dm <- design_matrix_2(full_seq, product = product) # design matrix
          y <- get_y_2(beta1, beta2, beta3, dm, err_std = err_std, beta4 = beta4)
          # Solve the linear equation and store the beta values
          if (product == FALSE) {
            fit <- lm(y ~ dm[,1] + dm[,2] + dm[,3] + 0)
            beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
            beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
            beta3_dict[[seq_size]] <- append(beta3_dict[[seq_size]], fit$coefficients[[3]])
          } else {
            fit <- lm(y ~ dm[,1] + dm[,2] + dm[,3] + dm[,4] + 0)
            beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
            beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
            beta3_dict[[seq_size]] <- append(beta3_dict[[seq_size]], fit$coefficients[[3]])
            beta4_dict[[seq_size]] <- append(beta4_dict[[seq_size]], fit$coefficients[[4]])
          }
          count <- count + 1
        }
      } else { # All random case
        sequence <- random_sequence(2, seq_size)
        dm <- design_matrix_2(sequence, product = product) # design matrix
        y <- get_y_2(beta1, beta2, beta3, dm, err_std = err_std, beta4 = beta4)
        # Solve the linear equation and store the beta values
        if (product == FALSE) {
          fit <- lm(y ~ dm[,1] + dm[,2] + dm[,3] + 0)
          beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
          beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
          beta3_dict[[seq_size]] <- append(beta3_dict[[seq_size]], fit$coefficients[[3]])
        } else {
          fit <- lm(y ~ dm[,1] + dm[,2] + dm[,3] + dm[,4] + 0)
          beta1_dict[[seq_size]] <- append(beta1_dict[[seq_size]], fit$coefficients[[1]])
          beta2_dict[[seq_size]] <- append(beta2_dict[[seq_size]], fit$coefficients[[2]])
          beta3_dict[[seq_size]] <- append(beta3_dict[[seq_size]], fit$coefficients[[3]])
          beta4_dict[[seq_size]] <- append(beta4_dict[[seq_size]], fit$coefficients[[4]])
        }
        count <- count + 1
      }
    }
  }
  return(list(beta1_dict, beta2_dict, beta3_dict, beta4_dict))
}


# Plot for the second order case
draw_plot_2 <- function(beta1,beta2, beta3, draw, product, err_std = 1, beta4 = 0, exp_size = 1000) {
  
  # Draw 3 plots:
  # 1. for standard error of betas
  # 2. mean value of beta hat and std
  # 3. MSE of beta hat
  
  # Parameters:
  # -------------------
  # draw: which beta to draw, give 1 or 2 or 3 or 4, (if 4, product must be true)
  # parameters similar as the above function
  
  name_dict <- dict(init_keys = c(1,2,3,4), init_values = list(beta1, beta2, beta3, beta4))
  quality_list <- c("perfect", "alright", "whatever")
  
  mean_dict <- dict()
  
  se_dict <- dict()
  
  mse_dict <- dict()
  
  mean_std_dict <- dict()
  
  for (qu in quality_list) {
    mean_dict[[qu]] <- vector()
    se_dict[[qu]] <- vector()
    mse_dict[[qu]] <- vector()
    
    beta_dict_list <- experiment_2(beta1, beta2, beta3, qu, product = product, 
                                   err_std = err_std, beta4 = beta4, exp_size = exp_size)
    if (draw == 1) { # plot beta1
      beta_to_draw <- beta_dict_list[[1]]
    } else if (draw == 2) { # plot beta2
      beta_to_draw <- beta_dict_list[[2]]
    } else if (draw == 3) { # plot beta3
      beta_to_draw <- beta_dict_list[[3]]
    } else if (draw == 4) { # plot beta4
      beta_to_draw <- beta_dict_list[[4]]
    }
    
    for (key in beta_to_draw$keys()) {
      mean_dict[[qu]] <- append(mean_dict[[qu]], mean(beta_to_draw[[key]]))
      se_dict[[qu]] <- append(se_dict[[qu]], sd(beta_to_draw[[key]]))
      mse_dict[[qu]] <- append(mse_dict[[qu]], MSE(beta_to_draw[[key]], name_dict[[draw]]))
    }
    
    mean_std_dict[[qu]] <- se_dict[[qu]] / sqrt(exp_size)
  }
  
  # If want to manually add plot, uncomment below
  return(list(mean_dict, se_dict, mse_dict, mean_std_dict))
}
  
  
  # Actual plotting
  # First plot (this plot is for standard error)
  key_list <- beta_to_draw$keys()
  data_se <- structure(list(seq_length = key_list, perfect = se_dict[["perfect"]], alright = se_dict[["alright"]],
                            whatever = se_dict[["whatever"]]), 
                       .Names = c("seq_length", "perfect","alright","whatever"), class = "data.frame", row.names =  c(NA, -15L))
  p1 <- ggplot(data = data_se, aes(x=seq_length)) + geom_line(aes(y = perfect, colour = "perfect")) + 
    geom_line(aes(y = alright, colour = "alright")) + geom_line(aes(y = whatever, colour = "whatever")) +
    labs(title = glue("Standard error Comparasion for beta{draw} with beta values {beta1}, {beta2}, {beta3}, {beta4}")) + ylab("Value")
  
  # Second plot
  # This plot is for the mean value
  data_mean <- structure(list(seq_length = key_list, perfect = mean_dict[["perfect"]], alright = mean_dict[["alright"]],
                              whatever = mean_dict[["whatever"]], perfect_std = mean_std_dict[["perfect"]],
                              alright_std = mean_std_dict[["alright"]], whatever_std = mean_std_dict[["whatever"]]), 
                         .Names = c("seq_length","perfect","alright","whatever", "perfect_std", "alright_std", "whatever_std"), 
                         class = "data.frame", row.names =  c(NA, -15L))
  p2 <- ggplot(data_mean, aes(x=seq_length)) + geom_line(aes(y = perfect, colour = "perfect")) + 
    geom_ribbon(aes(ymin = perfect - perfect_std, ymax = perfect + perfect_std, colour = "perfect"), alpha = 0.3) + 
    geom_line(aes(y = alright, colour = "alright")) +
    geom_ribbon(aes(ymin = alright - alright_std, ymax = alright + alright_std, colour = "alright"), alpha = 0.3) +
    geom_line(aes(y = whatever, colour = "whatever")) + 
    geom_ribbon(aes(ymin = whatever - whatever_std, ymax = whatever + whatever_std, colour = "whatever"), alpha = 0.3) +
    geom_hline(yintercept=name_dict[[draw]]) + 
    labs(title = glue("Mean value Comparasion for beta{draw} with beta values {beta1}, {beta2}, {beta3}, {beta4}"), ylab = "Value") + 
    ylab("Value")
  
  # Third plot
  # This plot is for MSE
  data_mse <- structure(list(seq_length = key_list, perfect = mse_dict[["perfect"]], alright = mse_dict[["alright"]],
                             whatever = mse_dict[["whatever"]]), 
                        .Names = c("seq_length","perfect","alright","whatever"), class = "data.frame", row.names =  c(NA, -15L))
  p3 <- ggplot(data_mse, aes(x=seq_length)) + geom_line(aes(y = perfect, colour = "perfect")) + 
    geom_line(aes(y = alright, colour = "alright")) + geom_line(aes(y = whatever, colour = "whatever")) +
    labs(title = glue("MSE Comparasion for beta{draw} with beta values {beta1}, {beta2}, {beta3}, {beta4}")) + ylab("Value")
  
  return(list(p1,p2,p3))
}