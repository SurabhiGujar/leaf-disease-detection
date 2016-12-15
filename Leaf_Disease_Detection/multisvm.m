function [result] = multisvm( Train,Group,test )
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs. all relation. 
%
%This code was adapted and cleaned from Manu BN's multisvm function
%found at https://www.mathworks.com/matlabcentral/fileexchange/
%55098-plant-leaf-disease-detection-and-classification-using-multiclass-svm-classifier

%Inputs: Train=Training Matrix, Group, test=Testing matrix
%Outputs: Result=Resultant class

iter=size(test,1);
result=[];
Cb=Group;
Tb=Train;

for tempind=1:iter
    tst=test(tempind,:);
    Group=Cb;
    Train=Tb;
    u=unique(Group);
    N=length(u);
    c4=[];
    c3=[];
    j=1;
    k=1;
    if(N>2)
        itr=1;
        classes=0;
        cond=max(Group)-min(Group);
        while((classes~=1)&&(itr<=length(u))&& size(Group,2)>1 && cond>0)
        %This while loop is the multiclass SVM Trick
            c1=(Group==u(itr));
            newClass=c1;
            %svmStruct = svmtrain(T,newClass,'kernel_function','rbf'); % I am using rbf kernel function, you must change it also
            svmStruct = svmtrain(Train,newClass);
            classes = svmclassify(svmStruct,tst);
        
            % This is the loop for Reduction of Training Set
            for i=1:size(newClass,2)
                if newClass(1,i)==0;
                    c3(k,:)=Train(i,:);
                    k=k+1;
                end
            end
        Train=c3;
        c3=[];
        k=1;
        
            % This is the loop for reduction of group
            for i=1:size(newClass,2)
                if newClass(1,i)==0;
                    c4(1,j)=Group(1,i);
                    j=j+1;
                end
            end
        Group=c4;
        c4=[];
        j=1;
        
        cond=max(Group)-min(Group); % Condition for avoiding group 
                            %to contain similar type of values 
                            %and the reduce them to process
        
            % This condition can select the particular value of iteration
            % base on classes
            if classes~=1
                itr=itr+1;
            end    
        end
    end

valt=Cb==u(itr);		% This logic is used to allow classification
val=Cb(valt==1);		% of multiple rows testing matrix
val=unique(val);
result(tempind,:)=val;  
end

end

