function data=MAHSA_NN_project(alpha,M,SearchAgents_no)
%alpha=[2	5	1	7	12 17 6 5 4 10 3 7];
%M=20;
 N=length(alpha);    
%  N= number of virtual machines
%SearchAgents_no=1000;

x=zeros(SearchAgents_no,N);
x(1:SearchAgents_no-1,:)=generate(SearchAgents_no-1,M,N);
x(SearchAgents_no,:)=alpha;
% making samples for virtual machine placements

y=zeros(SearchAgents_no,1);
data=zeros(SearchAgents_no,2*N+3);
data(:,N+1:2*N)=x;
% y= the quantity of virtual machine placement in compare of alpha
% data = the plecement of y in table 

for i=1:SearchAgents_no
    %%y(i)=similarity(alpha, x(i,:),M);
    y(i)=similarity2(alpha, x(i,:),M,N);
    data(i,end-2)=M;
    data(i,end-1)=N;
    data(i,1:N)=alpha;
%     calculating the similarity between final output and desire input
%     put M,N,alpha in the proper place in table
end

%f=find(y>0.7);
data(:,end)=y;
plot(y);
disp('end');
end
% show the final output for virtual machine placement

%%
function y=single_sim(alpha, x,M)
    y=1- (abs(alpha-x)/M);
end


%%
function y=similarity(alpha, x,M)
    t=(abs(alpha-x)/M);
    c= 1 - t;
    y=sum(c)/length(c);
    
%   calculating the output (y = the quantity of virtual machine placement
% in compare of desire input
end
%  this function calculating the correlation between
% the best virtual machine palcement and minimum and maximum amount of the
% correlation that they are not suitable for virtual machine placement
% this functinon find the  v-machine placement and omiting the worse cases
% put them equal to zero

function y=similarity2(alpha, x,M,N)
    cr=xcorr(alpha);
    [m0,n0]=max(cr);
    
     
    crx=xcorr(alpha,x);
    [m1,n1]=max(crx);
    
    %%max  wolf
    MaxX(1:N)=M;
    crMax=xcorr(alpha,MaxX);
    mMax=max(crMax);
    
    %%min  wolf
    MinX(1:N)=1;
    crMin=xcorr(alpha,MinX);
    mMin=max(crMin);
    
    lmin=min(abs(m0-mMax),abs(m0-mMin));
    
    nsp= 1 -(abs(n0-n1)/n0); %n similarity %
    msp= 1 -(abs(m0-m1)/lmin); %m similarity %
    
    if(msp<0)
        msp=0;
    end
    
    y=0.7*msp+0.3*nsp;
end
%%
function x=generate(SearchAgents_no, M, N)
    x=floor(rand(SearchAgents_no,N).*M)+1;
end
%%