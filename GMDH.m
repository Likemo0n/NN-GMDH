function gmdh = GMDH(params, X, Y)
    
    MaxLayerNeurons = 20;         %Since this function only works in phase I
                                  %this variable is only for Test
    MaxLayers = params.MaxLayers;
    alpha = params.alpha;

    nData = size(X,2);
    
    % Shuffle Data
    Permutation = randperm(nData);
    X = X(:,Permutation);
    Y = Y(:,Permutation);
    
    % Divide Data
    pTrainData = params.pTrain;
    nTrainData = round(pTrainData*nData);
    X1 = X(:,1:nTrainData);
    Y1 = Y(:,1:nTrainData);
    pTestData = 1-pTrainData;
    nTestData = nData - nTrainData;
    X2 = X(:,nTrainData+1:end);
    Y2 = Y(:,nTrainData+1:end);
    
    Layers = cell(MaxLayers, 1);

    Z1 = X1;
    Z2 = X2;
    
    RMSEofeachLayer=zeros(MaxLayers,1);
   
    Raise=0; % 0:  RMSE value reduces in each Layer...
             % 1:  RMSE Value has faced sudden Raise so the netowrk should
             % be stoped (see Line 59)
    for l = 1:MaxLayers

        L = GetPolynomialLayer(Z1, Y1, Z2, Y2);
        RMSEofeachLayer(l)=L.RMSE2;

        ec = alpha*L(1).RMSE2 + (1-alpha)*L(end).RMSE2;
        ec = max(ec, L(1).RMSE2);
        L = L([L.RMSE2] <= ec);

        if numel(L) > MaxLayerNeurons
            L = L(1:MaxLayerNeurons);
        end

        if l==MaxLayers && numel(L)>1
            L = L(1);
        end
        Layers{l} = L;
       
        Z1 = reshape([L.Y1hat],nTrainData,[])';
        Z2 = reshape([L.Y2hat],nTestData,[])';

%         disp(['Layer ' num2str(l) ': Neurons = ' num2str(numel(L)) ', Min Error = ' num2str(L(1).RMSE2)]);
        
        if l>1
           if RMSEofeachLayer(l)>RMSEofeachLayer(l-1)
               Raise=1;    %if it doesnt face "1" value it would mean the curve doesnt raise
               break;
           end
        end
        
        

        if numel(L)==1
            break;
        end

    end
    
     if Raise==1
         Layers=Layers(1:l-1);
         Layers{end}=Layers{end}(1);
     else
    Layers = Layers(1:l);
     end
    
    gmdh.Layers = Layers;
    gmdh.XOrders=X;
    gmdh.YOrders=Y;
end