responses <- data.frame(
  Subj_01 = c(1,1,1,0,0,1,0,0,0,0,1,1,1,0,0,0,0,1,1,0,0,1,0,1,1,0,1,1,1,1,1,0,1,0,1,1,0,1,0,1),
  Subj_02 = c(0,1,1,0,0,1,0,0,1,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,0,1,1,1,1,1,1,0,0,0,1,0,0,1,0,1),
  Subj_03 = c(0,1,0,0,0,1,0,0,1,1,1,0,1,1,0,0,1,1,1,0,0,0,1,0,0,1,1,1,1,0,1,0,1,0,1,0,0,1,0,0),
  Subj_04 = c(0,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,1,1,0,1,1,0,1,1,0,0,1,0,0)
)

answer <- data.frame(
  c(0,1,1,0,0,1,0,0,1,1,1,0,1,1,0,0,0,1,1,0,0,1,1,0,0,1,1,1,1,0,1,0,0,0,1,0,0,1,0,0)
)

L <- 2
pi_1 <- 0.5
pi_0 <- 1 - pi_1

matchMatrix <- matrix(c(40, 27, 25, 22, 27, 40, 34, 21, 25, 34, 40, 23, 22, 21, 23, 40),
                      nrow = 4)

getMatchMatrix <- function(data){
  n <- length(data)
  matchMatrix <- matrix(0, nrow = n, ncol = n)
  
  for(i in 1:n){
    for(j in 1:n){
      matchMatrix[i, j] <- sum(data[[i]] == data[[j]]) 
    }
  }
  
  return(matchMatrix)
}

matchMatrix <- getMatchMatrix(responses)

propotionMatrix <- matchMatrix / length(responses[[1]])

M <- 2 * propotionMatrix - 1
M

. <- psych::fa(M)
D <- .$loadings %>% as.numeric()

D_correct <- D + (1 - D) / L
D_wrong <- 1 - D_correct 
D_table <- data.frame(D_correct, D_wrong)


getPosterior <- function(data, D_table, threshold){
  m = length(data[[1]]) # number of items
  n = length(data)      # number of informants
  posterior_ifAnswerIs1 <- vector("numeric", m)

  for(k in 1:m){
    # p(x|Z = 1)
    p1 <- 1
    ifAnswerIs1 <- responses[k,] == 1
    for(i in 1:n){
      p1 <- p1 * D_table[i, ifelse(ifAnswerIs1[i] == TRUE, 1, 2)]
    }
    likelihood_ifAnswerIs1 <- p1 * pi_1
    
    # p(x|Z = 0)  
    p0 <- 1
    ifAnswerIs0 <- responses[k,] == 0
    for(i in 1:n){
      p0 <- p0 * D_table[i, ifelse(ifAnswerIs0[i] == TRUE, 1, 2)]
    }
    likelihood_ifAnswerIs0 <- p0 * pi_0
    
    posterior_ifAnswerIs1[k] = likelihood_ifAnswerIs1 / (likelihood_ifAnswerIs0 + likelihood_ifAnswerIs1)
  }
  
  posterior_ifAnswerIs0 <- 1 - posterior_ifAnswerIs1
  inffered_answer <- ifelse(posterior_ifAnswerIs1 >= threshold, TRUE, FALSE)
  posterior_table <- data.frame(posterior_ifAnswerIs1, posterior_ifAnswerIs0, inffered_answer)
  return(posterior_table)
}

posterior_table <- getPosterior(responses, D_table, 0.5)
posterior_table


