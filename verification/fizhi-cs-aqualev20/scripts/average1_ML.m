%
%  $Id: average1_ML.m,v 1.1 2006/04/03 20:55:29 molod Exp $
%
%  Ed Hill
%
%  Generate the APE ML01--ML07 and ME01--ME07 fields:
%
%    For all facets:
%      For all time steps:
%        For all variables:
%          Create a mask based on THETA == 0.0
%          For all variables:
%            compute partial sum wrt mask
%            compute number contributing wrt mask
%      Compute the averages from the partial sums & num contrib
%      Write netCDF output for this facet:
%

%======================================================================

files = { ...
{ 'mnc_out_144000/MLfields.0000136800.t%03d.nc' }; ...
{ 'mnc_out_151200/MLfields.0000144000.t%03d.nc' }; ...
{ 'mnc_out_158400/MLfields.0000151200.t%03d.nc' }; ...
{ 'mnc_out_165600/MLfields.0000158400.t%03d.nc' }; ...
{ 'mnc_out_172800/MLfields.0000165600.t%03d.nc' }; ...
{ 'mnc_out_180000/MLfields.0000172800.t%03d.nc' }; ...
{ 'mnc_out_187200/MLfields.0000180000.t%03d.nc' }; ...
{ 'mnc_out_194400/MLfields.0000187200.t%03d.nc' }; ...
{ 'mnc_out_201600/MLfields.0000194400.t%03d.nc' }; ...
{ 'mnc_out_208800/MLfields.0000201600.t%03d.nc' }; ...
{ 'mnc_out_216000/MLfields.0000208800.t%03d.nc' }; ...
{ 'mnc_out_223200/MLfields.0000216000.t%03d.nc' }; ...
{ 'mnc_out_230400/MLfields.0000223200.t%03d.nc' }; ...
{ 'mnc_out_237600/MLfields.0000230400.t%03d.nc' }; ...
{ 'mnc_out_244800/MLfields.0000237600.t%03d.nc' }; ...
{ 'mnc_out_252000/MLfields.0000244800.t%03d.nc' }; ...
{ 'mnc_out_259200/MLfields.0000252000.t%03d.nc' }; ...
{ 'mnc_out_266400/MLfields.0000259200.t%03d.nc' }; ...
{ 'mnc_out_273600/MLfields.0000266400.t%03d.nc' }; ...
{ 'mnc_out_280800/MLfields.0000273600.t%03d.nc' }; ...
{ 'mnc_out_288000/MLfields.0000280800.t%03d.nc' }; ...
{ 'mnc_out_295200/MLfields.0000288000.t%03d.nc' }; ...
{ 'mnc_out_302400/MLfields.0000295200.t%03d.nc' }; ...
{ 'mnc_out_309600/MLfields.0000302400.t%03d.nc' }; ...
{ 'mnc_out_316800/MLfields.0000309600.t%03d.nc' }; ...
{ 'mnc_out_324000/MLfields.0000316800.t%03d.nc' }; ...
{ 'mnc_out_331200/MLfields.0000324000.t%03d.nc' }; ...
{ 'mnc_out_338400/MLfields.0000331200.t%03d.nc' }; ...
{ 'mnc_out_345600/MLfields.0000338400.t%03d.nc' }; ...
{ 'mnc_out_352800/MLfields.0000345600.t%03d.nc' }; ...
{ 'mnc_out_360000/MLfields.0000352800.t%03d.nc' }; ...
{ 'mnc_out_367200/MLfields.0000360000.t%03d.nc' }; ...
{ 'mnc_out_374400/MLfields.0000367200.t%03d.nc' }; ...
{ 'mnc_out_381600/MLfields.0000374400.t%03d.nc' }; ...
{ 'mnc_out_388800/MLfields.0000381600.t%03d.nc' }; ...
{ 'mnc_out_396000/MLfields.0000388800.t%03d.nc' }; ...
{ 'mnc_out_403200/MLfields.0000396000.t%03d.nc' }; ...
{ 'mnc_out_410400/MLfields.0000403200.t%03d.nc' }; ...
{ 'mnc_out_417600/MLfields.0000410400.t%03d.nc' }; ...
{ 'mnc_out_424800/MLfields.0000417600.t%03d.nc' }; ...
{ 'mnc_out_432000/MLfields.0000424800.t%03d.nc' }; ...
{ 'mnc_out_439200/MLfields.0000432000.t%03d.nc' }; ...
{ 'mnc_out_446400/MLfields.0000439200.t%03d.nc' }; ...
{ 'mnc_out_453600/MLfields.0000446400.t%03d.nc' }; ...
{ 'mnc_out_460800/MLfields.0000453600.t%03d.nc' }; ...
{ 'mnc_out_468000/MLfields.0000460800.t%03d.nc' }; ...
{ 'mnc_out_475200/MLfields.0000468000.t%03d.nc' }; ...
{ 'mnc_out_482400/MLfields.0000475200.t%03d.nc' }; ...
{ 'mnc_out_489600/MLfields.0000482400.t%03d.nc' }; ...
{ 'mnc_out_496800/MLfields.0000489600.t%03d.nc' }; ...
{ 'mnc_out_504000/MLfields.0000496800.t%03d.nc' }; ...
{ 'mnc_out_511200/MLfields.0000504000.t%03d.nc' }; ...
{ 'mnc_out_518400/MLfields.0000511200.t%03d.nc' }; ...
{ 'mnc_out_525600/MLfields.0000518400.t%03d.nc' }; ...
{ 'mnc_out_532800/MLfields.0000525600.t%03d.nc' }; ...
{ 'mnc_out_540000/MLfields.0000532800.t%03d.nc' }; ...
{ 'mnc_out_547200/MLfields.0000540000.t%03d.nc' }; ...
{ 'mnc_out_554400/MLfields.0000547200.t%03d.nc' }; ...
{ 'mnc_out_561600/MLfields.0000554400.t%03d.nc' }; ...
{ 'mnc_out_568800/MLfields.0000561600.t%03d.nc' }; ...
{ 'mnc_out_576000/MLfields.0000568800.t%03d.nc' }; ...
{ 'mnc_out_583200/MLfields.0000576000.t%03d.nc' }; ...
{ 'mnc_out_590400/MLfields.0000583200.t%03d.nc' }; ...
{ 'mnc_out_597600/MLfields.0000590400.t%03d.nc' }; ...
{ 'mnc_out_604800/MLfields.0000597600.t%03d.nc' }; ...
{ 'mnc_out_612000/MLfields.0000604800.t%03d.nc' }; ...
{ 'mnc_out_619200/MLfields.0000612000.t%03d.nc' }; ...
{ 'mnc_out_626400/MLfields.0000619200.t%03d.nc' }; ...
{ 'mnc_out_633600/MLfields.0000626400.t%03d.nc' }; ...
{ 'mnc_out_640800/MLfields.0000633600.t%03d.nc' }; ...
{ 'mnc_out_648000/MLfields.0000640800.t%03d.nc' }; ...
{ 'mnc_out_655200/MLfields.0000648000.t%03d.nc' }; ...
{ 'mnc_out_662400/MLfields.0000655200.t%03d.nc' }; ...
{ 'mnc_out_669600/MLfields.0000662400.t%03d.nc' }; ...
{ 'mnc_out_676800/MLfields.0000669600.t%03d.nc' }; ...
{ 'mnc_out_684000/MLfields.0000676800.t%03d.nc' }; ...
{ 'mnc_out_691200/MLfields.0000684000.t%03d.nc' }; ...
{ 'mnc_out_698400/MLfields.0000691200.t%03d.nc' }; ...
{ 'mnc_out_705600/MLfields.0000698400.t%03d.nc' }; ...
{ 'mnc_out_712800/MLfields.0000705600.t%03d.nc' }; ...
{ 'mnc_out_720000/MLfields.0000712800.t%03d.nc' }; ...
{ 'mnc_out_727200/MLfields.0000720000.t%03d.nc' }; ...
{ 'mnc_out_734400/MLfields.0000727200.t%03d.nc' }; ...
{ 'mnc_out_741600/MLfields.0000734400.t%03d.nc' }; ...
{ 'mnc_out_748800/MLfields.0000741600.t%03d.nc' }; ...
{ 'mnc_out_756000/MLfields.0000748800.t%03d.nc' }; ...
{ 'mnc_out_763200/MLfields.0000756000.t%03d.nc' }; ...
{ 'mnc_out_770400/MLfields.0000763200.t%03d.nc' }; ...
{ 'mnc_out_777600/MLfields.0000770400.t%03d.nc' }; ...
{ 'mnc_out_784800/MLfields.0000777600.t%03d.nc' }; ...
{ 'mnc_out_792000/MLfields.0000784800.t%03d.nc' }; ...
{ 'mnc_out_799200/MLfields.0000792000.t%03d.nc' }; ...
{ 'mnc_out_806400/MLfields.0000799200.t%03d.nc' }; ...
{ 'mnc_out_813600/MLfields.0000806400.t%03d.nc' }; ...
{ 'mnc_out_820800/MLfields.0000813600.t%03d.nc' }; ...
{ 'mnc_out_828000/MLfields.0000820800.t%03d.nc' }; ...
{ 'mnc_out_835200/MLfields.0000828000.t%03d.nc' }; ...
{ 'mnc_out_842400/MLfields.0000835200.t%03d.nc' }; ...
{ 'mnc_out_849600/MLfields.0000842400.t%03d.nc' }; ...
{ 'mnc_out_856800/MLfields.0000849600.t%03d.nc' }; ...
{ 'mnc_out_864000/MLfields.0000856800.t%03d.nc' }; ...
{ 'mnc_out_871200/MLfields.0000864000.t%03d.nc' }; ...
{ 'mnc_out_878400/MLfields.0000871200.t%03d.nc' }; ...
{ 'mnc_out_885600/MLfields.0000878400.t%03d.nc' }; ...
{ 'mnc_out_892800/MLfields.0000885600.t%03d.nc' }; ...
{ 'mnc_out_900000/MLfields.0000892800.t%03d.nc' }; ...
{ 'mnc_out_907200/MLfields.0000900000.t%03d.nc' }; ...
};

