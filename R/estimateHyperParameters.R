##estimate hyperparameters...

##make sure datatransform function does preserves orders of X's, this way the order has only be computed once.
estimateHyperParameters=function(X, Y, paramLower=0,paramUpper=1,datatransform=NULL,nParams=0,it = 100,tol=0.001,k=1){
  # Make sure A and B are matrices.
  if ( ( ! is.matrix(X) ) || ( ! is.matrix(Y) ) ) {
    print("estimateHyperParameters(): input X and Y must be matrices!")
    return(NaN);
  }
  
  GP = NULL  
  dhfc = function(p){
    P = length(p)
    
    if(!is.null(datatransform) ){
      X_trans = datatransform(X,p[2:P])
      if(is.null(GP)){
        ret = gpHist(X_trans ,Y,p[1],k=k);
      }else{
     #   ret = gpHist(X_trans ,Y,p[1],orders=GP$orders ,alphas = GP$alpha);
        ret = gpHist(X_trans ,Y,p[1],orders=GP$orders,k=k);
      }
    }else{
      if(is.null(GP)){
        ret = gpHist(X ,Y,p[1]);
      }else{
        ret = gpHist(X ,Y,p[1],orders=GP$orders);
      #  ret = gpHist(X ,Y,p[1],orders=GP$orders,alphas = GP$alpha);
      }
    }
    GP<<-ret

    ret$logmarginal
  }
  resmat = downhillsimplex(dhfc,nParams+1,lower=paramLower,upper=paramUpper,it = it,tol=tol)
  
}
