%Visualisation
load('classification.mat');
plot(X(:,1).*y,X(:,2).*y,'x');
hold on
plot(X(:,1).*(1-y),X(:,2).*(1-y),'o');
hold off
%split
I=ones(1000,1);
Xn=[I,X];
X_training=Xn((1: length(X)*0.7),:);
X_test=Xn(( length(X)*0.7+1:1000),:);
y_training=y((1: length(X)*0.7),:);
y_test=y(( length(X)*0.7+1:1000),:);

%/select=randperm(size(Xn,1))%randomly select the row of data
%/X_training=X(select(1:length(select)*0.7),:); %allocated the selected row's data to the training data
%/X_test=X(select((length(select)*0.7+1):length(select)),:);

%logistic classification
beta=zeros(1,3);
learningrate=0.0002;
sig=@(beta,X)1./(1+exp(-beta*X')');
a=[];
n=[];
beta1=zeros(1,3);
likelihood=[];
for i=1:700,
beta=beta+(learningrate*(y_training-sig(beta,X_training)))'*X_training;
loglikelihood=y_training'*log(sig(beta,X_training))+(1-y_training)'*log(sig(-beta,X_training));
a(i,1)=loglikelihood;
beta1=beta1+(learningrate*(y_test-sig(beta1,X_test)))'*X_test;
loglikelihood1=y_test'*log(sig(beta1,X_test))+(1-y_test)'*log(sig(-beta1,X_test));
n(i,1)=loglikelihood1;


end;
fprintf('[beta %3.2f %3.2f %3.2f]',beta);

figure
plot(a,'b');
xlabel('Training times');
ylabel('Log-likelihood');
hold on 
plot(n,'r');
likelihood=0;
likelihood_t=0;
for i=1:700
likelihood=likelihood+(sig(beta,X_training(i,:))*y_training(i))+(sig(-beta,X_training(i,:))*(1-y_training(i)));

end;
for i=1:300
    likelihood_t=likelihood_t+(sig(beta1,X_test(i,:))*y_test(i))+(sig(-beta1,X_test(i,:))*(1-y_test(i)));
end;
li=likelihood/700;
li_t=likelihood_t/300
%e
M=50;
Xi=linspace(-3,3,M);
Xt=repmat(Xi,M,1);
yi=linspace(-3,3,M);
yt=repmat(yi',1,M);
W=beta(2).*Xt+beta(3).*yt
Z=1./(1+exp(-W));
figure
contourf(Xt,yt,Z);
colormap gray;
axis equal;
hold on;
plot([0 beta(1)],[0 beta(2)],'Color',[0.5 0 0.5],'LineWidth',5);
plot(X(:,1).*y,X(:,2).*y,'x');
hold on
plot(X(:,1).*(1-y),X(:,2).*(1-y),'o');
hold off
axis([-3 3 -3 3]);

%f
t=1/2;
ypre=sig(beta,X_test)>t;
c11=sum(ypre&y_test)/sum(y_test==1);
c10=sum(ypre&~y_test)/sum(y_test==0);
c00=sum(~ypre&~y_test)/sum(y_test==0); 
c01=sum(~ypre&y_test)/sum(y_test==1);

confusion=[c00 c10;c01 c11];
%g
ypp=[];
yp=sig(beta,X_test);
tt=[0:1/299:1];
cn11=[];
cn10=[];
cn00=[];
cn01=[];


for i=1:300;
  tt = (i-1) / 300;
  ypp=yp>tt;
  cn11(i)=sum(ypp&y_test)/sum(y_test==1);
  cn10(i)=sum(ypp&~y_test)/sum(y_test==0);
  cn00(i)=sum(~ypp&~y_test)/sum(y_test==0);
  cn01(i)=sum(~ypp&y_test)/sum(y_test==1);

end; 

auc1=abs(trapz(cn10,cn11));


 figure
 hold on;
plot([0 1],[0 1],'r');
hold on 
plot([0 0],[0 1],'g');
hold on
plot([0 1],[1 1],'g');
hold on
plot(cn10,cn11,'b');
xlabel('False Positive Rate');
ylabel('True Positive Rate');

%h


bt=zeros(1,701);
l=1;
Q=ones(700,1);
Q1=ones(300,1);
for i=1:700
 for A=1:700
X_rbf(i,A)=exp((-1/(2*l^2))*(...
    (X_training(i,2)-X_training(A,2))^2 ...
    +(X_training(i,3)-X_training(A,3))^2));
 end
end;
for i=1:300
 for A=1:300
X_rbf1(i,A)=exp((-1/(2*l^2))*(...
    (X_test(i,2)-X_training(A,2))^2 ...
    +(X_test(i,3)-X_training(A,3))^2));
 end
end;

bt=zeros(1,701);
bt1=zeros(1,301);
X_a=[Q,X_rbf];
X_a1=[Q1,X_rbf1];
lr=0.0002;
a=[];
n=[];
for j=1:6000
 
 bt=bt+(lr*(y_training-sig(bt,X_a)))'*X_a;
loglikelihood=y_training'*log(sig(bt,X_a))+(1-y_training)'*log(sig(-bt,X_a));
a(j,1)=loglikelihood;
bt1=bt1+(lr*(y_test-sig(bt1,X_a1)))'*X_a1;
loglikelihood1=y_test'*log(sig(bt1,X_a1))+(1-y_test)'*log(sig(-bt1,X_a1));
n(j,1)=loglikelihood1;
end;
figure
plot(a);
hold on
plot(n);
likelihood_n=0;
likelihood_nt=0;
for i=1:700
likelihood_n=likelihood_n+(sig(bt,X_a(i,:))*y_training(i))+(sig(-bt,X_a(i,:))*(1-y_training(i)));

end;
for i=1:300
    likelihood_nt=likelihood_nt+(sig(bt1,X_a1(i,:))*y_test(i))+(sig(-bt1,X_a1(i,:))*(1-y_test(i)));
end;
li_n=likelihood_n/700;
li_nt=likelihood_nt/300

%i)
Q1=ones(300,1);
for i=1:300
 for A=1:700
X_trbf(i,A)=exp((-1/(2*l^2))*((X_test(i,2)-X_training(A,2))^2+(X_test(i,3)-X_training(A,3))^2));

 
end;

end;
X_t=[Q1,X_trbf];

t=1/2;
ypre_n=sig(bt,X_t)>t;
c11_n=sum(ypre_n&y_test)/sum(y_test==1);
c10_n=sum(ypre_n&~y_test)/sum(y_test==0);
c00_n=sum(~ypre_n&~y_test)/sum(y_test==0); 
c01_n=sum(~ypre_n&y_test)/sum(y_test==1);
confusion_n=[c00_n c10_n;c01_n c11_n];

ypp_n=[];
yp_n=sig(bt,X_t);

cn11_n=[];
cn10_n=[];
cn00_n=[];
cn01_n=[];

for i=1:300;
  tt_n = (i-1) / 300;
  ypp_n=yp_n>tt_n;
  cn11_n(i)=sum(ypp_n&y_test)/sum(y_test==1);
  cn10_n(i)=sum(ypp_n&~y_test)/sum(y_test==0);
  cn00_n(i)=sum(~ypp_n&~y_test)/sum(y_test==0);
  cn01_n(i)=sum(~ypp_n&y_test)/sum(y_test==1);
    
end; 
auc2=abs(trapz(cn10_n,cn11_n));

figure
plot(cn10_n,cn11_n,'b');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
%j)
btt=zeros(1,701);

