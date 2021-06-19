% ������������ֿ���~
% ֱ�Ӵ�.cub�ļ�����������ȡ������
% ��������������Ϊdata

clc
% 
% D=importdata('NO.cub');
% data = D.data;

discription = 'NO mo=homo  101*101*101 points -5/0.53:0.1/0.53:5/0.53 A' ;
unit = 'a.u.';

dx = 0.1/0.53  ;
dy = 0.1/0.53  ;
dz = 0.1/0.53  ;

Nx = 101 ;    %   ÿһά�ĵ���
Ny = 101 ;
Nz = 101 ;

xmin = -5/0.53 ;
ymin = -5/0.53 ;
zmin = -5/0.53 ;

xmax = 5/0.53;
ymax = 5/0.53;
zmax = 5/0.53;

x = xmin : dx : xmax ;                % ����x���ϵ�����ֵ
y = ymin : dy : ymax ;                % ����y���ϵ�����ֵ
z = zmin : dz : zmax ;                % ����z���ϵ�����ֵ




%%%%% ��תΪ3D���� %%%%%
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
                m = m+1 ;   % ���ص���m�������ݸ�������Ϊ�����һ��ѭ�����ȶ����ı�Ȼ�����һ����Ч���ݣ�������NaN
                            % ��ʵ��ʹ���У����ֻ�����Ҫͨ���ж�����һЩ��
                
                rr = fix( (m-1)/6 )+1 ;
                ll = mod(m-1,6)+1 ;
                dd = data(rr,ll) ;
            end
            
            psi_xyz(i,j,k) = dd;

            %%%
        end
    end
end

norm =  sum(sum(sum( abs(psi_xyz).^2 ))) .* dx*dy*dz
% norm =  sum(sum(sum( psi_xyz ))) .* dx*dy*dz/(0.53)^3 

%%%%% ��ͼ��� %%%%%

figure; mesh( x,y,psi_xyz( :,:,round(Nz/2)-10 ) ) ;
xlabel('x')
ylabel('y')

figure; pcolor( x,y,psi_xyz( :,:,round(Nz/2)-10 ) ); 
shading interp;

figure; isosurface(x,y,z,(psi_xyz),0.1); hold on;  isosurface(x,y,z,(psi_xyz),-0.1); hold off;
xlabel('x')
ylabel('y')
zlabel('z')

save my_psi_xyz.mat psi_xyz discription  norm   % textdata;
