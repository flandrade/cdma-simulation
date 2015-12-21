% Simulation of CDMA communication system
% https://github.com/flandrade/cdma-simulation
%
% Copyright 2014. Fernanda Andrade
% Universidad de las Fuerzas Armadas - ESPE
%
% Last modified 16-Dec-2015

clear all
clc

%--------------------------------------------------------------------------
%----------------- COMMUNICATION OPTIONS ----------------------------------
%--------------------------------------------------------------------------

%----------------- Quantization -------------------------------------------
%Number of levels
nivel=32;

%TYPE OF QUANTIZATION
% Choose:
% 1 = Uniform
% 2 = Mu-law
% 3 = A-Law
opcion=1;

%----------------- Multiple Access ----------------------------------------
%TYPE OF CODE
% 1 = Orthogonal (Synchronous)
% 2 = Random (Asynchronous)
opt=1;

%GP Value
Gp=16;

%----------------- AWGN Chanel -------------------------------------------
% Eb/N0 The energy per bit to noise power spectral density ratio
% Option: 1 to 10 where 10 is the least noisy
ebno=5;


%%
%--------------------------------------------------------------------------
%---------------------- TRANSMITTER ---------------------------------------
%--------------------------------------------------------------------------

%--------------------- LOADING VOICES -------------------------------------
%Number of users
numusuarios = 4;

%Loading voices
[x1,fm1]=audioread('voz1.wav');
[x2,fm2]=audioread('voz2.wav');
[x3,fm3]=audioread('voz3.wav');
[x4,fm4]=audioread('voz4.wav');

%PLOT
%Plotting input signals (voices)
figure(1)
subplot(2,2,1)
plot(x1)
axis([ 0 4500 min(x1) max(x1) ])
title('Input signal 1');
subplot(2,2,2)
plot(x2)
axis([ 0 4500 min(x2) max(x2) ])
title('Input signal 2');
subplot(2,2,3)
plot(x3)
axis([ 0 4500 min(x3) max(x3) ])
title('Input signal 3');
subplot(2,2,4)
plot(x4)
axis([ 0 4500 min(x3) max(x3) ])
title('Input signal 4');

% Playing voices
disp('Playing input signals');
soundsc(x1,fm1);
pause(3)
soundsc(x2,fm2);
pause(3)
soundsc(x3,fm3);
pause(3)
soundsc(x4,fm4);
pause(3)


%------------------------- QUANTIZATION -----------------------------------
%Quantization
[y_1, x2_1, errorcuantizacion_1] = cuantizar(x1,opcion,nivel);
[y_2, x2_2, errorcuantizacion_2] = cuantizar(x2,opcion,nivel);
[y_3, x2_3, errorcuantizacion_3] = cuantizar(x3,opcion,nivel);
[y_4, x2_4, errorcuantizacion_4] = cuantizar(x4,opcion,nivel);

%Variables to plot
xg=x2_1; y=y_1; errorcuantizacion=errorcuantizacion_1;
x=x1; fm=fm1;

%PLOT
%Plotting input signal with levels of quantization
figure(2)
subplot(2,1,1)
plot(x);
axis([ 0 4500 min(x) max(x) ])
hold on
for vv=1:nivel
    hold on
    plot(y_1(vv,:));
end
grid on
xlabel('samples')
ylabel('x(t)')
title('Input signal with levels')

subplot(2,1,2)
plot(xg)
axis([ 0 4500 min(xg) max(xg)])
grid on
xlabel('samples')
title('Input signal quantized')


%---------------------- REMAP MATRIX TO TRANSMIT --------------------------
%------------  USER 1
%Transform
x3=x2_1-1;
bits=dec_bin(x3,log2(nivel));
[m n]=size(bits);

%Matrix to vector
tem=[];
for i=1:size(bits,1)
    for j=1:size(bits,2)
        tem=[tem bits(i,j)];
    end
end
bitsc_1=tem;


