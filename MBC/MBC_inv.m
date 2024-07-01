function xi_R = MBC_inv(psi,xi_NR)
% MBC_inv Inverse of Multiblade coordinate transfomation as per Coleman [1943]
% Input:
%       * psi : Time history of azimutal position of each blade, [blade, n]
%       * xi_NR: Time history of non-rotating coodinates of each blade, [blade, n]
% Ouput:
%       * xi_R: Rotating degrees of freedom or lead-lag angles of blades, [blade, n]
%
% see also rotmat, MBC
xi_R = zeros(size(xi_NR));
Nb = size(xi_R,1);
for ii = 1: size(xi_NR,2)
    T = rotmat(Nb,psi(:,ii));
    xi_R(:,ii) = T*xi_NR(:,ii);
end

end