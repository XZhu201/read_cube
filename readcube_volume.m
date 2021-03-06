% This is fast and good~
% extract the data from the .cube file
% the inporated data are named data

clc
clear

%% input
str_title = 'density.cube';
Nhead = 7;
isovalue = 0.05;

%% read file
D=importdata(str_title,' ',Nhead);
data = D.data;
head = D.textdata;

%% read the parameters from the head
% for x,y,z_min
templine = split(head(3));
Nwords = length(templine);

xmin = str2double(templine{Nwords-2})   % use {} instead of () for cell !!
ymin = str2double(templine{Nwords-1})
zmin = str2double(templine{Nwords})     

% for Nx,dx
templine = split(head(4));
Nwords = length(templine);
Nx = str2double(templine{Nwords-3}) 
dx = str2double(templine{Nwords-2}) 

% for Ny,dy
templine = split(head(5));
Nwords = length(templine);
Ny = str2double(templine{Nwords-3}) 
dy = str2double(templine{Nwords-1}) 

% for Nz,dz
templine = split(head(6));
Nwords = length(templine);
Nz = str2double(templine{Nwords-3}) 
dz = str2double(templine{Nwords}) 

% generate the grid
x = xmin : dx : xmin+(Nx-1)*dx ;                
y = ymin : dy : ymin+(Ny-1)*dy ;                
z = zmin : dz : zmin+(Nz-1)*dz ;                



%%%%% 在转为3D矩阵 %%%%%
psi_xyz = zeros(Nx,Ny,Nz);
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
                            % 在实际使用中，发现还是需要通过判断跳过一些点
                
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

%%%%% plot and save %%%%%
figure; pcolor( x,y,psi_xyz( :,:,round(Nz/2)-10 ) ); 
xlabel('x')
ylabel('y')
shading interp;
saveas(gcf,'plot_xy.png')

figure; isosurface(x,y,z,(psi_xyz),isovalue); hold on;  isosurface(x,y,z,(psi_xyz),-isovalue); hold off;
xlabel('x')
ylabel('y')
zlabel('z')
alpha(0.5)
saveas(gcf,'surface_3D.png')

save my_psi_xyz.mat psi_xyz norm   % textdata;