%------------  USER 2
%Transform
x3=x2_2-1;
bits=dec_bin(x3,log2(nivel));

%Matrix to vector
tem=[];
for i=1:size(bits,1)
    for j=1:size(bits,2)
        tem=[tem bits(i,j)];
    end
end
bitsc_2=tem;


%------------  USER 3
%Transforma
x3=x2_3-1;
bits=dec_bin(x3,log2(nivel));

%Matrix to vector
tem=[];
for i=1:size(bits,1)
    for j=1:size(bits,2)
        tem=[tem bits(i,j)];
    end
end
bitsc_3=tem;


%------------  USER 4
%Transform
x3=x2_4-1;
bits=dec_bin(x3,log2(nivel));

%Matrix to vector
tem=[];
for i=1:size(bits,1)
    for j=1:size(bits,2)
        tem=[tem bits(i,j)];
    end
end
bitsc_4=tem;


%%
%---------------------------- MODULATION  ---------------------------------
%Matrix
bits=[bitsc_1; bitsc_2; bitsc_3; bitsc_4];
nbits=length(bits);

%BPSK matrix
bitsm=bits*2-1;


%%
%---------------------------- MULTIPLE ACCESS  ----------------------------

%Access codes
if opt==1
    codigos=(1/sqrt(Gp))*hadamard(Gp);
    codigos=codigos(2:numusuarios+1,:);
else
    codigos=(1/sqrt(Gp))*((round(rand(numusuarios,Gp)))*2-1);

    %Correlation matrix
    R=codigos*codigos';
end


%Repeat bits and remap according to GP, code and nbits
y_tx=kron(bitsm,ones(1,Gp)).*repmat(codigos,1,nbits); %BPSK


%%
%--------------------------------------------------------------------------
%---------------------- AWGN CHANNEL --------------------------------------
%--------------------------------------------------------------------------

ebn0=10^(ebno/10);
sigma=1/sqrt(2*ebn0);

y=sum(y_tx);

%Adding AWGN Noise
ruido=normrnd(0,sigma,1,length(y));
y_canal=y+ruido;


%%
%--------------------------------------------------------------------------
%---------------------- RECEIVER ------------------------------------------
%--------------------------------------------------------------------------

y3=reshape(y_canal,Gp,nbits);
y4=codigos*y3;

%------------  DEMODULATION
bitsmr=sign(y4);
bitsr=(bitsmr+1)/2;

%------------ MESSAGE
%Division
usuario1=bitsr(1,:);

p=1;
for i=1:m
    for j=1:n
        bitsr_usuario1(i,j)=usuario1(1,p);
        p=p+1;
    end
end

usuario2=bitsr(2,:);

p=1;
for i=1:m
for j=1:n
    bitsr_usuario2(i,j)=usuario2(1,p);
    p=p+1;
end
end

usuario3=bitsr(3,:);

p=1;
for i=1:m
    for j=1:n
        bitsr_usuario3(i,j)=usuario3(1,p);
        p=p+1;
    end
end

usuario4=bitsr(4,:);

p=1;
for i=1:m
    for j=1:n
        bitsr_usuario4(i,j)=usuario4(1,p);
        p=p+1;
    end
end


%---------- Play according to user

disp('1 - User 1')
disp('2 - User 2')
disp('3 - User 3')
disp('4 - User 4')
disp('5 - All (user voices)')
prompt = 'Which user do you want to play? ';
menusuario = input(prompt);

