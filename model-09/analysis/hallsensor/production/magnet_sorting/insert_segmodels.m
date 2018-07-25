function ring = insert_segmodels(ring, data, fam_data, indcs)

B_idx = fam_data.B.ATIndex;

for ii=1:length(B_idx)
    segmod = data.segmodels{indcs(ii)};
    idx = B_idx(ii,:);
    for jj=1:length(idx)
        ring{idx(jj)} = segmod{jj};
    end
end
