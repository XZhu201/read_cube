% This is fast and good~
% extract the data from the .cube file
% the inporated data are named data

clc
clear

%% input
str_title = 'density.cube';
Nhead = 12;
isovalue = 0.05;

%% avoid xx-xxx
% there is a bug in the output of .cube, xxE-101 could be written as xx-101
% https://blog.csdn.net/u013249853/article/details/101440962?utm_term=matlab%E4%B8%80%E8%A1%8C%E4%B8%80%E8%A1%8C%E8%AF%BB%E5%8F%96%E5%AD%97%E7%AC%A6&utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~sobaiduweb~default-2-101440962&spm=3001.4430

fid = fopen(str_title);

nline = 0;
data = [];    % initialize the matrix data

disp('Reading the file, line by line ...')

while(true)
    nline = nline + 1;
    tline = fgetl(fid);
    
    if ~ischar(tline)   % at the end of the file
        break;
    end
    
    if nline>Nhead          % skip the headlines, and work on the data
                disp(tline)
        
        if length(tline)<84     % if the line has 6 numbers, not only 1 number
            tline = [tline,repmat(' ',1,84-length(tline))];
        end
        
        if tline(81) ==  '-'
            tline(81:84) = 'E-99';
        end  % end of tline
        
        if tline(67) ==  '-'
            tline(67:70) = 'E-99';
        end  % end of tline
        
        if tline(53) ==  '-'
            tline(53:56) = 'E-99';
        end  % end of tline
        
        if tline(39) ==  '-'
            tline(39:42) = 'E-99';
        end  % end of tline
        
        if tline(25) ==  '-'
            tline(25:28) = 'E-99';
        end  % end of tline
        
        if tline(11) ==  '-'
            tline(11:14) = 'E-99';
        end  % end of tline
        
                disp(tline);
        
        
        % transfer the str to number
        new_data = str2num(tline);
        
        if length(new_data)<6
            %             new_data = [new_data, zeros(1,6-length(new_data))];
            new_data = [new_data, nan(1,6-length(new_data))];
        end
        
        data = [data; new_data];
                disp(new_data)
        
    end % end of if nline>Nhead
    
end % end of while

fclose(fid);

%% read file
% for v2, read for head only
D=importdata(str_title,' ',Nhead);
data_check = D.data;
head = D.textdata;

%% read the parameters from the head
% for x,y,z_min
templine = split(head(3));
Nwords = length(templine);

xmin = str2double(templine{Nwords-2}) ;   % use {} instead of () for cell !!
ymin = str2double(templine{Nwords-1}) ;
zmin = str2double(templine{Nwords})  ;

% for Nx,dx
templine = split(head(4));
Nwords = length(templine);
Nx = str2double(templine{Nwords-3}) ;
dx = str2double(templine{Nwords-2}) ;

% for Ny,dy
templine = split(head(5));
Nwords = length(templine);
Ny = str2double(templine{Nwords-3}) ;
dy = str2double(templine{Nwords-1}) ;

% for Nz,dz
templine = split(head(6));
Nwords = length(templine);
Nz = str2double(templine{Nwords-3}) ;
dz = str2double(templine{Nwords}) ;

disp('xmin,Nx,dx;ymin,Ny,dy;zmin,Nz,dz='),disp([xmin,Nx,dx;ymin,Ny,dy;zmin,Nz,dz])

% generate the grid
x = xmin : dx : xmin+(Nx-1)*dx ;
y = ymin : dy : ymin+(Ny-1)*dy ;
z = zmin : dz : zmin+(Nz-1)*dz ;



%%%%% ??????3D???? %%%%%
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
                m = m+1 ;   % ????????m????????????????????????????????????????????????????????????????????????NaN
                % ????????????????????????????????????????????
                
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

%% plot and save
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
