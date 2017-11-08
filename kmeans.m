% "artificial" data 
% rand('state',1);
load iris.data;
[N D]=size(iris);
x=iris+rand(N,D)*0.1-0.05;
x=[x(:,2:3); x(:,[1 4])];
[N D]=size(x);

clf;
figure(1);
colormap jet;
plot(x(:,1),x(:,2),'b.','MarkerSize',20,'LineWidth',2); 
axis([1 9 0 8]);
axis 'square';
set(gca,'FontSize',18);

% demo K-means initialize
K=input('How many clusters? K = ')
inittype=input(['Initialization? [1 = rand data, 2 = random loc, 3=' ...
      ' rand assign] :']);
M=zeros(K,D);
switch inittype,      
  case 1,
    % initialization 1:
    tmp=randperm(N); 
    M=x(tmp(1:K),:);
  case 2,
    % initialization 2:
    M=2+rand(K,D)*3; 
  case 3,
    % initialization 3:
    z=ceil(rand(N,1)*K);
    for k=1:K,
      M(k,:)=mean(x(z==k,:),1);
    end;
end;

iters=100;

z=ones(N,1);
cc=colormap;
col=cc(1:floor(64/K):64,:);

for i=1:iters,
  % find closest points
  % assignment matrix
  zold=z;
  for j=1:N, % slow way to implement this, can be done faster by vectorizing
    d=M-repmat(x(j,:),K,1);
    d=sum(d.^2,2);
    [ii,z(j)]=min(d);
  end;
  if all(z==zold),
    disp('Converged');
    break;
  end;
  % plotting
  clf;
  title('K-Means Algorithm');
  for k=1:K,
    plot(x(z==k,1),x(z==k,2),'.','Color',col(k,:),...
	'MarkerSize',20,'LineWidth',2);  
    hold on;
    plot(M(k,1),M(k,2),'x','Color',0.6*col(k,:),...
	'MarkerSize',15,'LineWidth',3);
  end;
  axis([1 9 0 8]);
  axis 'square';
  pause;
  for k=1:K,
    if any(z==k),
      M(k,:)=mean(x(z==k,:),1);
    end;
  end;

end;

% print -depsc irisclust.eps
% !epstopdf irisclust.eps

