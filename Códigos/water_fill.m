function  result = water_fill(Trans_Power, Noise_Power)

Number_Channel= length(Noise_Power) ; 
[S_Number, dt]=sort(Noise_Power);
for p=length(S_Number):-1:1
    T_P=(Trans_Power+sum(S_Number(1:p)))/p;
    Input_Power=T_P-S_Number;
    Pt=Input_Power(1:p);
    if(Pt(:)>=0)
        break
    end
end
Allocated_Power=zeros(1,Number_Channel);
Allocated_Power(dt(1:p))=Pt;
result =  Allocated_Power;
%result = Noise_Power + Allocated_Power;
%Capacity=sum(log2(1+Allocated_Power./Noise_Power));

%for ii =1:length(Noise_Power)
%    g(ii,:)=[Noise_Power(ii),Allocated_Power(ii)];
%end
%bar(g,'stack');
%legend ('Noise Level','Power Level','')
%ylabel('Noise & Power Level','fontsize',12)
%xlabel('Number of Channels (N)','fontsize',12)
%title('Power Allocation for Waterfilling Alogorithm','fontsize',12)
end

