%main_Tmatrix
%author: Toby Mansuripur
%last update: 8/20/2014

%This is a general 1D T-matrix code that can handle loss or gain, and is
%capable of plotting intensity vs position. If the stack has a lot of
%periodicities, the program runs fastest with the option save_field_data
%set to 'no'


%{
%%Here is a FP cavity
material(1).index=3.18;
    material(1).gain = 0; %gain is in units of cm^-1
material(2).index=1;
    material(2).gain = 0;
material(3).index=2.43;
    material(3).gain = 0;
   

stack(1).user_input = [1,Inf; %1st layer of 1st stack is the semi-infinite incidence medium
                       2, 4e6; %units of thickness are nm
                       3, 2e6;
                       2,Inf];
stack(1).repeat = 1;

%}
%{
%%Here is a DFB design using the same materials as the bandpass filter
material(1).index=1;
    material(1).gain = 0; %gain is in units of cm^-1
material(2).index=1.02;
    material(2).gain = 0; %9.194;
material(3).index=1;
    material(3).gain = 0; %9.194;
material(4).index=1;
    material(4).gain = 0;
material(5).index = material(2).index;
    material(5).gain=0;
material(6).index = material(3).index;
    material(6).gain=0;

d2=10000/(material(2).index*4); %thickness in nm of a quarter-wave layer of material 2
d1=10000/(material(1).index*4);

%stack is a struct array into which the user defines the layers. Each
%element of the struct array can be repeated by specifying the 'repeat'
%field of the element. The stack goes from left to right as stack(1)
%followed by stack(2) and so on. The first and last elements of the array
%should have 'repeat' set to 1, since the incidence and transmission
%mediums should not be repeated.
stack = struct('user_input',0,'repeat',0,'material',0,'index',0,'gain',0,'width',0,'number_of_layers',0);

stack(1).user_input = [1,Inf]; %1st layer of 1st stack is the semi-infinite incidence medium
                       
stack(1).repeat = 1;

stack(2).user_input = [2,d2;
                       1,d1];
stack(2).repeat=200;

stack(3).user_input = [1,Inf];
                       
stack(3).repeat=1;
%}




%{
%%Here is the bandpass filter design from pg 361 of Thin-film optical filters
material(1).index=1;
    material(1).gain = 0; %gain is in units of cm^-1
material(2).index=2.15;
    material(2).gain = gain; %9.194;
material(3).index=1.45;
    material(3).gain = gain; %9.194;
material(4).index=1.52;
    material(4).gain = 0;
material(5).index = material(2).index;
    material(5).gain=0;
material(6).index = material(3).index;
    material(6).gain=0;

d2=1550/(material(2).index*4); %thickness in nm of a quarter-wave layer of material 2
d3=1550/(material(3).index*4);

%stack is a struct array into which the user defines the layers. Each
%element of the struct array can be repeated by specifying the 'repeat'
%field of the element. The stack goes from left to right as stack(1)
%followed by stack(2) and so on. The first and last elements of the array
%should have 'repeat' set to 1, since the incidence and transmission
%mediums should not be repeated.
stack = struct('user_input',0,'repeat',0,'material',0,'index',0,'gain',0,'width',0,'number_of_layers',0);

stack(1).user_input = [1,Inf; %1st layer of 1st stack is the semi-infinite incidence medium
                       6,1.2462*d3;
                       5, 0.3458*d2];
stack(1).repeat = 1;

stack(2).user_input = [2,d2;
                       3,d3];
stack(2).repeat=7;

stack(3).user_input = [2,d2];
                       
stack(3).repeat=1;

stack(4).user_input = [2,d2;
                       3,d3];
stack(4).repeat=15;

stack(5).user_input = [2,d2];
                       
stack(5).repeat=1;

stack(6).user_input = [2,4*d2];
                       
stack(6).repeat=1;

stack(7).user_input = [2,d2;
                       3,d3];
stack(7).repeat=15;

stack(8).user_input = [2,9*d2];
                       
stack(8).repeat=1;

stack(9).user_input = [2,d2;
                       3,d3];
stack(9).repeat=15;

stack(10).user_input = [2,5*d2];
                       
stack(10).repeat=1;

stack(11).user_input = [2,d2;
                       3,d3];
stack(11).repeat=15;

stack(12).user_input = [2,d2];
                       
stack(12).repeat=1;

stack(13).user_input = [2,d2;
                       3,d3];
stack(13).repeat=7;

stack(14).user_input = [2,d2;
                       4,Inf]; %final layer of final stack is the semi-infinite transmission medium
stack(14).repeat=1;
%}

%%%%%%%%%%%%%END OF USER INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch save_field_data
    case 'no'
        %subroutine_Tmatrix_nofielddata calculates R and T as quickly as
        %possible (by taking advantage of periodicities in the stack), and
        %consequently can not calculate the field in each layer of the
        %stack
        subroutine_Tmatrix_nofielddata;

    
        figure;
        hold on;
        box on;
        grid on;
        set(gca,'FontSize',28)
        xlabel('k (cm^{-1})')
        ylabel('R,T')
        title(['g_o = ' num2str(gain) ' cm^{-1}'])
        set(gca,'XLim',[min(k0_spectroscopy) max(k0_spectroscopy)])
        set(gca,'YLim',[-0.01 max([max(T) max(R)])*1.01])
        plot(k0_spectroscopy,R,'r',k0_spectroscopy,T,'b','Linewidth',2)
        legend('R','T','Location','SouthWest')
        saveas(gcf,['g=' num2str(gain) 'cm.png'],'png')
        
        %{
        figure;
        hold on;
        box on;
        grid on;
        set(gca,'FontSize',28)
        xlabel('k (cm^{-1})')
        ylabel('\phi (r),\phi (t)  (\pi)')
        title(['g_o = ' num2str(gain) ' cm^{-1}'])
        set(gca,'XLim',[min(k0_spectroscopy) max(k0_spectroscopy)])
        set(gca,'YLim',[-1 1])
        plot(k0_spectroscopy,angle(E_ref)/pi,'r',k0_spectroscopy,angle(E_trans)/pi,'b','Linewidth',2)
        %set(gca,'YTick',[-1 -1/2 0 1/2 1])
        %set(gca,'YTickLabel',{\pi '-\pi/2' '0' '\pi/2' '\pi'})
        legend('\phi (r)','\phi (t)','Location','SouthWest')
        saveas(gcf,['g=' num2str(gain) 'cm_phase.png'],'png')
%}
   
        data = struct('k0_spectroscopy',k0_spectroscopy,'k0',k0,'material',material,'stack',stack,'R',R,'T',T);

      
        save(['gain' num2str(gain) '.mat'],'data')


    
    case 'yes'
        %subroutine_Tmatrix_fielddata creates a struct 'whole_stack' from
        %all the elements of 'stack', then calculates the field amplitudes
        %ER and EL in every layer and saves them in struct 'field_amp'.
        %The program cannot take advantage of any periodicities in the
        %stack, so it is slow relative to subroutine_Tmatrix_nofielddata.
        subroutine_Tmatrix_fielddata;

        field_data = struct('k0_spectroscopy',k0_spectroscopy,'k0',k0,'material',material,'stack',stack,'whole_stack',whole_stack,'field_amp',field_amp,'R',R,'T',T);

        fname = ['fielddata_gain' num2str(gain) '.mat'];
        save(fname,'field_data')
        
        plotfielddata(fname,1)

end