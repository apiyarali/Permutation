#This should work for any set of characters
library(stringr)

Perm.apply <- function(x,perm){
  #If x is not in the permutation, nothing happens
  if (!str_detect(perm,x))
    return(x)
  #Otherwise locate it and find the next symbol
  pos <- str_locate(perm,x)[1,1]   #first component of first vector
  #To extract a character, we get a one-character substring
  nextch <- str_sub(perm,pos+1,pos+1)
  #If it's numeric, we are done
  if (nextch != ")")
    return(nextch)
  #Otherwise back up to find the number at the start of the cycle
  while(str_sub(perm,pos-1,pos-1) != "(")
    pos <- pos-1
  return (str_sub(perm,pos,pos))
}
# Perm.apply("6",("(18)(246)"))
# Perm.apply("8","(7128)")


#Converts a vector of function values to cycle notation
#This is specific to permutations of the digits 1 through 9
#It will be reused in other apps
Perm.cycle.convert <- function(fval){
#We build the answer as a vector of characters
  cycles <- character(0)  #empty vector
  for (nextstart in c("1","2","3","4","5","6","7","8")) {
    m <- as.numeric(nextstart)  #convert to integer index
    if (m > length(fval)) break
    #If the symbol is unchanged or is already in a cycle, there is nothing to do
    if ((fval[m] == nextstart) || (nextstart %in% cycles)) next
    #Otherwise keep tracing through the cycle until we find the end
    nextch <- fval[m]
    cycles <- c(cycles,"(",nextstart,nextch) #start a new cycle
    nextch <- fval[as.numeric(nextch)]
    while (nextch != nextstart){
      cycles <- c(cycles,nextch)
      nextch <- fval[as.numeric(nextch)]
    }
    cycles <- c(cycles, ")")   #close the cycle
  }
  #Collapse the vector of cycles into a string    
  return(paste(cycles, collapse=""))

}
#Perm.cycle.convert(c("3","4","1","5","6","2"))

#Compute the product ab of two permutations of the symbols "1" through "9"
Perm.multiply <- function(a,b){
  if (a == "I") return(b)
  if (b == "I") return(a)
  #Make a vector of the function values
  fval <- character(0)
  for (i in c("1","2","3","4","5","6","7","8","9")) {
    fval <- c(fval, Perm.apply(Perm.apply(i,b),a) )
  }
  #If input and output are equal we have the identity
  if (sum(fval != "1":"9") == 0) return("I")
  #Otherwise generate cycle notation
  return(Perm.cycle.convert(fval))
}
#Perm.multiply("(1246)","(136)(45)")
#This vectorizes version will create a group multiplication table
vPerm.multiply <-   Vectorize(Perm.multiply,c("a","b"))

#Makes a list of powers separated by HTML line breaks
Perm.powerString <- function(perm) {
  power <- perm
  result <- perm
  while (power != "I") {
    power <- Perm.multiply(power,perm)
    result <- paste(result,power,sep = "<br/>")
  }
  return(result)
}

# Perm.inverse2 <- function(perm2){
#   #reverse the group
#   reverse <- paste(c("(", rev(strsplit(str_sub(perm2, 2, str_length(perm2)-1),NULL) [[1]]),")"), collapse='')
#   
#   #lowest number in the group
#   small <- str_sub(paste(str_sort(strsplit(paste(c(rev(strsplit(str_sub(perm2, 2, str_length(perm2)-1),NULL) [[1]])), collapse=''),NULL) [[1]], numeric="TRUE"), collapse=''),1,1)
#   
#   #new reverse vector
#   rv <- character(0)
#   rv <- c(rv, small)
#   x <- small
#   for (i in 1:(str_length(reverse)-3)){
#     y <- Perm.apply(x,reverse)
#     rv <- c(rv, y)
#     x <- y
#   }
#   
#   return(paste(c("(",rv,")"), collapse=''))  
# }

#You will need to write these last two functions.
#Finds the inverse by stopping when the next power is the identity
# Perm.inverse1 <- function(perm) {
#   
#   if (str_count(perm,"\\)") > 1){
#     c <- str_locate(perm,"\\)")
#     c1 <- str_sub(perm,1,c[1])
#     c2 <- str_sub(perm, c[1]+1)
#     d1 <- Perm.inverse2(c1)
#     d2 <- Perm.inverse2(c2)
#     return (paste(c(d1,d2), collapse=''))
#   } else {
#     return (Perm.inverse2(perm))
#   } 
# }
# 
Perm.inverse <- function(perm) {
  power <- value <- perm
  while (power != "I") {
    value <- power
    power <- Perm.multiply(power,perm)
  }
  value
}

# Perm.inverse("(123)(4689)")
# Perm.inverse("(123)")
# Perm.inverse("(2143)")
# Perm.inverse("(2346)")
# Perm.inverse("(12)")

#Forms the conjugate aba^(-1) or bab^(-1)
Perm.conjugate <- function(a,b) {
  
  if (a == "I") return(b)
  if (b == "I") return(a)  
  
  if (str_count(a,"\\)") > 1){
    a1 <- str_locate(a,"\\)")
    a2 <- str_sub(a,1,a1[1])
    a3 <- str_sub(a, a1[1]+1)
    a4 <- Perm.multiply(a2, a3)
  } else {
    a4 <- a
  }
  
  if (str_count(b,"\\)") > 1){
    b1 <- str_locate(b,"\\)")
    b2 <- str_sub(b,1,b1[1])
    b3 <- str_sub(b, b1[1]+1)
    b4 <- Perm.multiply(b2, b3)
  } else {
    b4 <- b
  }
  
  # binv <- Perm.inverse(b4)
  
  # bainv <- Perm.multiply(b4,Perm.inverse(a4))
  # abinv <- Perm.multiply(a4, binv)
  
  c <- Perm.multiply(a4, Perm.multiply(b4,Perm.inverse(a4)))
  # babcong <- Perm.multiply(b4, abinv)
  
  return(c)
  
}

# Perm.conjugate1 <- function(a,b){
#   if (a == "I") return(b)
#   if (b == "I") return(a)    
# }

# Perm.conjugate("(24)(567)","(123)(4689)")

# Perm.conjugate(inputa,inputb)
# Perm.conjugate("(24)(567)","(123)(56)")
# Perm.conjugate(inputb,inputa)
# Perm.conjugate("(123)(56)","(24)(567)")

# Perm.conjugate("(24)","(123)")
# Perm.conjugate("(123)","(24)")


