%% 该程序的作用是读取Octopus含时输出的td中的cube文件，提取输出过程中的波函数或电子密度，得到相关内容,
% originated by Liu Xi

clear all;
%% -------------读取含时输出的波函数或密度等 -------------------
filepath='/home/laser/xi/octopus/benzene-me/ts_cutoff_1200_8e13';   %存放td文件的路径
Eve=50;  %每多少个步长输出一次td
last_term = 0022046     %最后一项的值
Nmax=fix(last_term/Eve)*Eve %最大的输出标号是多少
filename = 'sqm-wf-st0013.cube';
Line = 12; %第6行后多余的行数,消除中间的无用行，根据多余行的数目来添加
if last_term == Nmax
    temp=0:Eve:Nmax;
   else
    temp=[0:Eve:Nmax,last_term];
    fprintf('Need add last term\n');
end
fprintf('size(temp):%d\n',length(temp));
for h=temp
    name = num2str(h);
    while (length(name)<7)  %由于生成的td文件名的.后面都含有7个数字
        name=strcat('0',name);
    end  
    %path=strcat(filepath,'\td.',name,'\',filename);  %需要读取的matlab文件 ,windows  
     path=strcat(filepath,'/td.',name,'/',filename);  %需要读取的matlab文件,linux  
fid = fopen(path,'r');
frewind(fid); %指针移到文件首
fgets(fid);
fgets(fid);
[Num,count] = fscanf(fid, '%d', 1);
[min,count] = fscanf(fid,'%f',3);
[Nx,count] = fscanf(fid,'%d',1);
[Dx,count] = fscanf(fid,'%f',3);
[Ny,count] = fscanf(fid,'%d',1);
[Dy,count] = fscanf(fid,'%f',3);
[Nz,count] = fscanf(fid,'%d',1);
[Dz,count] = fscanf(fid,'%f',3);
for i=1:Line+1  %比Line的数目要多1，因为第6行最后还有一个'\n'
fgets(fid); %输出以检查是否读完
end
dx=Dx(1);
dy=Dy(2);
dz=Dz(3);
%指定读入后存数据的变量，放判断是否需要最后一项,利用第一项存入
hh = ceil(h/Eve)+1;  %对应下标的指标，注意，很容易出错，ceil必不可少
if h==0
     psi_xyz =zeros(Nx,Ny,Nz,length(temp));
     [S1,S2,S3,S4]=size(psi_xyz);
     fprintf('generate matrix psi_xyz:\n');
     fprintf('size(psi_xyz): %d %d %d %d\n',S1,S2,S3,S4);   
end
 for i = 1: Nx
   for j=1:Ny
      for k=1:Nz
          [psi_xyz(i,j,k,hh),count]=fscanf(fid,'%f',1);
       end
   end
 end
%检查数据是否读完
count = 0;
while ~feof(fid)
   [temp2,count] = fscanf(fid,'%f',1);
    fprintf('%f\n',temp2);
    if count == 1
        error('行数错误，请检查Line变量');
    end
end
fclose(fid); %关闭文件

%检查归一参数,因为读取的主要有三项，波函数wf，波函数模方sqm-wf,电子密度density,所以要根据需要选取
%norm_wf（hh) =  sum(sum(sum( abs(psi_xyz).^2 ))) .* dx*dy*dz  %波函数wf
norm_sqm_wf(hh) = sum(sum(sum( abs(psi_xyz(:,:,:,hh))))) .* dx*dy*dz;  %波函数模方sqm_wf
%norm_density(hh) = sum(sum(sum( abs(psi_xyz)))) .* dx*dy*dz %电子密度
%打印中间结果
fprintf('Iter: %d\n',h);
fprintf('norm_sqm_wf: %f',norm_sqm_wf(hh));
end


%% 得到时间轴
w0 =45.6/1200  %基频场
T = 2*pi/w0;
tmax = 8*T;
t = temp/max(temp)*tmax;
%% 作图
figure;
plot(t/T,norm_sqm_wf);
saveas(gcf,strcat(filename,'_norm_sqm_wf.fig'));

%% 保存数据
flag_psi = 1; %决定是否清除psi_xyz,由于psi_xyz数组较大，决定是否保存
savename = strcat(filename,'.mat');
if flag_psi   %决定是否保存psi_xyz,由于psi_xyz数据较大，决定是否保存
  clear psi_xyz ;   %不保存psi_xyz
  save(savename);
end
save(savename);
%save(savename,'-v7.3') ;  %如果要保存psi_xyz,可能要以v7.3格式来保存