for k=1:700
 bt_m=btt(k)^2;
 
posterior=y_training'*log(sig(btt,X_a))+(1-y_training)'*log(sig(-btt,X_a))-1/2*(bt_m);
gradient=(y_training-sig(btt,X_a))'*X_a-btt(k);
btt=btt+lr*gradient;

a(k,1)=posterior;
end;
bttt=zeros(1,301);
for j=1:300
     bt_mm=bttt(j)^2;
 
posterior1=y_test'*log(sig(bttt,X_a1))+(1-y_test)'*log(sig(-bttt,X_a1))-1/2*(bt_mm);
gradient1=(y_test-sig(bttt,X_a1))'*X_a1-bttt(j);
bttt=bttt+lr*gradient1;

b(j,1)=posterior1;
end;

figure
plot(a);
likelihood_nnn=0;
likelihood_nnt=0;
for i=1:700
likelihood_nnn=likelihood_nnn+(sig(btt,X_a(i,:))*y_training(i))+(sig(-bt,X_a(i,:))*(1-y_training(i)));

end;
for i=1:300
    likelihood_nnt=likelihood_nnt+(sig(bttt,X_a1(i,:))*y_test(i))+(sig(-bttt,X_a1(i,:))*(1-y_test(i)));
end;
li_nn=likelihood_nnn/700;
li_nnt=likelihood_nnt/300

t=1/2;
ypre_nn=sig(btt,X_t)>t;
c11_nn=sum(ypre_nn&y_test)/sum(y_test==1);
c10_nn=sum(ypre_nn&~y_test)/sum(y_test==0);
c00_nn=sum(~ypre_nn&~y_test)/sum(y_test==0); 
c01_nn=sum(~ypre_nn&y_test)/sum(y_test==1);
confusion_nn=[c00_nn c10_nn;c01_nn c11_nn];

ypp_nn=[];
yp_nn=sig(btt,X_t);

cn11_nn=[];
cn10_nn=[];
cn00_nn=[];
cn01_nn=[];

for i=1:300;
  tt_n = (i-1) / 300;
  ypp_nn=yp_nn>tt_n;
  cn11_nn(i)=sum(ypp_nn&y_test)/sum(y_test==1);
  cn10_nn(i)=sum(ypp_nn&~y_test)/sum(y_test==0);
  cn00_nn(i)=sum(~ypp_nn&~y_test)/sum(y_test==0);
  cn01_nn(i)=sum(~ypp_nn&y_test)/sum(y_test==1);
    
end; 
auc3=abs(trapz(cn10_nn,cn11_nn));
figure
plot(cn10_nn,cn11_nn,'b');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title('Receiver Operator Characteristic, Auc=0.6653,l=0.01')