%% �ó���������Ƕ�ȡOctopus��ʱ�����td�е�cube�ļ�����ȡ��������еĲ�����������ܶȣ��õ��������,
% originated by Liu Xi

clear all;
%% -------------��ȡ��ʱ����Ĳ��������ܶȵ� -------------------
filepath='/home/laser/xi/octopus/benzene-me/ts_cutoff_1200_8e13';   %���td�ļ���·��
Eve=50;  %ÿ���ٸ��������һ��td
last_term = 0022046     %���һ���ֵ
Nmax=fix(last_term/Eve)*Eve %�����������Ƕ���
filename = 'sqm-wf-st0013.cube';
Line = 12; %��6�к���������,�����м�������У����ݶ����е���Ŀ�����
if last_term == Nmax
    temp=0:Eve:Nmax;
   else
    temp=[0:Eve:Nmax,last_term];
    fprintf('Need add last term\n');
end
fprintf('size(temp):%d\n',length(temp));
for h=temp
    name = num2str(h);
    while (length(name)<7)  %�������ɵ�td�ļ�����.���涼����7������
        name=strcat('0',name);
    end  
    %path=strcat(filepath,'\td.',name,'\',filename);  %��Ҫ��ȡ��matlab�ļ� ,windows  
     path=strcat(filepath,'/td.',name,'/',filename);  %��Ҫ��ȡ��matlab�ļ�,linux  
fid = fopen(path,'r');
frewind(fid); %ָ���Ƶ��ļ���
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
for i=1:Line+1  %��Line����ĿҪ��1����Ϊ��6�������һ��'\n'
fgets(fid); %����Լ���Ƿ����
end
dx=Dx(1);
dy=Dy(2);
dz=Dz(3);
%ָ�����������ݵı��������ж��Ƿ���Ҫ���һ��,���õ�һ�����
hh = ceil(h/Eve)+1;  %��Ӧ�±��ָ�꣬ע�⣬�����׳���ceil�ز�����
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
%��������Ƿ����
count = 0;
while ~feof(fid)
   [temp2,count] = fscanf(fid,'%f',1);
    fprintf('%f\n',temp2);
    if count == 1
        error('������������Line����');
    end
end
fclose(fid); %�ر��ļ�

%����һ����,��Ϊ��ȡ����Ҫ�����������wf��������ģ��sqm-wf,�����ܶ�density,����Ҫ������Ҫѡȡ
%norm_wf��hh) =  sum(sum(sum( abs(psi_xyz).^2 ))) .* dx*dy*dz  %������wf
norm_sqm_wf(hh) = sum(sum(sum( abs(psi_xyz(:,:,:,hh))))) .* dx*dy*dz;  %������ģ��sqm_wf
%norm_density(hh) = sum(sum(sum( abs(psi_xyz)))) .* dx*dy*dz %�����ܶ�
%��ӡ�м���
fprintf('Iter: %d\n',h);
fprintf('norm_sqm_wf: %f',norm_sqm_wf(hh));
end


%% �õ�ʱ����
w0 =45.6/1200  %��Ƶ��
T = 2*pi/w0;
tmax = 8*T;
t = temp/max(temp)*tmax;
%% ��ͼ
figure;
plot(t/T,norm_sqm_wf);
saveas(gcf,strcat(filename,'_norm_sqm_wf.fig'));

%% ��������
flag_psi = 1; %�����Ƿ����psi_xyz,����psi_xyz����ϴ󣬾����Ƿ񱣴�
savename = strcat(filename,'.mat');
if flag_psi   %�����Ƿ񱣴�psi_xyz,����psi_xyz���ݽϴ󣬾����Ƿ񱣴�
  clear psi_xyz ;   %������psi_xyz
  save(savename);
end
save(savename);
%save(savename,'-v7.3') ;  %���Ҫ����psi_xyz,����Ҫ��v7.3��ʽ������








