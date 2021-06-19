clc
% clear

input_sita = 50 ;
sita = input_sita/180*pi;             % 设定旋转的角度，正为顺时针旋转

load my_psi_xyz.mat;            % 载入波函数的mat文件
fai = psi_xyz;                        % 被旋转的分子波函数

%%%%% 空间坐标的设定 %%%%% 
xmin = -5/0.53 ;
ymin = -5/0.53 ;
zmin = -5/0.53 ;

xmax = 5/0.53 ;
ymax = 5/0.53 ;
zmax = 5/0.53 ;                                    

dx = 0.2/0.53;
dy = 0.2/0.53;
dz = 0.2/0.53;                               % 埃—>原子单位

x = xmin : dx : xmax ;                % 定义x轴上的坐标值
y = ymin : dy : ymax ;                % 定义y轴上的坐标值
z = zmin : dz : zmax ;                % 定义z轴上的坐标值

% 空间坐标还有下面插值处的smallx、smally要定义


%%%%% 旋转 %%%%%
[ mx  my ] = meshgrid( x , y ) ;
       
newx = mx.*cos(sita) + my.*sin(sita);
newy = -mx.*sin(sita) + my.*cos(sita);    % 旋转后的新坐标


%%%%% 插值 %%%%%    
disp('interp3 ...');

Nsmall = 51 ;

smallx = linspace(-xmax/sqrt(2) , xmax/sqrt(2) , Nsmall);
smally = linspace(-ymax/sqrt(2) , ymax/sqrt(2) , Nsmall);      
                            % 截取，边框长度缩短，除以sqrt（2），取Nsmall个点
dx = 2*xmax/(Nsmall-1)/sqrt(2);            % 步长也会跟着伸缩的
dy = 2*ymax/(Nsmall-1)/sqrt(2);
                       
[ XI ,YI ] = meshgrid( smallx , smally );       % 设定插值后的新的坐标系
    
for nnz = 1:length(z)  

    plane = fai(:,:,nnz);                       % 插值第n层             
    VI(:,:,nnz) = griddata(newx,newy,plane,XI,YI,'cubic');     % 插值,VI(x,y,z)就是fai(x,y,z)的值
    
%     plane = fai_plus(:,:,nnz);
%     VI_plus(:,:,nnz) = griddata(newx,newy,plane,XI,YI,'cubic');
  
    %%%%%
    
%     for nnx = 1:length(smallx)
%         for nny = 1:length(smally)
%        
%             if isnan( VI(nnx,nny,nnz) )
%                 VI(nnx,nny,nnz) = 0;         % 补零
%             end
%             
%             if isnan( VI_plus(nnx,nny,nnz) )
%                 VI_plus(nnx,nny,nnz) = 0;         % 补零
%             end
%             
%         end
%     end

    %%%%%
end


norm =  sum(sum(sum( abs(VI).^2 ))) .* dx*dy*dz


%%%%% 画图 %%%%%
str_title = num2str(input_sita);

figure; mesh(smallx,smally,real( VI(:,:,25) ));
figure; pcolor(smallx,smally,real( VI(:,:,25) ));
shading interp;
str_title = num2str(input_sita);
title(['psi__xyz' str_title]);