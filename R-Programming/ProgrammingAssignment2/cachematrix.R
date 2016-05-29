## Write the following functions:
## makeCacheMatrix: This function creates a special "matrix" object that can cache its inverse.
## cacheSolve: This function computes the inverse of the special "matrix" returned by createCacheMatrix above. If the inverse has already been calculated (and the matrix has not changed), then the cachesolve should retrieve the inverse from the cache.
## Computing the inverse of a square matrix can be done with the solve function in R.

## This function creates a special "matrix" object that can cache its inverse. 'createCacheMatrix'
createCacheMatrix <- function(x = matrix()) {
  inversed <- NULL
  
  set <-function(y) {
    x <<- y
    inversed <<- NULL
  }
  
  retrieve <- function() x
  set_Inversed <- function(new_Inversed) inversed <<- new_Inversed
  retrieve_Inversed <- function() inversed
  list(set = set, retrieve = retrieve, set_Inversed = set_Inversed, retrieve_Inversed = retrieve_Inversed)
}


## This function computes the inverse of the special "matrix" returned by createCacheMatrix above. 
## If the inverse has already been calculated (and the matrix has not changed),
## then the cachesolve should retrieve the inverse from the cache.

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  inversed <- x$retrieve_Inversed()
  
  if(!is.null(inversed)) {
    message("getting cached data")
    return(inversed)
  }
  
  data <- x$retrieve()
  inversed <- solve(data, ...)
  x$set_Inversed(inversed)
  
  inversed
}
