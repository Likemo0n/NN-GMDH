function Plotneurones(Network)
figure;

NumberofLayers=numel(Network.Layers);


for L=NumberofLayers:-1:1 
    for Ne=numel(Network.Layers{L}):-1:1
      A=Ne;
      B1=Network.Layers{L}(Ne).vars(1);
      B2=Network.Layers{L}(Ne).vars(2);
      i=[L-1 L];
      j=[B1 A];
      k=[B2 A];
      plot(i,j,'-ko','markerfacecolor','r','markersize',12)
      hold on
      plot(i,k,'-ko','markerfacecolor','r','markersize',12)
      hold on
    end
end
for L=NumberofLayers:-1:1
    D=[];
    for Ne=numel(Network.Layers{L}):-1:1
    
    D=unique(sort([D Network.Layers{L}(Ne).vars]));  
    end
    
    if L==1
        R=size(Network.XOrders,1);
    else
        R=numel(Network.Layers{L-1});
    end
    for M=1:R
        C=(M==D);
        if sum(C)==0
            plot(L-1,M,'o','markerfacecolor','y','markersize',12)
      hold on
        end
        
    end
end
legend('Effective Neurons');
end