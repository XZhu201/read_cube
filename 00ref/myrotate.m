clc
% clear

input_sita = 50 ;
sita = input_sita/180*pi;             % �趨��ת�ĽǶȣ���Ϊ˳ʱ����ת

load my_psi_xyz.mat;            % ���벨������mat�ļ�
fai = psi_xyz;                        % ����ת�ķ��Ӳ�����

%%%%% �ռ�������趨 %%%%% 
xmin = -5/0.53 ;
ymin = -5/0.53 ;
zmin = -5/0.53 ;

xmax = 5/0.53 ;
ymax = 5/0.53 ;
zmax = 5/0.53 ;                                    

dx = 0.2/0.53;
dy = 0.2/0.53;
dz = 0.2/0.53;                               % ����>ԭ�ӵ�λ

x = xmin : dx : xmax ;                % ����x���ϵ�����ֵ
y = ymin : dy : ymax ;                % ����y���ϵ�����ֵ
z = zmin : dz : zmax ;                % ����z���ϵ�����ֵ

% �ռ����껹�������ֵ����smallx��smallyҪ����


%%%%% ��ת %%%%%
[ mx  my ] = meshgrid( x , y ) ;
       
newx = mx.*cos(sita) + my.*sin(sita);
newy = -mx.*sin(sita) + my.*cos(sita);    % ��ת���������


%%%%% ��ֵ %%%%%    
disp('interp3 ...');

Nsmall = 51 ;

smallx = linspace(-xmax/sqrt(2) , xmax/sqrt(2) , Nsmall);
smally = linspace(-ymax/sqrt(2) , ymax/sqrt(2) , Nsmall);      
                            % ��ȡ���߿򳤶����̣�����sqrt��2����ȡNsmall����
dx = 2*xmax/(Nsmall-1)/sqrt(2);            % ����Ҳ�����������
dy = 2*ymax/(Nsmall-1)/sqrt(2);
                       
[ XI ,YI ] = meshgrid( smallx , smally );       % �趨��ֵ����µ�����ϵ
    
for nnz = 1:length(z)  

    plane = fai(:,:,nnz);                       % ��ֵ��n��             
    VI(:,:,nnz) = griddata(newx,newy,plane,XI,YI,'cubic');     % ��ֵ,VI(x,y,z)����fai(x,y,z)��ֵ
    
%     plane = fai_plus(:,:,nnz);
%     VI_plus(:,:,nnz) = griddata(newx,newy,plane,XI,YI,'cubic');
  
    %%%%%
    
%     for nnx = 1:length(smallx)
%         for nny = 1:length(smally)
%        
%             if isnan( VI(nnx,nny,nnz) )
%                 VI(nnx,nny,nnz) = 0;         % ����
%             end
%             
%             if isnan( VI_plus(nnx,nny,nnz) )
%                 VI_plus(nnx,nny,nnz) = 0;         % ����
%             end
%             
%         end
%     end

    %%%%%
end


norm =  sum(sum(sum( abs(VI).^2 ))) .* dx*dy*dz


%%%%% ��ͼ %%%%%
str_title = num2str(input_sita);

figure; mesh(smallx,smally,real( VI(:,:,25) ));
figure; pcolor(smallx,smally,real( VI(:,:,25) ));
shading interp;
str_title = num2str(input_sita);
title(['psi__xyz' str_title]);