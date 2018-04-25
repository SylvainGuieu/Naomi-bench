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
        XCENTERc = 'phase x center position in pixel';
        XCENTERd = 64;
        
        YCENTER = 'YCENTER';
        YCENTERc = 'phase y center position in pixel';
        YCENTERd = 64;
        
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
        ZTCDIAMc = 'Pupill diameter used in [m]';
        ZTCDIAMd = 28.0e-3; % default is the naomi one
        
        NPP = 'NPP';
        NPPc = 'Number of push pull sequence for the measurement';
        
        NPHASE = 'NPHASE';
        NPHASEc = 'Number of averaged phase';
        
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
       
       TEMP0 = 'TEMP0'
       TEMP0c = '[deg celcius] temperature on the QSM';
       
       TEMP1 = 'TEMP1'
       TEMP1c = '[deg celcius] temperature on the QSM';
       
       
       %% default  for unknown  values in header 
       UNKNOWN_STR = '?';
       UNKNOWN_FLOAT = -999.99;
       UNKNOWN_INT = -999;
       
    end
end

