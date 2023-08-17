%Task 1: Transmission Line Parameters
clear;
clc;
prompt = {'1- conductor resistivity(Ω.meter):','2- conductor length(km):','3- conductor diameter(cm):'};
answer = inputdlg(prompt,'please enter the following parameters:',[1 60]);
resistivity=str2num(answer{1});
l1=str2num(answer{2});
D=str2num(answer{3});
l=l1*1000;
r=D/(2*100);
GMR=0.7788*r;
area=pi*(r^2);
Rdc=(resistivity*l)/area;
Rac=Rdc;
list = {'symmetrical','unsummetrical'};
index = listdlg('PromptString',{'Is the transmission system','symmetrical or unsymmetrical:',''},'ListString',list,'SelectionMode','single','ListSize',[180 200]);
 if index == 1
    answer = inputdlg('Distance(m):','Enter the distance btween every two phases',[1 60]);
     Deq=str2num(answer{1});
     Lph=2*(10^-7)*log(Deq/GMR);
     L=Lph*l;
     Cph=(2*pi*8.85*(10^-12))/log(Deq/r);
     C=Cph*l;
 else
     prompt = {'D1(m):','D2(m):','D3(m):'};
     answer = inputdlg(prompt,'enter the distance between each two phases:',[1 60]);
     D1=str2num(answer{1});
     D2=str2num(answer{2});
     D3=str2num(answer{3});
     eq=D1*D2*D3;
     Deq= nthroot(eq,3);
     Lph=2*(10^-7)*log(Deq/GMR);
     L=Lph*l;
     Cph=(2*pi*8.85*(10^-12))/log(Deq/r);
     C=Cph*l;
 end
msgbox(sprintf('Resistance per phase = %fΩ/m\nInductance per phase = %fH \nCapacitance per phase = %fµF',Rac,L,C*10^6));
%------------------------------------------------------------------------------------------------------------
%Task 2: ABCD Parameters
frequency = 50;
Z = complex(Rac,2*pi*L*frequency);
Y = complex(0,2*pi*C*frequency);
if l1 <= 80
    A = 1;
    B = Z;
    C = 0;
    D = 1;
    msgbox(sprintf('it is a short transmission line with the following ABCD parameters:\nA = %f\nB = %f + j%f\nC = %f\nD = %f',A,real(B),imag(B),C,D));
else
    list = {'π','T'};
    index = listdlg('PromptString',{'The transmission Line is Medium','Is the transmission system','π or T:',''},'ListString',list,'SelectionMode','single','ListSize',[180 200]);
if index == 1
    A = 1 + (Z*Y)/2;
    B = Z;
    C = Y*(1+(Z*Y)/4);
    D = A;
    msgbox(sprintf('A = %f + j%f\nB = %f + j%f\nC = %f + j%f\nD = %f + j%f',real(A),imag(A),real(B),imag(B),real(C),imag(C),real(D),imag(D)));
else 
    A = 1 + (Z*Y)/2;
    C = Y;
    B = Z*(1+(Z*Y)/4);
    D = A;
    msgbox(sprintf('A = %f + j%f\nB = %f + j%f\nC = %f + j%f\nD = %f + j%f',real(A),imag(A),real(B),imag(B),real(C),imag(C),real(D),imag(D)));
end
end
 %----------------------------------------------------------------------------------------------------------------------------------------------
list = {'1','2'};
 x = listdlg('PromptString',{'case 1 or case 2'},'ListString',list,'SelectionMode','single','ListSize',[180 200]);

switch x
    case 1
        prompt = {'receiving end voltage in Kv:'};
ans = inputdlg(prompt,'please enter the following parameters:',[1 60]);
        Vr=str2num(ans{1});
        pf=0.8;
        Pr=linspace(0,100,101); %Active power in kw
        VRph=Vr*1000/sqrt(3);
        Ir=Pr*1000/(3*VRph*pf);
        IR =((Ir))*complex(cos(-acos(pf)),sin(-acos(pf)));
        VS=A*VRph+B*IR;
        IS=C*VRph+D*IR;
        Ps=3.*abs(VS).*abs(IS).*cos(angle(VS)-angle(IS));
        EFF=((Pr*1000)./Ps)*100 ;  %efficiency
        VReg=(((abs(VS)/abs(A))-abs(VRph))/abs(VRph))*100; %voltage regulation
        plot(Pr,EFF), title('efficiency-active power');
        plot(Pr,VReg),title('Voltage Reg-active power');;
       
     case 2
        Pr=100; %in kw
        prompt = {'receiving end voltage in Kv:'};
ans = inputdlg(prompt,'please enter the following parameters:',[1 60]);
        Vr=str2num(ans{1});
        pf_range=linspace(0.3,1);
        pf1=linspace(-0.3,-1);  %lag
        pf2=linspace(0.3,1);   %lead
        VRph=Vr*1000/sqrt(3);
        Ir=(Pr*1000)./(3.*VRph.*pf_range);
        IR1 =((Ir)).*complex(-cos(acos(pf1)),sin(-acos(pf1)));
        IR2 =((Ir)).*complex(cos(acos(pf2)),sin(acos(pf2)));
        VS1=A*VRph+B.*IR1;
        VS2=A*VRph+B.*IR2;
        IS1=C*VRph+D.*IR1;
        IS2=C*VRph+D.*IR2;
        Ps1=3.*abs(VS1).*abs(IS1).*cos(angle(VS1)-angle(IS1));
        Ps2=3.*abs(VS2).*abs(IS2).*cos(angle(VS2)-angle(IS2));
        EFF1=((Pr*1000)./Ps1)*100;  %efficiency
        EFF2=((Pr*1000)./Ps2)*100;  %efficiency
        VReg1=(((abs(VS1)/abs(A))-abs(VRph))/abs(VRph))*100; %voltage regulation
        VReg2=(((abs(VS2)/abs(A))-abs(VRph))/abs(VRph))*100; %voltage regulation
        
        subplot(2,2,1);
        plot(pf_range,EFF1),title('efficiency-Pf lag');
        subplot(2,2,2);
        plot(pf_range,VReg1),title('voltage Reg.-Pf lag');
        subplot(2,2,3);
        plot(pf_range,EFF2),title('efficiency-Pf lead');
        subplot(2,2,4);
        plot(pf_range,VReg2),title('voltage Reg.-Pf lead');
end 

        