vars = { ...
    {'u','UVEL','masku'} ...
    {'v','VVEL','maskv'} ...
    {'w','WVEL','mask'} ...
    {'phi','PHIHYD','mask'} ...
    {'q','SALT','mask'} ...
    {'rh','RELHUM','mask'} ...
    {'th','THETA','mask'} ...
       };

%======================================================================
%
%  Interpolate to the reference pressure levels and then compute the
%  derived fields and the temporal sums of all fields on the original
%  MITgcm grid
%
disp('Computing Sums')

itile = 1;
for itile = 1:3
  
  it0 = 0;
  for iv = 1:length(vars)
    eval(sprintf('clear %s', vars{iv}{1} ));
  end
  
  fi = 1;
  for fi = [ 1:length(files) ]

    fib = 0;
  
    fname = sprintf(files{fi}{1},itile);
    disp([ '  fname = "' fname '"' ]);
    nc = netcdf(fname, 'nowrite');
    times = nc{'T'}(:);

    it = 1;
    for it = 1:length(times)
      
      for iv = 1:length(vars)
        eval(sprintf('%s = squeeze(nc{ ''%s'' }(it,:,:,:));', ...
                     vars{iv}{1},vars{iv}{2}));
        eval(sprintf('mr = max(abs(%s(:)));', vars{iv}{1}));
        if mr > 1e10
          %  error('values heading out of range!!!');
          fib = 1;
        end
      end

      mask = double(th ~= 0.0);
      masku = ones(size(th) + [0 0 1]);
      masku(:,:,1:(end-1)) = masku(:,:,1:(end-1)) .* mask;
      masku(:,:,2:end    ) = masku(:,:,2:end    ) .* mask;
      maskv = ones(size(th) + [0 1 0]);
      maskv(:,1:(end-1),:) = maskv(:,1:(end-1),:) .* mask;
      maskv(:,2:end,    :) = maskv(:,2:end,    :) .* mask;
      
      if it0 == 0
        it0 = 1;
        for iv = 1:length(vars)
          eval(sprintf('%s_ave = zeros(size(%s));', ...
                       vars{iv}{1},vars{iv}{1}));
        end
        mask_sum = zeros(size(mask));
        masku_sum = zeros(size(masku));
        maskv_sum = zeros(size(maskv));
      end
      for iv = 1:length(vars)
        eval(sprintf('%s_ave = %s_ave + (%s .* %s);', ...
                     vars{iv}{1}, vars{iv}{1}, ...
                     vars{iv}{3}, vars{iv}{1}));
      end
      mask_sum = mask_sum + mask;
      masku_sum = masku_sum + masku;
      maskv_sum = maskv_sum + maskv;
      
    end
    
    if fib == 1
      disp([ 'BAD ::  "' fname '"' ]);
    end
    
    nc = close(nc);
    
  end

  for iv = 1:length(vars)
    eval(sprintf('%s_ave = %s_ave ./ %s_sum;', ...
                 vars{iv}{1}, vars{iv}{1}, vars{iv}{3} ));
  end
  
  nc = netcdf(sprintf('mnc_out_processed/ML_ave_%d.nc',itile), 'clobber');
  
  nc('T') = 0;
  nc('Z') = 17;
  nc('X') = 32;   nc('Xp1') = 33;
  nc('Y') = 32;   nc('Yp1') = 33;
  
  for iv = 1:length(vars)
    switch vars{iv}{3}
     case 'mask'
      nc{ vars{iv}{2} } = ncdouble( 'T', 'Z', 'Y', 'X' );
     case 'masku'
      nc{ vars{iv}{2} } = ncdouble( 'T', 'Z', 'Y', 'Xp1' );
     case 'maskv'
      nc{ vars{iv}{2} } = ncdouble( 'T', 'Z', 'Yp1', 'X' );
    end
    eval(sprintf('nc{ vars{iv}{2} }(1,:,:,:) = %s_ave;',vars{iv}{1}));
  end
  nc{ 'mask_sum' } = ncdouble( 'T', 'Z', 'Y', 'X' );
  nc{ 'mask_sum' }(1,:,:,:) = mask_sum;
  nc{ 'masku_sum' } = ncdouble( 'T', 'Z', 'Y', 'Xp1' );
  nc{ 'masku_sum' }(1,:,:,:) = masku_sum;
  nc{ 'maskv_sum' } = ncdouble( 'T', 'Z', 'Yp1', 'X' );
  nc{ 'maskv_sum' }(1,:,:,:) = maskv_sum;
  nc = close(nc);

end

