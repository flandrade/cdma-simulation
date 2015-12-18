function [y, x2, errorcuantizacion] = cuantizar(x,opcion,nivel)

    % Levels of uniform quantization
    dif=(max(x)-min(x))/(nivel-1);
    val=[min(x):dif:max(x)];

    % y = vector to plot levels of quantization
    y=kron(val',ones(1,size(x,1)));


    %------------ TYPES OF QUANTIZATION
    switch opcion
        case 1
            %------------  UNIFORM QUANTIZATION
            %No amplification
            xp=x;
        case 2
            %------------  MU LAW
            mu=255;
            xp=sign(x).*(log(1+mu*abs(x))/log(1 + mu));

         case 3
            %------------  A LAW
            A=87.6;

            for i=1:length(x)
                if abs(x(i))<(1/A)
                    xp(i,1)=sign(x(i)).*((A*abs(x(i)))/(1+log(A)));
                else
                    xp(i,1)=sign(x(i)).*((1+log(A*abs(x(i))))/(1+log(A)));
                end
            end


    end

    % Value decision: it decides where the value corresponds to one level
    % according minimum distance
    ref=repmat(xp',nivel,1);
    x1=abs(y-ref);
    [distancia x2]=min(x1);

    %------------ QUANTIZATION ERROR

    %Signal normalization
    m=2/(nivel-1);
    b=(-nivel-1)/(nivel-1);
    xerror=m.*x2+b;

    for i=1:size(xp,1)
        if xp(i)==0
            xp(i)=0.001;
        end
        er(i)=abs((xp(i)-xerror(i))/xp(i));
    end

    errorcuantizacion=mean(er);
end
