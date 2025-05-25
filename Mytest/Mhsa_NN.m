clc;
close all;
clear all;

M=20;
N=10;
alpha=[2 5 1 7	12 17 6 5 4 10 ];
sn=500;
%  a sample for virtual machine placement
% M= the maximum of P-machines
% N=the number of V-machines
% alpha = a sample for desire V-machine placement


tic
    data=MAHSA_NN_Project(alpha(1:N),M,sn);
toc

n=size(data,1);

n1=2*N+2;
n2=19;
n3=18;
n4=1;
% number of hidden layers and neurons

rate_train=0.75;
num_of_train=round(n*rate_train);
num_of_test=n-num_of_train;

data_train=data(1:num_of_train,:);
data_test=data(num_of_train+1:n,:);
% selecting 75 percent of data for training a NN
% selecting 25 percent of data for testing a NN

h=1;l=-1;
w1=unifrnd(l,h,[n2 n1]);
net1=zeros(n2,1);
o1=zeros(n2,1);


w2=unifrnd(l,h,[n3 n2]);
net2=zeros(n3,1);
o2=zeros(n3,1);

w3=unifrnd(l,h,[n4 n3]);
net3=zeros(n4,1);
o3=zeros(n4,1);
 % define bias, weight and output for each net
 
max_epoch=600;
eta=0.01;
% define the number of iteration

error_all=zeros(max_epoch,1);
error_all_test=zeros(max_epoch,1);
for i=1:max_epoch
    for j=1:num_of_train
        input=data_train(j,1:n1);
        target=data_train(j,n1+1);
        net1=w1*input';
         o1=logsig(net1);
%                 o1=tanh(net1);
% calculating output of a net using logsig function and train a net by
% 75percent of data

        net2=w2*o1;
     o2=logsig(net2);
%                  o2=tanh(net2);

        net3=w3*o2;
        o3=net3;
        error=target-o3;
%        calculating output of a net using logsig function

        w1=w1-eta*error*-1*1*(w3*(o2*(1-o2)')*w2*(o1*(1-o1)'))'*input;
        w2=w2-eta*error*-1*1*(w3*(o2*(1-o2)'))'*o1';
        w3=w3-eta*error*-1*1*o2';  
        
        
    end
%     updating weights for network,using outputs of network
    
    o3_train=zeros(num_of_train,1);
    o3_test=zeros(num_of_test,1);
    error_train=zeros(num_of_train,1);
    for j=1:num_of_train
        input=data_train(j,1:n1); 
        target=data_train(j,n1+1);
        net1=w1*input'; 
         o1=logsig(net1);
%         o1=tanh(net1);
        
        net2=w2*o1;
         o2=logsig(net2);
%         o2=tanh(net2);
        net3=w3*o2;
        o3=net3;
        o3_train(j)=o3;
        error_train(j)=target-o3;
    end
    error_all(i)=mse(error_train);
%     figure(1); 
% %     subplot(1,2,1),semilogy(error_all(1:i));
%     hold on;
    
    error_test=zeros(num_of_test,1);
    for k=1:num_of_test
        input=data_test(k,1:n1); 
        target=data_test(k,n1+1);
        net1=w1*input'; 
         o1=logsig(net1);
%                  o1=tanh(net1);

        net2=w2*o1;
         o2=logsig(net2);
%         o2=tanh(net2);

        net3=w3*o2;
        o3=net3;
        o3_test(k)=o3;
        
        error_test(k)=target-o3;
    end
    error_all_test(i)=mse(error_test);
%     subplot(1,2,2),semilogy(error_all_test(1:i));
%     hold on;
    
%     figure(2);
%     plotregression(data_train(:,n1+1),o3_train);
%     hold on;



end
% % %  this part is similar to previous part( training a NN)
% testing a neural network by using 25 percent of data ,updating weights
% and calulate outputs of each network


figure(1); 
subplot(1,2,1),semilogy(error_all(1:i));
subplot(1,2,2),semilogy(error_all_test(1:i));

figure(2);
plotregression(data_train(:,n1+1),o3_train);

figure(3);
plotregression(data_test(:,n1+1),o3_test);

%--------------------
figure(4);
subplot(1,2,1), plot(data_train(1:num_of_train,n1+1)); hold on;
plot(o3_train,'r'); hold on;

subplot(1,2,2), plot(data_test(1:num_of_test,n1+1)); hold on;
plot(o3_test,'r'); hold on;

AVR_MSE_Train=sum(error_all)/length(error_all)
AVR_MSE_Test=sum(error_all_test)/length(error_all_test)
