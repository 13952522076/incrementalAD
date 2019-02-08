
clear;clc;
run('../load_data');
clear train_data train_label;
data = test_data;
label = test_label;
clear train_data train_label test_data test_label;

data=mapminmax(data');
data=data';

% Divide into train and test
test_data=data(end-1000+1:end,:);
test_label = label(end-1000+1:end,:);
train_data=data(1:end-1000,:);
train_label = label(1:end-1000,:);
clear data label;

%label(label==-1)=2;
C=0.001;
lr=0.01;
batch_size=200;

%w=rand(size(train_data,2)+1,1);
w= unifrnd(-1,1,size(train_data,2)+1,1);
e_test = ones(size(test_data,1),1);
test_data=[test_data e_test];

pred_label = double(test_data*w>0);
pred_label(pred_label==0,:)=-1;
accuracy = 1-sum(pred_label~=test_label)/length(test_label)
accuracyList=[];

for i =1:size(train_data,1)
    
    x=train_data(i,:);
    
    y=train_label(i,1);
    [w] = IncreL1LSSVM(x,y,C,w,lr);
    if(mod(i, batch_size) == 0)
       pred_label = double(test_data*w>0);
       pred_label(pred_label==0,:)=-1;
       accuracy = 1-sum(pred_label~=test_label)/length(test_label);
       accuracyList=[accuracyList;accuracy];
    end
end
accuracyList
