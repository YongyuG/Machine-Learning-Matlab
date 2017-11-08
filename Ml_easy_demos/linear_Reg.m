% plot greyscale image with decision boundary and beta vector

beta=[-1 0.5]';

M=50;
x=linspace(-3,3,M);
X=repmat(x,M,1);
y=linspace(-3,3,M);
Y=repmat(y',1,M);

eta=0.2;

xp=[];
xm=[];

for i=1:40,
  clf;
  W=beta(1).*X+beta(2).*Y;
  Z=1./(1+exp(-W));
  contourf(X,Y,Z);
  colormap gray;
  axis equal;
  hold on;
  plot([0 beta(1)],[0 beta(2)],'Color',[0.5 0 0.5],'LineWidth',5);
  axis([-3 3 -3 3]);
  % generate a data point and plot
  y=rand<0.5;
  x=randn(2,1)*0.5;
  x(1)=x(1)+2*(y-0.5);
  if y,
    xp=[xp x];
    plot(x(1),x(2),'r.','MarkerSize',30);
  else
    xm=[xm x];
    plot(x(1),x(2),'b.','MarkerSize',30);
  end;

  % learning rule
  sig=1/(1+exp(-beta'*x));
  beta=beta+eta*(y - sig)*x;
  disp('pause..');
  pause;
end;

clf;
W=beta(1).*X+beta(2).*Y;
Z=1./(1+exp(-W));
contourf(X,Y,Z);
colormap gray;
axis equal;
hold on;
plot([0 beta(1)],[0 beta(2)],'Color',[0.5 0 0.5],'LineWidth',5);
axis([-3 3 -3 3]);

plot(xp(1,:),xp(2,:),'r.','MarkerSize',30);
plot(xm(1,:),xm(2,:),'b.','MarkerSize',30);
