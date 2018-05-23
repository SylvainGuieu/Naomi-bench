classdef KEYS
    % this class define the conventional keys inside the header of naomi 
    % REMOVE keys with precotion make sure that nothink is useing it
    % This is to 
    % 1/ make sure that the keys have allways the same name
    % 2/ patch some missing keys (old file for instance) by defining some
    % defaults 
    %
    % Normaly the defaults are not needed because the data shoudl comme
    % with everything needed in the header. defaults are used in case the
    % keyword is not present in the data header. This is usefull mainly to
    % use old file with the same script 
    %
    % the convention is to put all the properties NAME in upper case
    % the NAMEc is the comment and NAMEd is the default if relevant
    properties (Constant)
        
        TPLNAME = 'TPL_NAME';
        TPLNAMEc = 'kind of the measurement';
        TPLNAMEd = 'test';
        
        DPRTYPE = 'DPR_TYPE';
        DPRTYPEc = 'Product name';
        
        ORIGIN = 'ORIGIN';
        ORIGINc = 'Where data has been taken IPAG/ESO-HQ/BENCH';
        ORIGINd = 'Bench';
        
        DATEOBS = 'DATE-OBS';
        DATEOBSc = 'Date of writing header';
        
        DATE = 'DATE';
        DATEc = 'file creation date (YYYY-MM-DDThh:mm:ss UT)';
        
        MJDOBS = 'MJD-OBS';
        MJDOBSc = 'Modified Julian Date of writing header';
        
        
        MPUPDIAM = 'MPUPDIAM';
        MPUPDIAMc = 'Masked Pupill Diamter [m]';
        
        MPUPDIAMPIX = 'MPUPDIAMP';
        MPUPDIAMPIXc = 'Masked Pupill Diamter [pixel]';
        
        MCOBSDIAM = 'MCODIAM';
        MCOBSDIAMc = 'Mask Central obscuration Diameter [m]';
        
        MCOBSDIAMPIX = 'MCODIAMP';
        MCOBSDIAMPIXc = 'Mask Central obscuration Diameter [pixel]';
        
        MNAME = 'MNAME';
        MNAMEc = 'Mask name or UNKNOWN';
        MNAMEd = 'UNKNOWN';
        
        FPUPDIAM = 'FPUPDIAM';
        FPUPDIAMc = 'Full DM Pupill Diamter [m]';
        FPUPDIAMd = 36.5e-3;
        
        
        
        CENTACT = 'CENTACT';
        CENTACTc = 'DM center actuator number';
        CENTACTd = 121;
        
        ACTNUM = 'ACTNUM';
        ACTNUMc = 'relevant actuator number pushed';
        
        IFAMP = 'IF_AMP';
        IFAMPc = '[Cmax] amplitude of push-pull';
        
        IFNPP =  'IF_NPP';
        IFNPPc = 'number of push-pull';
        
        IFNEXC = 'IF_NEXC';
        IFNEXCc = 'number of exclude pixel when/if cleaned';
        
        IFPERC= 'IF_PERC';
        IFPERCc = 'percentil to compute piston';
        
        
        
        
        IFMLOOP = 'IF_LOOP';
        IFMLOOPc = 'Number of cycle to compute the IFM';
        
        IFMPAUSE = 'IF_LOOP';
        IFMPAUSEc = '[s] between actuator';
        
        RXORDER = 'RXORDER';
        RXORDERc = 'tip or tilt movement of the rx motor';
        RXORDERd = 'tip';
        
        RYORDER = 'RYORDER';
        RYORDERc = 'tip or tilt movement of the rx motor';
        RYORDERd = 'tilt';
        
        RXSIGN = 'RXSIGN';
        RXSIGNc =  'Zernike sign or rx positive motor movement';
        RXSIGNd = -1;
        
        RYSIGN = 'RYSIGN';
        RYSIGNc =  'Zernike sign or ry positive motor movement';
        RYSIGNd = -1;
         
        VERSION  = 'VERSION';
        VERSIONc = 'naomi calibartion bench software version';
        
        ZERN = 'ZERN';
        ZERNc = '# zernike number';
        
        
        ORIENT = 'ORIENT';
        ORIENTc = 'Bench DM orientation compare to conventional zernike';
        ORIENTd = 'yx';
        
        XCENTER = 'XCENTER';
        XCENTERc = '[pix] X central actuator position';
        XCENTERd = 64;
        
        YCENTER = 'YCENTER';
        YCENTERc = '[pix] Y central actuator position';
        YCENTERd = 64;
        
        XPCENTER = 'XPCENTER';
        XPCENTERc = '[pix] Pupill trace center';
        XPCENTERd = 64;
        
        YPCENTER = 'YPCENTER';
        YPCENTERc = '[pix] Pupill trace center';
        YPCENTERd = 64;
        
        
        %%
        % these are normaly not writen in header but allow user to modify 
        % the centering and pupill size on the fly
        XOFFSET = 'XOFFSET';
        XOFFSETc = 'User offset in subpupill of the active pupill '
        YOFFSET = 'YOFFSET';
        YOFFSETc = 'User offset in subpupill of the active pupill '
        DIAMRESC = 'DIAMRESC'; 
        DIAMRESCc = 'Active pupill diameter rescale factor';
        
        XPSCALE = 'XPSCALE';
        XPSCALEc = '[m/pix] X pixel scale';
        XPSCALEd = 0.38e-3;
        
        YPSCALE = 'YPSCALE';
        YPSCALEc = '[m/pix] Y pixel scale';
        YPSCALEd = 0.38e-3;
        
        ZTCDIAM = 'ZTCDIAM';
        ZTCDIAMc = '[m] Pupill diameter used for ZtC';
        ZTCDIAMd = 28.0e-3; % default is the naomi one
        
        NPP = 'NPP';
        NPPc = 'Number of push pull sequence for the measurement';
        
        NPHASE = 'NPHASE';
        NPHASEc = 'Number of averaged phase';
        
        PHASEREF = 'PHASEREF';
        PHASEREFc = '0/1 1 if a phase reference has been substracted';
        
        PHASETT = 'PHASETT';
        PHASETTc = '0/1 1 if main tiptilt has been removed';
        
        
        PUSHAMP = 'PUSHAMP';
        PUSHAMPc = '[max] Push (and Pull) amplitude';
        
        NZERN = 'NZERN';
        NZERNc = '[#] number of zernikes';
        
        LOOP = 'LOOP';
        LOOPc = '[OPEN/CLOSED] loop status';
        
        DMNAME = 'DM_NAME';
        DMNAMEc = 'ALPAO Serial Number of DM ';
        
        DMEID = 'DME_ID';
        DMEIDc = 'Serial Number of DM Electronics';
        
        DMID   = 'DM_ID';
        DMIDc = 'serial Number of DM';
        
        DMNACT = 'DM_NACT';
        DMNACTc = 'DM  Number of actuactor ';
        
        ZTCNEIG= 'ZTC_NEIG';
        ZTCNEIGc =  'accepted Eigenvalues';
        
        ZTCNZERN= 'ZTC_NZER';
        ZTCNZERNc = 'number of zernikes kep for ZtC';
        
        WFSNSUB = 'WFS_NSUB';
        WFSNSUBc = 'Number of subapperture of wavefront sensor';
        
        WFSNAME = 'WFS_NAME';
        WFSNAMEc = 'Model of wavefront sensor';
        
       AMPLITUD = 'AMPLITUD';
       AMPLITUDc = 'Amplitude applied';
       
       LOOPMODE = 'LOOPMODE';
       LOOPMODEc = 'mode modal or zonal used to close loop';
       
       LOOPGAIN = 'LOOPGAIN';
       LOOPGAINc = 'Gain applied to close loop';
        
       LOOPSTEP = 'LOOPSTEP';
       LOOPSTEPc = 'Total number step for closing the loop';
       
       LOOPNZER = 'LOOPNZER';
       LOOPNZERc = 'Number of zernike used to close the loop';
       
       GAIN = 'GAIN';
       GAINc = 'Gain computed over the entire ZtP array';
       
       GBID = 'GB_ID';
       GBIDc = 'Gimbal serial number';
       GBIDd = 0;
       
       RXPOS = 'RX_POS';
       RXPOSc = '[mm] gimbal rX motor position';
       
       RYPOS = 'RY_POS';
       RYPOSc = '[mm] gimbal rY motor position';
       
       RXZERO = 'RX_ZERO';
       RXZEROc = '[mm] gimbal rX motor home position';
       
       RYZERO = 'RY_ZERO';
       RYZEROc = '[mm] gimbal rY motor home position';
       
       RXGAIN = 'RX_GAIN';
       RXGAINc = '[arcsec mecanical/mm] gain convertion of motor rX';
       
       RYGAIN = 'RY_GAIN';
       RYGAINc = '[arcsec mecanical/mm] gain convertion of motor rY';
       
       TIME = 'TIME';
       TIMEc = 'matlab time';
       
       TEMPMIRROR = 'TEMPMIR';
       TEMPMIRRORc = '[C] Temperature of the Mirror';
       
       TEMPQSM= 'TEMPQSM';
       TEMPQSMc = '[C] Temperature of the Qsm';
       
       TEMPIN= 'TEMPIN';
       TEMPINc = '[C] Temperature of the Pletier inner face';

       TEMPOUT= 'TEMPOUT';
       TEMPOUTc = '[C] Temperature of the Pletier outer face';
       
       TEMPEMBIANT= 'TEMPEMBI';
       TEMPEMBIANTc = '[C] Embiant temperature';
       
       TEMPREGUL= 'TEMPREGU';
       TEMPREGULc = '[C] Set Regulation temperature';
       
       PCURRENT = 'PCURRENT';
       PCURRENTc = '[A] Peltier current';
       
       PFANIN = 'PFANIN';
       PFANINc = '[V] Inner fan voltage';
       
       PFANOUT = 'PFANOUT';
       PFANOUTc = '[V] Outer fan voltage';
       
       HUMIDITY = 'HUMIDITY';
       HUMIDITYc = '[%] Embiant humidity';
       
       
       
       TEMP0 = 'TEMP0'
       TEMP0c = '[deg celcius] temperature on the QSM';
       
       TEMP1 = 'TEMP1'
       TEMP1c = '[deg celcius] temperature on the QSM';
       
       DATEOB = 'DATE-OB';
       DATEOBc = 'matlab date of block started';
       
       NAMP = 'NAMP';
       NAMPc = 'Number of mode amplitude played';
       
       %% Some other constant
       % For loop mode 
       CLOSED = 'CLOSED'; % loop mode
       OPENED = 'OPEN'; 
       MODAL = 'modal';
       ZONAL = 'zonal';
       
       %% default  for unknown  values in header 
       UNKNOWN_STR = '?';
       UNKNOWN_FLOAT = -999.99;
       UNKNOWN_INT = -999;
       
       %% define names of GUIs here 
       G_STARTUP = 'Naomi Startup';
       G_ALIGNMENT = 'Naomi Alignment';
       G_CALIB = 'Naomi Calibration';
       G_IFM_MEASUREMENT = 'Naomi IFM Measurement';
       G_MAIN = 'Naomi Engeneering';
       G_ENVIRONMENT = 'Naomi Environment Control';
    end
end