switch menusuario
    case 1
        %------------  USER 1
        xr=int_state(bitsr_usuario1);
        xrt=xr+1; xrt=xrt';
        soundsc(xrt,fm1);

    case 2
        %------------  USER 2
        xr=int_state(bitsr_usuario2);
        xrt=xr+1; xrt=xrt';
        soundsc(xrt,fm2);

    case 3
        %------------  USER 3
        xr=int_state(bitsr_usuario3);
        xrt=xr+1; xrt=xrt';
        soundsc(xrt,fm3);

    case 4
        %------------  USER 4
        xr=int_state(bitsr_usuario4);
        xrt=xr+1; xrt=xrt';
        soundsc(xrt,fm4);
    case 5
        %Sum
        y5=sum(y4);

        %Demodulator
        bitsmr=sign(y5);
        bitsr=(bitsmr+1)/2;

        p=1;
        for i=1:m
            for j=1:n
                bitsr_usuario(i,j)=bitsr(1,p);
                p=p+1;
            end
        end

        xr=int_state(bitsr_usuario);
        xrt=xr+1; xrt=xrt';
        soundsc(xrt,fm1);

    otherwise
        disp('Playing user 1')
        xr=int_state(bitsr_usuario1);
        xrt=xr+1; xrt=xrt';
        soundsc(xrt,fm1);
end

%Output signal
figure(3)
plot(xrt)
axis([ 0 4500 min(xrt) max(xrt) ])
title('Output signal');


%%
%--------------------------------------------------------------------------
%-------------------------- BER ------------------------------------------
%--------------------------------------------------------------------------

%------------ Calculating PE Error in AWGN Channel

pet=[];
ebn0db=0:1:10;

for eb=ebn0db

    ebn0=10^(eb/10);
    sigma=1/sqrt(2*ebn0);

    error=0;
    pe=[];

    while error<10

        y=sum(y_tx);

        %AWGN Noise
        ruido=normrnd(0,sigma,1,length(y));
        y_canal=y+ruido;

        y3=reshape(y_canal,Gp,nbits);
        y4=codigos*y3;

        %------------  Demodulator
        bitsmr=sign(y4);
        bitsr=(bitsmr+1)/2;

        %------------ Message
        %Division
        usuario1=bitsr(1,:);

        p=1;
        for i=1:m
            for j=1:n
                bitsr_usuario1(i,j)=usuario1(1,p);
                p=p+1;
            end
        end

        if numusuarios>1
            usuario2=bitsr(2,:);

            p=1;
            for i=1:m
                for j=1:n
                    bitsr_usuario2(i,j)=usuario2(1,p);
                    p=p+1;
                end
            end

            if numusuarios>2
                usuario3=bitsr(3,:);

                p=1;
                for i=1:m
                    for j=1:n
                        bitsr_usuario3(i,j)=usuario3(1,p);
                        p=p+1;
                    end
                end

                if numusuarios>3
                    usuario4=bitsr(4,:);

                    p=1;
                    for i=1:m
                        for j=1:n
                            bitsr_usuario4(i,j)=usuario4(1,p);
                            p=p+1;
                        end
                    end

                end
            end
        end


        % Bit Error Rate (BER) according to user

        size(bitsc_1);
        size(usuario1);
        size(bitsr_usuario1);

        switch menusuario
            case 1
                error=error+sum(xor(bitsc_1,usuario1));
                pe=[pe sum(xor(bitsc_1,usuario1))/length(y_tx)];
            case 2
                error=error+sum(xor(bitsc_2,usuario2));
                pe=[pe sum(xor(bitsc_2,usuario2))/length(y_tx)];
            case 3
                error=error+sum(xor(bitsc_3,usuario3));
                pe=[pe sum(xor(bitsc_3,usuario3))/length(y_tx)];
            case 4
                error=error+sum(xor(bitsc_4,usuario4));
                pe=[pe sum(xor(bitsc_4,usuario4))/length(y_tx)];
            otherwise
                break
        end

    end

    %p=mean(pe);
    pet=[pet mean(pe)];
end

%Pe error
errorpe=mean(pet);

%BER Plot
if (menusuario==1 || menusuario==2 || menusuario==3 || menusuario==4)
    figure(4)
    semilogy(ebn0db,pet,'o-');
    xlabel('Eb/N0, dB')
    ylabel('Bit Error Rate')
    title('BER Curve')
    grid on;
end
