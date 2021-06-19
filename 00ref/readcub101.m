% 恩，这个极快又可行~
% 直接从.cub文件的数据中提取波函数
% 读入数据重命名为data
% erer

clc

discription = 'NO mo=homo(9)  101*101*101 points -5:0.1:5 A' ;
unit = 'angstrom';

dx = 0.1  ;
dy = 0.1  ;
dz = 0.1  ;

Nx = 101 ;    %   每一维的点数
Ny = 101 ;
Nz = 101 ;

xmin = -5.0 ;
ymin = -5.0 ;
zmin = -5.0 ;

xmax = 5.0;
ymax = 5.0;
zmax = 5.0;

x = xmin/0.53 : dx/0.53 : xmax/0.53 ;                % 定义x轴上的坐标值
y = ymin/0.53 : dy/0.53 : ymax/0.53 ;                % 定义y轴上的坐标值
z = zmin/0.53 : dz/0.53 : zmax/0.53 ;                % 定义z轴上的坐标值




%%%%% 在转为3D矩阵 %%%%%
m = 0;
disp('to 3D ...');
for i = 1:Nx
    for j = 1:Ny        
        for k = 1:Nz
            %%%
            m = m+1 ;       
            
            rr = fix( (m-1)/6 )+1 ;
            ll = mod(m-1,6)+1 ;
            dd = data(rr,ll) ;
            
            while ( isnan(dd) )       
                m = m+1 ;   % 不必担心m超出数据个数，因为在最后一个循环首先读到的必然是最后一个有效数据，而不是NaN
                
                rr = fix( (m-1)/6 )+1 ;
                ll = mod(m-1,6)+1 ;
                dd = data(rr,ll) ;
            end
            
            psi_xyz(i,k,j) = dd;

            %%%
        end
    end
end

norm =  sum(sum(sum( abs(psi_xyz).^2 ))) .* dx*dy*dz/(0.53)^3 
% norm =  sum(sum(sum( psi_xyz ))) .* dx*dy*dz/(0.53)^3 

%%%%% 作图检查 %%%%%

figure; mesh( x,y,psi_xyz( :,:,round(Nz/2)+1 ) ) ;
figure; pcolor( x,y,psi_xyz( :,:,round(Nz/2)+1 ) ); 
shading interp;

figure; plot(x,psi_xyz(51,:,51))

save my_psi_xyz.mat psi_xyz discription  norm   % textdata;
