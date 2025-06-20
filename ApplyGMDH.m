function Yhat = ApplyGMDH(Network, X)

    nLayer = numel(Network.Layers);

    Z = X;
    for l=1:nLayer
        Z = GetLayerOutput(Network.Layers{l}, Z);
    end
    Yhat = Z;
    
end

function Z = GetLayerOutput(L, X)
    
    m = size(X,2);
    N = numel(L);
    Z = zeros(N,m);
    
    for k=1:N
        vars = L(k).vars;
        x = X(vars,:);
        Z(k,:) = L(k).f(x);
    end

end