t=1/2;
Ypre=[];
likelihood=sig(beta,X_test);
d1=0;
d2=0;
d3=0;
d4=0;

for o=1:300,
if likelihood(o)<=t
Ypre(o)=0; 
if y_test(o)==0  
        d1=d1+1;
        
    else if  y_test(o)==1
       d2=d2+1;
        end
end
else if likelihood(o)>t
     Ypre(o)=1;
     if y_test(o)==0
         d3=d3+1;
     else if y_test(o)==1
             d4=d4+1;
         end
     end
    end
end
end;

P1=d1/(d1+d3);
P2=d2/(d2+d4);
P3=d3/(d3+d1);
P4=d4/(d2+d4);

C_matrix=[P1 P3;P2 P4];

%g
tt=0:0.01:1;
Yp=[];
ll=sig(beta,X_test);
q1=0;
q2=0;
q3=0;
q4=0;

for x=1:101,
for w=1:300,

if ll(w)<=tt(x)
Yp(w)=0; 
if y_test(w)==0  
        q1=q1+1;
        
    else if  y_test(w)==1
       q2=q2+1;
        end
end
else if ll(w)>tt(x)
     Yp(w)=1;
     if y_test(w)==0
         q3=q3+1;
     else if y_test(w)==1
             q4=q4+1;
         end
     end
    end
end
l1(x)=q1/(q1+q3);
l2(x)=q2/(q2+q4);
l3(x)=q3/(q3+q1);
l4(x)=q4/(q2+q4);
if tt(x)==0
    l3(x)=1;
    l4(x)=1;
end
if tt(x)==1
    l3(x)=0;
    l4(x)=0;
end

end;

end;
figure;
plot(l3,l4);

%h

