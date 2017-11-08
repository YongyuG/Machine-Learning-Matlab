function [a] = loglikelihood(X,y,beta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
a=y'*log(sig(beta*X'))+(1-y)*log(sig(-beta*X'))

end

